# CLAUDE.md

Jeongsang Ryu's personal academic site. Single hand-written `index.html` + `stylesheet.css`, modeled on
[jonbarron.github.io](https://github.com/jonbarron/jonbarron.github.io) (table-based layout, Lato font,
blue/orange links, `.papertitle`/`.highlight`/`.name` classes) and its fork
[hogyun2.github.io](https://github.com/hogyun2/hogyun2.github.io) (added the dated "News" list pattern,
which this site also uses). This replaced an earlier [al-folio](https://github.com/alshedivat/al-folio)
(Jekyll) version — that whole toolchain (Ruby gems, `_config.yml`, collections, etc.) is gone. If you see
references to it in old commits, they're stale.

## Everything is in `index.html`

No CMS, no data files, no templating — one page, edited directly. Sections top to bottom: header
(name/photo/bio/contact links), Research, News (awards, dated), Projects (UNICORN Racing, UNIST
Autonomous Shuttle Bus), Publications (empty), Education, Experience, Teaching, Service, Skills.

`stylesheet.css` adds two custom block types on top of jonbarron's original CSS (which only styled a
publication-list page, nothing CV-shaped):
- `.news-list` / `.news-date` — the dated one-liners in News.
- `.entry-list` / `.entry-date` / `.entry-body` / `.entry-sub` — the Education/Experience/Teaching/Service
  rows (date column + bold title + muted subtitle).

The `Projects` table rows follow jonbarron's own publication-row pattern directly (thumbnail cell +
title/venue/description/links cell) — that part didn't need a new CSS class, just reuse `.papertitle`.

## Content duplication with the CV PDF pipeline

The downloadable CV PDF (`assets/pdf/cv.pdf`, linked from the header) does **not** come from this repo.
It's generated in `~/personal` (outside this repo, in the Papers Obsidian vault):
`~/personal/data/profile.json` → `~/personal/scripts/generate.py` → `~/personal/cv.tex` → `pdflatex` →
copy into `assets/pdf/cv.pdf` here. This means Education/Experience/Teaching/Service/Awards content is
now maintained in **two places that don't auto-sync**: `index.html` (for the webpage) and
`~/personal/data/profile.json` (for the PDF). If you add/change a CV-shaped entry, update both, or they
drift apart silently. `~/personal/portfolio.md` has the fuller writeup of that pipeline.

## Legacy assets

`assets/legacy/` — real photos/logos (UNICORN Racing team + car, an advisor photo, F1TENTH Grand Prix
event photos) recovered from git history of an even-earlier chirpy-theme Jekyll version of this site.
Not linked from any page. See `assets/legacy/README.md`.

## Deploy

No CI, no build. `.nojekyll` at the root tells GitHub Pages to skip its own Jekyll processing and serve
the files as-is. Pages source (Settings → Pages) is "Deploy from a branch" → `main`, path `/`. Push to
`main` and the live site updates within roughly a minute — no Actions run to watch, no Ruby/gem version
risk (unlike the old al-folio setup, which needed `bundle exec jekyll build` in CI and had two real
incidents around pip caching and Pages branch/`.nojekyll` mismatches — none of that machinery exists
anymore, so those specific failure modes can't recur here).

## Related repos

- `~/personal/tools` (https://github.com/jeongsang-ryu/tools, live at
  https://jeongsang-ryu.github.io/tools/) — same plain-static-HTML approach, a separate "Project Pages"
  site for small standalone tools (currently: Gaussian Area Shading, a paper-figure generator). Linked
  from this site's header.
- `~/personal/jeongsang-ryu` (https://github.com/jeongsang-ryu/jeongsang-ryu) — the GitHub profile
  README, managed independently of this site.
