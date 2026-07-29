#!/usr/bin/env node
// Tokenize the golden corpus with syntaxes/ddot.tmLanguage.json and diff the
// result against each case's expected.tokens.json.
//
//   node tools/test-grammar.mjs            # verify; non-zero exit on mismatch
//   node tools/test-grammar.mjs --update   # accept current output as baseline
//   node tools/test-grammar.mjs 03 17      # only cases whose name contains 03 / 17
//
// The grammar emits TextMate scopes; the corpus asserts canonical *role* names
// (see test-data/tokens.md). SCOPE_TO_ROLE below is the mapping between the two.
// Within one token the DEEPEST matching scope wins, so a field that is entirely
// a command (e.g. `ddot.it/this` as a subject) reports `command`, not `subject`.

import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";
import { createRequire } from "node:module";

const require = createRequire(import.meta.url);
// Both packages are CommonJS; require() them so their exports resolve properly.
const oniguruma = require("vscode-oniguruma");
const vsctm = require("vscode-textmate");
const ROOT = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const CASES = path.join(ROOT, "test-data", "cases");
const GRAMMAR = path.join(ROOT, "syntaxes", "ddot.tmLanguage.json");

const SCOPE_TO_ROLE = {
  "entity.name.subject.ddot": "subject",
  "entity.name.relation.ddot": "relation",
  "entity.name.object.ddot": "object",
  "keyword.operator.doubledot.ddot": "doubledot",
  "keyword.control.command.ddot": "command",
  "punctuation.section.meta.ddot": "meta-delim",
  "punctuation.separator.meta.ddot": "meta-separator",
  "keyword.operator.doubledot.meta.ddot": "meta-doubledot",
  "entity.name.relation.meta.ddot": "meta-relation",
  "entity.name.object.meta.ddot": "meta-object",
  "entity.name.object.meta.text.ddot": "meta-text",
  "comment.block.excluded.ddot": "excluded",
  "string.unquoted.block.ddot": "verbatim",
  "variable.parameter.block-end.ddot": "block-end",
  "variable.parameter.command.ddot": "command-param",
};

async function makeRegistry() {
  const wasm = fs.readFileSync(require.resolve("vscode-oniguruma/release/onig.wasm"));
  await oniguruma.loadWASM(wasm.buffer);
  return new vsctm.Registry({
    onigLib: Promise.resolve({
      createOnigScanner: (s) => new oniguruma.OnigScanner(s),
      createOnigString: (s) => new oniguruma.OnigString(s),
    }),
    loadGrammar: async (scopeName) => {
      if (scopeName !== "source.ddot") return null;
      const raw = fs.readFileSync(GRAMMAR, "utf8");
      return vsctm.parseRawGrammar(raw, GRAMMAR);
    },
  });
}

// Map a scope stack to a role: deepest (last) recognized scope wins.
function roleOf(scopes) {
  for (let i = scopes.length - 1; i >= 0; i--) {
    const r = SCOPE_TO_ROLE[scopes[i]];
    if (r) return r;
  }
  return null;
}

function tokenizeFile(grammar, text) {
  const lines = text.split(/\r\n|\r|\n/);
  let ruleStack = vsctm.INITIAL;
  const out = [];

  lines.forEach((line, lineNo) => {
    const res = grammar.tokenizeLine(line, ruleStack);
    ruleStack = res.ruleStack;

    // Collapse adjacent raw tokens that share a role, then trim whitespace.
    const spans = [];
    for (const t of res.tokens) {
      const role = roleOf(t.scopes);
      if (!role) continue;
      const prev = spans[spans.length - 1];
      if (prev && prev.role === role && prev.end === t.startIndex) {
        prev.end = t.endIndex;
      } else {
        spans.push({ role, start: t.startIndex, end: t.endIndex });
      }
    }

    for (const s of spans) {
      // vscode-textmate reports the implicit trailing newline as part of a
      // contentName region, so a span can end one past the line. Clamp it.
      let { start } = s;
      let end = Math.min(s.end, line.length);
      while (start < end && /[ \t]/.test(line[start])) start++;
      while (end > start && /[ \t]/.test(line[end - 1])) end--;
      if (start >= end) continue;
      out.push({
        line: lineNo,
        start,
        end,
        token: s.role,
        text: line.slice(start, end),
      });
    }
  });

  return out;
}

function fmt(t) {
  return `L${t.line} [${t.start}:${t.end}] ${t.token} ${JSON.stringify(t.text)}`;
}

function diff(expected, actual) {
  const problems = [];
  const n = Math.max(expected.length, actual.length);
  for (let i = 0; i < n; i++) {
    const e = expected[i];
    const a = actual[i];
    if (!e) { problems.push(`  +extra   ${fmt(a)}`); continue; }
    if (!a) { problems.push(`  -missing ${fmt(e)}`); continue; }
    if (e.line !== a.line || e.start !== a.start || e.end !== a.end || e.token !== a.token || e.text !== a.text) {
      problems.push(`  expected ${fmt(e)}\n  actual   ${fmt(a)}`);
    }
  }
  return problems;
}

const args = process.argv.slice(2);
const update = args.includes("--update");
const filters = args.filter((a) => !a.startsWith("--"));

const registry = await makeRegistry();
const grammar = await registry.loadGrammar("source.ddot");
if (!grammar) { console.error("could not load source.ddot"); process.exit(2); }

let dirs = fs.readdirSync(CASES).filter((d) => fs.statSync(path.join(CASES, d)).isDirectory()).sort();
if (filters.length) dirs = dirs.filter((d) => filters.some((f) => d.includes(f)));

let pass = 0;
const failed = [];

for (const d of dirs) {
  const input = fs.readFileSync(path.join(CASES, d, "input.ddot"), "utf8");
  const expectedPath = path.join(CASES, d, "expected.tokens.json");
  const actual = tokenizeFile(grammar, input);

  if (update) {
    fs.writeFileSync(expectedPath, JSON.stringify(actual, null, 2) + "\n");
    console.log(`updated ${d} (${actual.length} tokens)`);
    continue;
  }

  const expected = JSON.parse(fs.readFileSync(expectedPath, "utf8"));
  const problems = diff(expected, actual);
  if (problems.length === 0) {
    console.log(`  ok   ${d}  (${actual.length} tokens)`);
    pass++;
  } else {
    console.log(`FAIL   ${d}`);
    for (const p of problems) console.log(p);
    failed.push(d);
  }
}

if (update) process.exit(0);

console.log(`\n${pass}/${dirs.length} cases pass`);
if (failed.length) {
  console.log(`failing: ${failed.join(", ")}`);
  process.exit(1);
}
