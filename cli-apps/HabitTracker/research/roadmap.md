## v0.2 – Cadence & Status Foundation (CLI)

### Phase 1: Cadence support (prob_2)
- Support daily and weekly habits
- Cadence selector at habit creation
- All logging and status logic derived from cadence
- Monthly cadence intentionally excluded for now

### Phase 2: Status-based tracking (prob_1)
- Replace streaks with habit status:
  - On track
  - Not logged
  - Needs attention
- Status derived from cadence + last log + grace period
- No streak counters or reset mechanics

### Phase 3: Status-driven logging (prob_3)
- Logging flows through habit status, not reminders
- Status summaries exposed via CLI
- Explicit logging action only (no forced prompts)

## Scope & constraints

- Monthly habits intentionally excluded in this phase
- Notifications and reminders deferred due to CLI constraints
- Focus is on validating cadence and status logic 
