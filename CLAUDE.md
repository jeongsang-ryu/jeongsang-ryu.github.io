# CLAUDE.md

Jeongsang Ryu's personal academic site, built on the [al-folio](https://github.com/alshedivat/al-folio)
Jekyll theme (`theme: al_folio_core`, a Ruby gem — layouts/includes live in the gem, not this repo).
This repo is a **trimmed personal fork**: upstream's own test suite, docs site, demo blog posts/projects,
and most CI/QA workflows were stripped out to keep it to just the content and the deploy pipeline.
See `~/personal/portfolio.md` (outside this repo, in the Papers Obsidian vault) for the overall
multi-repo management workflow this site is part of.

## Content lives in data files, not templates

- `_config.yml` — site identity (name, url, description), theme/feature flags. Don't change `theme:` or
  the `plugins:` list under it — those must match the gem versions pinned in `Gemfile`.
- `_data/socials.yml` — email, GitHub, LinkedIn, Google Scholar, ORCID, etc. (jekyll-socials plugin; see
  its README for the full list of supported `*_username`/`*_id` keys).
- `_data/cv.yml` — structured CV data (JSON-Resume-shaped) that the `cv` layout renders as the on-page
  `/cv/`. Sections currently populated: Education, Experience, Skills, Interests. Awards/Publications are
  commented out — add them here (and to `_bibliography/papers.bib` for Publications) once available.
- `_bibliography/papers.bib` — publications, rendered at `/publications/` by jekyll-scholar. Currently
  empty.
- `_pages/about.md` — homepage bio + profile photo (`assets/img/prof_pic.jpg`).
- `_news/*.md` — announcements shown on the homepage. Currently empty; `announcements.enabled` is `false`
  in `_pages/about.md` until there's at least one item — flip it back on then.
- `_projects/*.md` — project cards at `/projects/`. Currently empty (removed the demo entries); the page
  will just render blank until entries are added.

## CV PDF: NOT auto-rendered

Upstream al-folio ships a `render-cv.yml` GitHub Action that runs the external `rendercv` Python tool
against `_data/cv.yml` and auto-commits the output PDF to `main` on every push. **This is removed here.**
`rendercv[full]` (unpinned in upstream's `requirements.txt`, so always installs latest) has drifted from
the YAML shape upstream ships as `_data/cv.yml` — verified locally: even upstream's own unmodified example
fails `rendercv`'s schema validation as of `rendercv` v2.8. The two consumers of "CV data" are actually
different: the Jekyll `cv` layout (gem-side Liquid, lenient) renders `_data/cv.yml` fine for the on-page
CV; the external `rendercv` CLI (strict Pydantic schema) does not.

The downloadable CV PDF (`assets/pdf/cv.pdf`, referenced by `_data/socials.yml`'s `cv_pdf` and
`_pages/cv.md`) instead comes from a separate LaTeX pipeline that lives in `~/personal` (outside this
repo): `~/personal/data/profile.json` → `~/personal/scripts/generate.py` → `~/personal/cv.tex` →
`pdflatex` → copy into `assets/pdf/cv.pdf` here. If `_data/cv.yml` changes, update `~/personal/data/profile.json`
the same way and re-run that pipeline so the PDF and the on-page CV don't drift apart.

## Deploy

`.github/workflows/deploy.yml` is the only workflow kept — it builds the Jekyll site with `bundle exec
jekyll build` and pushes `_site` to the `gh-pages` branch via `JamesIves/github-pages-deploy-action`.
GitHub Pages source must be set to "Deploy from a branch" → `gh-pages` in the repo's Settings → Pages
(**not** "GitHub Actions" — this action pushes a branch, it doesn't use the native Pages-artifact flow).
It also auto-sets `giscus.repo` in `_config.yml` to `${{ github.repository }}` on every build (harmless;
giscus itself stays inert since `repo_id`/`category_id` are blank). There is no verified local build in
this environment (system
Ruby is 2.6.10; al-folio's pinned `al_folio_core`/`al_folio_cv`/etc. gems need something newer, and no
rbenv/asdf/Docker was available when this fork was set up) — treat `deploy.yml`'s run on GitHub as the
build check. Pages deploys are atomic: if a build fails, the previously-deployed version stays live.

## Legacy assets recovered from an even older site

`assets/legacy/` has real photos/logos (UNICORN Racing team + car, an advisor photo, F1TENTH Grand Prix
event photos) recovered from git history of an even-earlier chirpy-theme Jekyll version of this site.
They predate the al-folio migration and are not linked from any page yet — see `assets/legacy/README.md`
for what's there and ideas for where it could go (a `_projects/` entry, a `_news/` item).

## What was intentionally removed from upstream

`.agents/ .codex/ .gemini/ .claude/` (other AI tool configs), `AGENTS.md`, `.devcontainer/`, `docs/`,
`test/`, `lighthouse_results/`, `readme_preview/`, `.all-contributorsrc`, `.git-blame-ignore-revs`,
`_posts/` (33 demo blog posts), `_projects/` (9 demo project files), `_books/`, `_teachings/`,
`assets/audio/ video/ plotly/` (demo media), most `assets/img/*.jpg` (demo blog images), and most
`.github/workflows/*` except `deploy.yml` (dropped: axe, broken-links\*, codeql, copilot-setup-steps,
deploy-docker-tag, deploy-image, docker-slim, lighthouse-badger, prettier\*, release, star-history,
unit-tests, upgrade-check, update-screenshots, update-tocs, visual-regression, render-cv,
update-citations).

`requirements.txt` (`nbconvert` only) looked dead after removing `render-cv.yml`/`update-citations.yml`
(nothing runs `pip install -r requirements.txt` anymore) and was deleted -- **this broke the live
deploy**: `deploy.yml`'s `actions/setup-python@v5` step has `cache: "pip"`, which needs a
requirements.txt/pyproject.toml present just to compute a cache key, even though the only actual
install in that workflow is `pip3 install --upgrade nbconvert` (not `-r requirements.txt`). Restored
with just `nbconvert` in it. Lesson: grep the `.github/workflows/*.yml` cache configs too, not just
`pip install -r` call sites, before deleting a requirements file.
