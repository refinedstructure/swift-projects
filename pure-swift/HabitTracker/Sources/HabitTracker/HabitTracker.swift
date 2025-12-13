import Foundation

@main
struct HabitTracker {
    static func main() {
        
        var existingHabits: [Habit]
        existingHabits = loadHabits()
        var newUser:Bool = false
        
        
        //Check if there are no habits created by user
        let validateNewUser:() -> Void = {
            if existingHabits.isEmpty {
                newUser = true
            }
            else {
                newUser = false
            }
        }
        
        //Show bespoke load screen based on whether it's a new user or not
        let triggerLoadScreen:() -> Void =  {
            if newUser
            {
            print("""
            ====================================
                    HABIT TRACKER — CLI
            ====================================
            
            Welcome! You can use this app to track your habits
            
            Available commands:
              1. add        - Create a new habit        
              5. quit       - Exit the app              
            
            Type a command and press Enter.
            ------------------------------------
            

            """
                 )
            }
            else {
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
        
        //INITIAL LOAD
        triggerLoadScreen()
        
        // GET INPUT
        while let input = readLine(strippingNewline: true) {
            switch input {
            case "add":
                //habitname and weekly goal must come from readline -pending
                let newHabit = Habit(habitName: "New Habit", weeklyGoal: 10)
                existingHabits.append(newHabit)
                saveHabits(existingHabits)
                
            case "list":
                validateNewUser()
                if !newUser {
                    print("\(existingHabits.count) habits loaded \n")
                    for habit in existingHabits{
                        print("Habit:\(habit.habitName) Streak: \(habit.streak) days\n")
                    }
                }
            case "log":
                validateNewUser()
                //habit selection needs to be built first
                print("Time to log your habit!")
                
            case "stats":
                validateNewUser()
                if !newUser{
                    for habit in existingHabits{
                        print("Habit name: \(habit.habitName)\n Completions this week: \(habit.completionsThisWeek) \n Streak: \(habit.streak) \n Weekly goal: \(habit.weeklyGoal) \n\n\n")
                    }
                }
                else{
                    triggerLoadScreen()
                }
            case "quit":
                print("Goodbye!")
                exit(0)
            default:
                print("Not a valid command. Try again. \n \n")
                validateNewUser()
                triggerLoadScreen()
            }
            
        }
    }
}
