#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Regenerates `expected.body.html` for every case under `cases/` by running
# the canonical ddot.it preview renderer against `input.ddot`.
#
# The renderer source lives in the IntelliJ plugin repo
# (`ddot.it-intellij/src/main/resources/com/calpano/ddot/asciidoc/ddot-render.rb`)
# so there's exactly one Ruby implementation, shared between:
#   - the AsciidoctorJ extension installed into `<root>/.asciidoctor/lib/`,
#   - this regen script,
#   - the `expected.body.html` files committed here.
#
# A separate Java implementation in `DdotMarkdownPreviewRenderer.java` must
# produce the same `body(...)` output for each input — that equivalence is the
# point of this corpus. Wire it up by reading these files from a JUnit test in
# the IntelliJ project; assert byte-identical match to `expected.body.html`.
#
# Usage:
#   ruby test-data/preview-html/regenerate.rb            # writes/overwrites expected.body.html
#   ruby test-data/preview-html/regenerate.rb --check    # exits non-zero if any case is stale (CI)

require 'pathname'

ROOT          = Pathname.new(__dir__).realpath
CASES_DIR     = ROOT / 'cases'
RENDERER_PATH = ROOT.join('..', '..', '..', 'ddot.it-intellij', 'src', 'main', 'resources',
                          'com', 'calpano', 'ddot', 'asciidoc', 'ddot-render.rb')

unless RENDERER_PATH.file?
  abort "Cannot find canonical renderer at #{RENDERER_PATH}.\n" \
        "Expected layout: ../ddot.it/test-data/  +  ../ddot.it-intellij/  side by side."
end
require RENDERER_PATH.to_s

mode  = ARGV.first == '--check' ? :check : :write
stale = []

CASES_DIR.children.sort.each do |case_dir|
  next unless case_dir.directory?
  input    = case_dir / 'input.ddot'
  expected = case_dir / 'expected.body.html'
  unless input.file?
    warn "skip #{case_dir.basename}: missing input.ddot"
    next
  end

  actual    = DdotIt::Render.body(input.read)
  current   = expected.file? ? expected.read : nil
  identical = current == actual

  case mode
  when :write
    if identical
      puts "ok    #{case_dir.basename}"
    else
      expected.write(actual)
      puts "wrote #{case_dir.basename}"
    end
  when :check
    if identical
      puts "ok    #{case_dir.basename}"
    else
      stale << case_dir.basename.to_s
      puts "STALE #{case_dir.basename}"
    end
  end
end

if mode == :check && !stale.empty?
  warn "\n#{stale.size} case(s) stale: #{stale.join(', ')}"
  warn 'Run `ruby test-data/preview-html/regenerate.rb` to refresh.'
  exit 1
end
