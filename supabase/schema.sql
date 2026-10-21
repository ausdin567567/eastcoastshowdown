-- East Coast Showdown — Team Portal schema
-- Run this once in your Supabase project's SQL Editor (Project > SQL Editor > New query).
--
-- Model: one Supabase Auth user per team (created manually by the admin in
-- Authentication > Users). That user's UID doubles as the team's primary key,
-- which is what makes the Row Level Security policies below work: a logged-in
-- team can only ever read its own row.

-- ---------------------------------------------------------------------------
-- teams: one row per participating team
-- ---------------------------------------------------------------------------
create table if not exists public.teams (
  id uuid primary key references auth.users(id) on delete cascade,
  team_name text not null,
  school text,
  category text check (category in ('Bhangra', 'Raas')),
  captain_name text,
  captain_email text,
  captain_phone text,
  notes text,
  created_at timestamptz not null default now()
);

alter table public.teams enable row level security;

create policy "Teams can view their own row"
  on public.teams for select
  using (auth.uid() = id);

-- ---------------------------------------------------------------------------
-- team_members: NOT CURRENTLY USED.
-- Roster/sizes/dietary info is pulled live from a published Google Sheet
-- instead (see supabase/README.md) — this table is left in place in case you
-- ever want to move roster data back into Supabase, but portal.html does not
-- read from it.
-- ---------------------------------------------------------------------------
create table if not exists public.team_members (
  id uuid primary key default gen_random_uuid(),
  team_id uuid not null references public.teams(id) on delete cascade,
  full_name text not null,
  role text,                    -- e.g. "Captain", "Dancer"
  shirt_size text,              -- e.g. XS / S / M / L / XL / XXL
  pant_size text,
  dietary_restrictions text,
  created_at timestamptz not null default now()
);

alter table public.team_members enable row level security;

create policy "Teams can view their own roster"
  on public.team_members for select
  using (auth.uid() = team_id);

-- No insert/update/delete policies are defined for the authenticated role on
-- purpose — this is a view-only portal. Admin data entry happens through the
-- Supabase Table Editor (Studio uses an elevated role that bypasses RLS), not
-- through the public site.
