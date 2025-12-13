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
              1. add        - Create a new habit       
              2. list       - Show all habits           (pending)
              3. log        - Log today's completion    (pending)
              4. stats      - View streaks & progress   (pending)
              5. quit       - Exit the app              (works now)
            
            Type a command and press Enter.
            ------------------------------------
            

            """)
            }
                
        }
        
    
        
        
        let triggerContinueScreen:() -> Void  = {
            
            if newUser {
                print("""
            
            Available commands: add, quit. Tip: Type "home" to go back to main menu 
            Type a command and press Enter.
            ------------------------------------

            """)
            
                
            }
            else{
                print("""
            
            Available commands: add, list, log, stats, quit. Tip: Type "home" to go back to main menu
            Type a command and press Enter.
            ------------------------------------

            """)
                
            }
            
        }
        
        
        
        
        //INITIAL LOAD
        validateNewUser()
        triggerLoadScreen()
        
        // GET INPUT
        while let input = readLine(strippingNewline: true) {
            switch input {
            case "home":
                validateNewUser()
                triggerLoadScreen()
            case "add":
                var newHabitName:String = ""
                var newWeeklyGoal:Int = 1
                print("\n\nEnter name for this habit \n")
                while let nameInput = readLine(strippingNewline: true) {
                    if !nameInput.isEmpty {
                        newHabitName = nameInput
                        print("\nYour habit will be called \(newHabitName)")
                        break
                    }
                    else {
                        print("Make sure you enter a name \n")
                    }
                }
                print("\nEnter weekly goal for this habit\n")
                while let goalInput = readLine(strippingNewline: true) {
                    if let rawWeeklyGoal = Int(goalInput){
                        newWeeklyGoal = rawWeeklyGoal
                        print("\nGoal for your habit set at : \(newWeeklyGoal)")
                        break
                    }
                    else {
                        print("\nMake sure you enter a goal that is a number \n")
                    }
                }
                if newUser{
                    print("Congrats! You've created your first habit. Habit Name: \(newHabitName) Weekly Goal \(newWeeklyGoal) \n ")
                }
                else {
                    print("Congrats! You've created a new habit. Habit Name: \(newHabitName) Weekly Goal \(newWeeklyGoal) \n")
                    
                }

                let newHabit = Habit(habitName: newHabitName, weeklyGoal: newWeeklyGoal)
                existingHabits.append(newHabit)
                saveHabits(existingHabits)
                print("\n\n\n")
                //showing load screen for now but worth creating a "next command screen" soon
                validateNewUser()
                triggerContinueScreen()
                
            case "list":
                validateNewUser()
                print("""
                    
                                ====================================
                                              YOUR HABITS
                                ====================================
                    """)

                if !newUser {
                    print("\n\nYou are tracking \(existingHabits.count) habits. Here they are: \n")
                    for habit in existingHabits{
                        print("Habit: \(habit.habitName) Streak: \(habit.streak) days\n")
                    }
                }
                triggerContinueScreen()
                
            case "log":
                validateNewUser()
                //habit selection needs to be built first
                triggerLoadScreen()
                
            case "stats":
                validateNewUser()
                if !newUser{
                    print("""
                        
                                    ====================================
                                            YOUR STATS (ALL HABITS)
                                    ====================================
                        """)
                    for habit in existingHabits{
                        print("\nHabit name: \(habit.habitName)\n Completions this week: \(habit.completionsThisWeek) \n Streak: \(habit.streak) \n Weekly goal: \(habit.weeklyGoal) \n")

                    }
                    triggerContinueScreen()
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
                triggerContinueScreen()
            }
            
        }
    }
}
