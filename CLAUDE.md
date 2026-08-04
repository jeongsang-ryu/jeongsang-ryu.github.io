# CLAUDE.md

Jeongsang Ryu's personal academic site. Single hand-written `index.html` + `stylesheet.css`, forked
directly from [hogyun2.github.io](https://github.com/hogyun2/hogyun2.github.io) (which itself forks
[jonbarron.github.io](https://github.com/jonbarron/jonbarron.github.io)) — sticky nav with active-section
highlighting, light/dark theme toggle (persisted in `localStorage`), blue accent color scheme, News
cards, a paper/project card grid, and gradient-header "ETC" cards. Content and a few sections were
swapped for Jeongsang's; the CSS is hogyun2's file essentially as-is. This replaced an earlier
[al-folio](https://github.com/alshedivat/al-folio) (Jekyll) version and, before that, a plainer
jonbarron-only static version — that history is stale, ignore old commits referencing either.

## Everything is in `index.html`

No CMS, no data files, no build step, no templating — one page, edited directly, vanilla JS inline at
the bottom (theme toggle, smooth-scroll nav, `IntersectionObserver` for active-nav-link highlighting).
Font Awesome + Academicons icon fonts loaded from cdnjs (matches hogyun2's setup).

Sections top to bottom, each an `id`-tagged `<section>` matching a nav link's `data-section`:
- `#profile` — header: photo, name, bio, contact link pills (Email, Gmail, CV, GitHub, Tools), theme toggle
- `#news` — `.news-grid` of `.news-item` cards (Awards, dated `[YYYY]` — no day-level precision known)
- `#projects` — reuses hogyun2's `.papers`/`.paper` card grid (built for a publications list) for
  Projects instead, since there are no publications yet; `.paper.highlighted` gets the gold gradient +
  ✨ treatment (currently on UNICORN Racing)
- `#publications` — plain "None yet." placeholder, reuses `.research` section styling
- `#cv` — Education + Experience, reusing `.news-grid`/`.news-item` again (same visual language, no new CSS)
- `#etc` — `.etc-grid` of `.etc-card`s: Teaching, Service, Skills (hogyun2 only had 2 cards; a 3rd for
  Skills was added, same markup pattern)

No new CSS classes were added beyond what hogyun2 already had — everything above reuses `.news-item`,
`.paper`, `.etc-card`, etc. as-is.

## Content duplication with the CV PDF pipeline

The downloadable CV PDF (`assets/pdf/cv.pdf`, linked from the header) does **not** come from this repo.
It's generated in `~/personal` (outside this repo, in the Papers Obsidian vault):
`~/personal/data/profile.json` → `~/personal/scripts/generate.py` → `~/personal/cv.tex` → `pdflatex` →
copy into `assets/pdf/cv.pdf` here. This means Education/Experience/Teaching/Service/Awards content is
maintained in **two places that don't auto-sync**: `index.html` (for the webpage) and
`~/personal/data/profile.json` (for the PDF). If you add/change a CV-shaped entry, update both, or they
drift apart silently. `~/personal/portfolio.md` has the fuller writeup of that pipeline.

## Legacy assets

`assets/legacy/` — real photos/logos (UNICORN Racing team + car, an advisor photo, F1TENTH Grand Prix
event photos) recovered from git history of an even-earlier chirpy-theme Jekyll version of this site.
Deliberately **not** used on the page yet (explicit hold-off from Jeongsang) — the Projects section uses
a plain colored placeholder box for UNICORN Racing instead of `assets/legacy/photos/unicorn_ontrack.jpg`.
Don't wire it in without checking first. See `assets/legacy/README.md`.

## Deploy

No CI, no build. `.nojekyll` at the root tells GitHub Pages to skip its own Jekyll processing and serve
the files as-is. Pages source (Settings → Pages) is "Deploy from a branch" → `main`, path `/`. Push to
`main` and the live site updates within roughly a minute — no Actions run to watch, no Ruby/gem version
risk (unlike the old al-folio setup, which needed `bundle exec jekyll build` in CI and had two real
incidents around pip caching and Pages branch/`.nojekyll` mismatches — none of that machinery exists
anymore, so those specific failure modes can't recur here). After a Pages *source* change specifically
(branch/path), GitHub does not always auto-rebuild — call
`gh api -X POST repos/jeongsang-ryu/jeongsang-ryu.github.io/pages/builds` to force one if the live site
looks stale after switching source.

## Related repos

- `~/personal/tools` (https://github.com/jeongsang-ryu/tools, live at
  https://jeongsang-ryu.github.io/tools/) — same plain-static-HTML approach, a separate "Project Pages"
  site for small standalone tools (currently: Gaussian Area Shading, a paper-figure generator). Linked
  from this site's header.
- `~/personal/jeongsang-ryu` (https://github.com/jeongsang-ryu/jeongsang-ryu) — the GitHub profile
  README, managed independently of this site.
