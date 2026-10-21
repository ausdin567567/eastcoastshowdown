# Team Portal — setup

The team portal (`portal.html`) is a view-only dashboard: each team logs in
with an email + password you set for them, and sees their own roster,
sizing, and dietary info.

Two pieces of data, two places:

- **Who a login belongs to** (team name, school, category, captain contact) —
  lives in Supabase, which you manage by hand in its dashboard. No admin UI
  to build or maintain.
- **Roster / sizes / dietary info** — lives in a Google Sheet you already
  keep, published read-only so the portal can fetch it. Keep editing that
  Sheet as normal; nothing needs re-entering in Supabase.

> **Heads up on privacy:** the published Sheet's CSV link is reachable by
> anyone who has that exact URL, not just logged-in teams — the portal only
> *displays* each team their own rows, but the underlying link isn't
> access-controlled. Fine for names/sizes/dietary notes; don't put anything
> more sensitive in that sheet.

## 1. Create the project

1. Go to [supabase.com](https://supabase.com) and sign up / log in (free tier
   is plenty for this).
2. Create a new project. Pick any name/region/password (that password is
   just for the underlying Postgres database, not for teams).
3. Wait for it to finish provisioning (~2 minutes).

## 2. Run the schema

1. In the project, open **SQL Editor** → **New query**.
2. Paste in the contents of [`schema.sql`](schema.sql) and click **Run**.
   This creates the `teams` table with Row Level Security so a logged-in
   team can only ever see its own row. (It also creates an unused
   `team_members` table — ignore it, see the note in that file.)

## 3. Turn off email confirmation

Since you're creating team logins yourself (not having teams sign up), skip
email confirmation so a team can log in immediately:

1. **Authentication** → **Providers** → **Email** → turn off **Confirm email**.

## 4. Get your API keys and send them back

1. **Project Settings** → **API**.
2. Copy the **Project URL** and the **`anon` `public`** key (not the
   `service_role` key — that one should never leave the dashboard).
3. Send those two values back and they'll be dropped into
   `portal.html` in place of `YOUR_SUPABASE_PROJECT_URL` /
   `YOUR_SUPABASE_ANON_KEY`. Both are safe to publish — they're the public
   client key, and the RLS policies from step 2 are what actually keep each
   team's data private.
4. Optional: **Authentication** → **URL Configuration** → set **Site URL**
   to `https://eastcoastshowdown.org`.

## 5. Set up the roster Google Sheet

The sheet needs one tab with one row per dancer, and a header row with
(at minimum) these column names — exact wording doesn't matter much, the
portal matches headers loosely, but keep the words recognizable:

| Team Name | Full Name | Role | Shirt Size | Pant Size | Dietary Restrictions |
|---|---|---|---|---|---|
| UVA Bhangra | Asha Patel | Captain | M | 30 | Vegetarian |
| UVA Bhangra | Raj Mehta | Dancer | L | 32 | |

**`Team Name` must match a team's `team_name` in the Supabase `teams` table
exactly** (not case-sensitive, but spelling/spacing needs to match) — that's
how the portal knows which rows belong to which team.

To publish it:

1. In Google Sheets: **File → Share → Publish to web**.
2. Under "Link", pick the specific sheet/tab with the roster (not "Entire
   document") and set the format to **Comma-separated values (.csv)**.
3. Click **Publish**, confirm, and copy the URL it gives you.
4. Send that URL back — it goes into `portal.html` in place of
   `YOUR_PUBLISHED_SHEET_CSV_URL`.

Any edit to the sheet shows up next time a team logs in (or refreshes) — no
republishing needed, the published link stays live.

## 6. Add a team

Repeat this for each participating team:

1. **Authentication** → **Users** → **Add user** → **Create new user**.
   - Email: doesn't need to be a real inbox — something like
     `uva-bhangra@ecsxteams.com` works fine as a login identifier.
   - Password: whatever you want to hand the team.
   - Check **Auto Confirm User**.
   - Click **Create user**, then copy that user's **UID**.
2. **Table Editor** → `teams` → **Insert row**:
   - `id`: paste the UID from step 1.
   - `team_name`: must exactly match the `Team Name` value you'll use for
     this team's rows in the roster sheet.
   - `school`, `category` (`Bhangra` or `Raas`), `captain_name`,
     `captain_email`, `captain_phone`, `notes` — fill in what you have.
3. Add that team's dancers as rows in the roster sheet (step 5), using the
   same `Team Name`.

That team can now log in at `eastcoastshowdown.org/portal.html` with the
email + password from step 1 and see their roster from the sheet.

## Updating a team later

- Team name/school/category/captain info: edit their row in Supabase's
  **Table Editor** → `teams`.
- Roster/sizes/dietary info: edit the Google Sheet directly.

To remove a team's login entirely, delete their row from
**Authentication → Users** in Supabase; their `teams` row cascades away
with it (their roster rows in the Sheet aren't touched — remove those by
hand if you want).
