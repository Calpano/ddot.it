source 'https://rubygems.org'

gem "jekyll", "~> 4.4"
gem "just-the-docs", "~> 0.12"

gem "jekyll-readme-index"
gem "jekyll-optional-front-matter"
gem "jekyll-titles-from-headings"
gem "jekyll-relative-links"

# Renders site/spec/*.adoc. NOT on the GitHub Pages plugin whitelist — fine here,
# because .github/workflows/pages.yml builds with `bundle exec jekyll build`
# rather than letting GitHub Pages build the site itself.
gem "jekyll-asciidoc", "~> 3.0"
gem "asciidoctor", "~> 2.0"

# Rouge lexer for ddot.it, so `[source,ddot.it]` blocks in site/spec/*.adoc are
# highlighted rather than rendering flat.
#
# Must sit in :jekyll_plugins — that is the group Jekyll requires. The 0.1.3
# floor matters twice over: 0.1.1 carries `# frozen_string_literal: true`, which
# makes Rouge raise FrozenError on any block holding a non-triple line (a build
# crash on this repo's own examples), and before 0.1.3 the gem shipped no
# lib/rouge-ddot.rb, so it needed an explicit `require: "rouge/lexers/ddot"`.
#
# The lexer is canonical in ddot.it-syntax-tools, conformance-tested there
# against test-data/cases/. A lexer change therefore needs a gem release before
# this site picks it up.
group :jekyll_plugins do
  gem "rouge-ddot", "~> 0.1.3"
end

gem "webrick" # required for Ruby >= 3
