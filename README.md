# East Coast Showdown — ECS X

The official website for **ECS X**, the tenth East Coast Showdown — the University of Virginia's
intercollegiate Bhangra and Garba-Raas dance competition, themed as a *Shaadi* (Indian wedding).

It's a static site — plain HTML/CSS/JS, no build step, no dependencies. Open the files in a browser
and it just works.

## Pages

| File | Page |
|------|------|
| `index.html` | Home — hero, about, save-the-date, apply, charity (Sakhi), sponsors, archives |
| `board.html` | The executive board (data-driven, see below) |

## Assets

- `photos/` — board headshots, one `.jpg` per person
- `ecs-logo-hero.png` — the gold ECS emblem (feathered), used in the nav/hero
- `sakhi-logo.png` — this year's charity partner logo
- `ecs-logo.png` — the original un-feathered emblem (kept for reference)

## Editing the board

The entire roster lives in **one array near the bottom of `board.html`** (`const board = [ ... ]`).
To change the board, edit that list — no layout code to touch.

```js
{ name:"Full Name", role:"Their Role", flavor:"optional one-liner", photo:"photos/name.jpg" }
```

- `tier:"director"` or `featured:true` on a group puts those cards in the featured (cream) rows up top.
- Groups render in the order they appear, and members render in the order listed.
- Drop `photo` and the card shows a gold mandala placeholder instead.
- Headshots: square crops look best. Add the file to `photos/` and point `photo:` at it.

## Editing content

- **Apply links** — the Bhangra/Raas "Apply" buttons point to `https://ekta.app/`; the
  "Registration packet" buttons are placeholders (no link yet). Search `ekta.app` / `Registration packet`
  in `index.html`.
- **Charity** — the Sakhi section is in `index.html` under `id="charity"`.
- **Date / venue** — search `Spring 2027` in `index.html` to update once confirmed.

## Run locally

Just open `index.html` in a browser. (For clean relative-path loading you can optionally serve it:
`python3 -m http.server` then visit `http://localhost:8000`.)

## Deploy with GitHub Pages (free hosting)

1. Push this repo to GitHub (see below).
2. On GitHub: **Settings → Pages → Build and deployment → Source: Deploy from a branch**,
   pick `main` / `/ (root)`, save.
3. Your site goes live at `https://<username>.github.io/<repo>/` in a minute or two.

A custom domain (e.g. `eastcoastshowdown.org`) can be pointed at Pages later under the same settings.

---

Built for the ECS X executive board. Contact: eastcoastshowdown.uva@gmail.com
