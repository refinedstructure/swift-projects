# Code Review: HabitTracker CLI

**Reviewed:** 2026-01-01
**Codebase:** HabitTracker Swift CLI Application
**Files Reviewed:** 6 Swift files (~500 LOC)

---

## Overall Skill Level Assessment

**Beginner to Early-Intermediate** (Learning Swift)

---

## Ratings by Category

| Category | Score | Notes |
|----------|-------|-------|
| **Functionality** | 7/10 | App works, features are complete |
| **Code Organization** | 4/10 | Attempted structure, poor execution |
| **Code Style/Formatting** | 3/10 | Inconsistent throughout |
| **Architecture** | 4/10 | MVVM attempted but violated |
| **Error Handling** | 3/10 | Minimal, prints to console |
| **Testability** | 2/10 | Essentially untestable |
| **Swift Idioms** | 5/10 | Some good, some awkward |
| **Separation of Concerns** | 3/10 | UI logic in model, etc. |

**Average Score: 3.9/10**

---

## Strengths

### 1. Functional Application
The app accomplishes its stated goal - users can create habits, log completions, view stats, and track streaks. All core features work as expected.

### 2. Attempted Proper Architecture
The folder structure shows awareness of architectural patterns:
```
Sources/
├── HabitTracker/
│   ├── Models/
│   │   └── Habit.swift
│   ├── ViewModels/
│   │   └── HabitTrackerViewModel.swift
│   ├── Services/
│   │   └── HabitStorage.swift
│   └── Views/
│       └── CLI/
│           └── Prompts.swift
```

### 3. Good Use of Swift Features
- `Codable` protocol for JSON serialization
- Computed properties for derived values
- `mutating` functions for value type modification
- Proper use of `Calendar` API for date calculations
- ISO8601 date encoding strategy

### 4. Thoughtful Streak Algorithm
The streak calculation logic in `Habit.swift:83-133` demonstrates genuine problem-solving:
- Normalizes dates to start of day
- Uses Set for uniqueness
- Handles edge cases (today logged vs not logged)
- Walks backward through consecutive days

### 5. Input Validation
- Checks for empty habit names
- Prevents duplicate habit names (case-insensitive)
- Validates weekly goals are positive integers
- Prevents duplicate logging on same day

---

## Areas for Improvement

### 1. Massive `main()` Function
**Location:** `HabitTracker.swift:6-323`

The entire CLI logic (320 lines) is crammed into a single function with nested functions inside. This makes the code:
- Hard to read
- Impossible to test
- Difficult to maintain

**Current:**
```swift
@main
struct HabitTracker {
    static func main() {
        func triggerLoadScreen() { ... }      // nested function
        func triggerContinueScreen() { ... }  // nested function
        func habitSelector() { ... }          // nested function
        func confirmDialog() { ... }          // nested function

        // 200+ lines of switch/case logic
    }
}
```

**Recommended:** Extract into a `CLIController` or `CommandHandler` class.

---

### 2. Dead Code
**Files with no useful content:**
- `HabitManager.swift` - Empty file (only imports)
- `Prompts.swift` - Appears unused

These should either be implemented or removed.

---

### 3. Inconsistent Formatting
**Location:** Throughout codebase

```swift
// Mixed spacing around colons
var habitName:String    // no space
var weeklyGoal: Int     // with space

// Inconsistent brace placement
if weeklyGoal >= 1
{                       // newline before brace
    self.weeklyGoal = weeklyGoal
}
else {                  // same line

// Inconsistent blank lines and indentation
```

**Recommendation:** Use `swift-format` or establish consistent style guide.

---

### 4. UI Logic in Model Layer
**Location:** `Habit.swift:37-55`

```swift
mutating func logCompletion(on date: Date) {
    if logs.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
        print("You already logged this today!")  // UI concern in model!
    } else {
        logs.append(date)
        print("Congrats on completing your habit!")  // UI concern in model!
    }
}
```

