-- Supabase Dashboard > SQL Editor에서 한 번 실행하세요.
create table public.rsvp_responses (
  id uuid primary key default gen_random_uuid(),
  guest_side text not null check (guest_side in ('groom', 'bride')),
  attendance text not null check (attendance in ('attend', 'decline')),
  guest_name text not null check (char_length(guest_name) between 1 and 40),
  meal_count integer not null default 0 check (meal_count between 0 and 20),
  companion_count integer not null default 0 check (companion_count between 0 and 19),
  created_at timestamptz not null default now(),
  check (
    (attendance = 'attend' and meal_count >= 1 and companion_count <= meal_count - 1)
    or (attendance = 'decline' and meal_count = 0 and companion_count = 0)
  )
);

alter table public.rsvp_responses enable row level security;

create policy "Anyone can submit an RSVP"
on public.rsvp_responses
for insert
to anon
with check (true);

grant insert on table public.rsvp_responses to anon;
