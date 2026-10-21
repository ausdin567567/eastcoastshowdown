# Team Portal — Supabase setup

The team portal (`portal.html`) is a view-only dashboard: each team logs in
with an email + password you set for them, and sees their own roster,
sizing, and dietary info. You manage all the data by hand in the Supabase
dashboard — there's no admin UI to build or maintain.

## 1. Create the project

1. Go to [supabase.com](https://supabase.com) and sign up / log in (free tier
   is plenty for this).
2. Create a new project. Pick any name/region/password (that password is
   just for the underlying Postgres database, not for teams).
3. Wait for it to finish provisioning (~2 minutes).

## 2. Run the schema

1. In the project, open **SQL Editor** → **New query**.
2. Paste in the contents of [`schema.sql`](schema.sql) and click **Run**.
   This creates the `teams` and `team_members` tables with Row Level
   Security so a logged-in team can only ever see its own row.

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

## 5. Add a team

Repeat this for each participating team:

1. **Authentication** → **Users** → **Add user** → **Create new user**.
   - Email: doesn't need to be a real inbox — something like
     `uva-bhangra@ecsxteams.com` works fine as a login identifier.
   - Password: whatever you want to hand the team.
   - Check **Auto Confirm User**.
   - Click **Create user**, then copy that user's **UID**.
2. **Table Editor** → `teams` → **Insert row**:
   - `id`: paste the UID from step 1.
   - `team_name`, `school`, `category` (`Bhangra` or `Raas`),
     `captain_name`, `captain_email`, `captain_phone`, `notes` — fill in
     what you have.
3. **Table Editor** → `team_members` → **Insert row** (one per dancer):
   - `team_id`: the same UID from step 1.
   - `full_name`, `role`, `shirt_size`, `pant_size`,
     `dietary_restrictions`.

That team can now log in at `eastcoastshowdown.org/portal.html` with the
email + password from step 1 and see exactly what you entered.

## Updating a team later

Just edit the rows in **Table Editor** — changes show up next time the team
logs in (or refreshes). To remove a team entirely, delete their row from
**Authentication → Users**; the `teams` row (and their roster) cascades
away with it.