**Problem:** Models should not know about presentation. This violates separation of concerns and makes the code untestable.

**Recommended:** Return a result type and let the UI layer handle messaging.

---

### 5. Non-Deterministic Computed Properties
**Location:** `Habit.swift:6-7`

```swift
var calendar: Calendar { Calendar.current }
var today: Date { Date() }
```

**Problems:**
- Recalculated on every access
- Makes unit testing impossible (can't control "today")
- Non-deterministic behavior

**Recommended:** Inject date/calendar as dependencies or use a `DateProvider` protocol.

---

### 6. Global Functions for Persistence
**Location:** `HabitStorage.swift`

```swift
func saveHabits(_ habits: [Habit]) { ... }
func loadHabits() -> [Habit] { ... }
```

**Problems:**
- Global state
- No dependency injection
- Cannot mock for testing
- Tight coupling

**Recommended:** Create a `HabitRepository` protocol with concrete implementation.

---

### 7. Magic Strings
**Location:** `HabitTracker.swift:159-319`

```swift
switch input {
case "delete":
case "home":
case "add":
case "list":
case "log":
case "stats":
case "quit":
```

**Recommended:** Use an enum:
```swift
enum Command: String {
    case delete, home, add, list, log, stats, quit
}
```

---

### 8. Inefficient Algorithm
**Location:** `Habit.swift:114-128`

```swift
for _ in formattedLogs {  // Iterates based on count
    if formattedLogs.contains(dayZeroOfStreak) {
        streakCount += 1
        // ...
    } else {
        break  // But breaks early
    }
}
```

Uses a `for` loop but breaks early. Should be a `while` loop for clarity and intent.

---

### 9. Typos in Comments
**Location:** `Habit.swift:112`

```swift
//START COUNTING BAKC FROM DAY ZERO
```

Should be "BACK".

---

### 10. No Test Coverage
- Zero test files in the project
- Code structure makes testing very difficult
- No mocking capabilities due to tight coupling

---

## File-by-File Summary

| File | LOC | Assessment |
|------|-----|------------|
| `Habit.swift` | 139 | Mixed - good logic, but UI in model |
| `HabitTracker.swift` | 324 | Poor - monolithic main function |
| `HabitTrackerViewModel.swift` | 46 | Decent - but calls global functions |
| `HabitStorage.swift` | 76 | Functional but not injectable |
| `HabitManager.swift` | 4 | Dead code - empty file |
| `Prompts.swift` | ~1 | Dead code - unused |

---

## Verdict

This is clearly the work of someone **actively learning Swift** who has:

- Read about architecture patterns (MVVM) but hasn't fully internalized when/how to apply them
- Basic competence in Swift syntax and standard library
- Not yet internalized code organization best practices
- Not been exposed to TDD or writing testable code

**This is completely normal and expected for a learning project.** The code shows genuine effort and problem-solving ability. The mistakes are typical learning-phase issues, not fundamental misunderstandings of programming concepts.

---

## Recommended Next Steps

### Priority 1: Separate Concerns
1. Extract CLI logic from `main()` into a dedicated class
2. Remove `print` statements from `Habit` model
3. Create a proper command handler

### Priority 2: Improve Testability
1. Inject `Date` instead of using `Date()` directly
2. Create a `HabitRepository` protocol
3. Write first unit tests for `Habit` model

### Priority 3: Code Quality
1. Use an enum for commands
2. Remove dead code files
3. Apply consistent formatting
4. Fix typos

### Priority 4: Error Handling
1. Use `Result` type instead of printing errors
2. Propagate errors to caller
3. Add proper error types

---

## Learning Resources

- [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- [Dependency Injection in Swift](https://www.swiftbysundell.com/articles/dependency-injection-in-swift/)
- [Testing in Swift](https://developer.apple.com/documentation/xctest)
- [MVVM Pattern](https://www.raywenderlich.com/34-design-patterns-by-tutorials-mvvm)
