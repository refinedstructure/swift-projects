import Foundation

@main
struct HabitTracker {
    static func main() {
        print("""
        ====================================
                HABIT TRACKER — CLI
        ====================================

        Welcome! You can use this app to track your habits

        Available commands:
          1. add        - Create a new habit        (pending)
          2. list       - Show all habits           (pending)
          3. log        - Log today's completion    (pending)
          4. stats      - View streaks & progress   (pending)
          5. quit       - Exit the app              (works now)

        Type a command and press Enter.
        ------------------------------------
        """)
    }
}
