# Research

Market discovery and problem space analysis for the Habit Tracker project.

## What's here

- **discovery.md** - Secondary research synthesis from Reddit, app reviews, blogs, and one academic paper

## What this is

Before building, I looked at 50+ existing discussions and reviews to find patterns in why people quit habit tracking apps. This is secondary research - it forms hypotheses to validate, not confirmed user needs.

Top patterns:
- Streak mechanics causing anxiety and guilt
- Tracking feeling like admin work
- Rigid daily scheduling not matching real habits
- Aggressive monetization killing trust

## What this isn't

This is not primary user research. No direct interviews yet. The sources are:
- Reddit posters (skewed toward power users and people venting)
- App store reviewers (skewed toward extreme experiences)
- Productivity blogs (skewed toward writers' takes)

Next step: Validate with 5-8 interviews with people who tried and quit habit apps.

## How this shaped the build

The CLI-first approach came directly from two hypotheses:
1. Reduce tracking friction - command line is fast, no UI overhead
2. Avoid notification fatigue - pull-based (user initiates) vs push-based (app interrupts)

Whether these actually solve user problems is still to be validated.
