## Problem space

Based on the research documented in  
[discovery.md](https://github.com/refinedstructure/swift-projects/blob/main/cli-apps/HabitTracker/research/discovery.md), three core problem patterns consistently emerge across habit-tracking products.

### Problem 1 — Over-indexing on daily consistency and streaks

Most habit-tracking apps over-index on **daily consistency and streak preservation**. Progress is framed in an all-or-nothing manner, where missing a single day resets or devalues prior effort. This rigidity creates unnecessary pressure and often leads to anxiety, guilt, and disengagement. Instead of supporting habit formation, streak-centric systems can punish, which is counterproductive to long-term behavior change.

### Problem 2 — Poor support for non-daily habits

**Non-daily habits are poorly supported**. Many real-world habits operate on weekly, monthly, or flexible schedules, yet most apps provide limited customization beyond daily checklists. As a result, users with non-daily goals are forced into ill-fitting structures, leading to inaccurate tracking, frustration, or abandonment of the tool altogether.

### Problem 3 — Tracking as additional work

**Tracking itself often feels like additional work** rather than a natural extension of the habit. For example, a user who completes a workout late in the day may forget or lack the energy to log it afterward. In such cases, manual logging becomes an extra cognitive step imposed after the achievement, reducing the perceived value of tracking and increasing friction over time.

Together, these issues suggest that current habit-tracking systems optimize for **consistency metrics rather than sustainable behavior**, increasing cognitive and emotional load instead of reducing it.

---

## Solution space

### prob_1 — Replacing streaks with a neutral habit status

Instead of streaks, each habit has a **simple status model with three states**:

- **On track** – The habit has been logged within the expected cadence.
- **Not logged (neutral)** – No data has been logged yet for the current period.
- **Needs attention** – The habit has gone unlogged beyond an agreed grace window.

The key principle is that **absence of a log is not treated as failure by default**.

When a habit period begins (daily / weekly / monthly), the habit starts in a **Not logged** state.

Below the status, the user sees a single CTA based on their selected cadence:

- **“Habit completed”** (daily / weekly / monthly, depending on cadence)

If the user taps this action:

- The habit immediately moves to **On track**
- The action disappears for that period
- The user sees lightweight confirmation such as:
  - *“You completed this habit today”* (daily)
  - *“You completed this habit this week”* (weekly)

If the habit remains **Not logged** beyond a predefined grace period (for example, 3 days for daily habits, 3 weeks for weekly habits), the habit transitions to **Needs attention**.

The user is informed of this grace period during habit creation, and advanced users may optionally customize it.

If the user logs the habit at any point while in **Needs attention**, the habit immediately returns to **On track**.

---

### prob_2 — Supporting non-daily habits through cadence, not workarounds

During habit creation, the user explicitly selects a **cadence** (daily, weekly, monthly, etc.).

All logging, status transitions, messaging, and grace periods are derived from this cadence.

---

### prob_3 — Logging through status

The user is shown the **current status of each habit** in notifications or live activity views, for example:

- *“3 habits on track · 1 needs attention”*

Tapping the notification leads directly to the habit logging UI, where the user can mark the habit as completed with a single action.

Notifications **do not demand immediate logging**.  
They communicate status and make logging easily accessible without marking it as a failure or obligation.
