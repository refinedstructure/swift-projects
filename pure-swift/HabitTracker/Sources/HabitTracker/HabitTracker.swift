import Foundation

let APP_VERSION = "0.1.1"

@main
struct HabitTracker {
    static func main() {
        
        //load habits if any. Array will be empty if no habits present
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
        //LOADING screen to show when user first startss or types "home"
        let triggerLoadScreen:() -> Void =  {
            if newUser
            {
            print("""
            ====================================
             CLI HABIT TRACKER (v\(APP_VERSION))
            ====================================
            
            Welcome to your new CLI-based habit tracker!
            
            Note: All habits are saved locally at ~/Documents/data/habits.json
            
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
            CLI HABIT TRACKER (v\(APP_VERSION))
            ====================================
            
            Welcome back to your new CLI-based habit tracker!
            
            Note: All habits are saved locally at ~/Documents/data/habits.json
            
            Available commands:
              1. add        - Create a new habit        (works now)
              2. list       - Show all habits           (works now)
              3. log        - Log today's completion    (pending)
              4. stats      - View streaks & progress   (works now)
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
        
        //DO NOT CALL FUNCTION ON EMPTY ARRAYS - do empty array check first validateNEWUSER()
        func habitSelector() -> Int {
            var counter:Int = 0
            var selectedHabitPosition: Int = 0
            for habit in existingHabits{
                print("\(counter + 1): \(habit.habitName)\n")
                counter += 1
            }
            while let input = readLine(strippingNewline: true) {
                
                if let userInput = Int(input) {
                    if userInput > counter || userInput <= 0 {
                       print( "Please enter the corresponding number for the habit to select it")
                    }
                    else {
                        
                        selectedHabitPosition = userInput - 1
//                        print("Your habit selected is \(existingHabits[userInput - 1].habitName)")
                        break
                    }
                }
                else {
                    print("Please enter a number")
                }
            }
            return selectedHabitPosition
        }
        
        
        
        
        //INITIAL LOAD
        validateNewUser()
        triggerLoadScreen()
        
        
        
        // GET INPUT
        while let input = readLine(strippingNewline: true) {
            switch input {
            case "config":
                print(habitSelector())
            case "home":
                validateNewUser()
                triggerLoadScreen()
            case "add":
                var newHabitName:String = ""
                var newWeeklyGoal:Int = 1
                print("\n\nEnter name for this habit \n")
                while let nameInput = readLine(strippingNewline: true) {
                    if !nameInput.isEmpty {
                        
                        if existingHabits.contains(where: {$0.habitName.lowercased() == nameInput.lowercased()}) {
                            print("A habit by the name \(nameInput) already exists. Try a different name!")
                        }
                        else {
                            
                            newHabitName = nameInput
                            
                            print("\nYour habit will be called \(newHabitName)")
                            break
                        }
                    }
                    else {
                        print("Make sure you enter a name \n")
                    }
                }
                print("\nEnter weekly goal for this habit\n")
                while let goalInput = readLine(strippingNewline: true) {
                    if let rawWeeklyGoal = Int(goalInput) {
                        if rawWeeklyGoal < 1 {
                            print("Your goal can't be zero or negative. Try again! \n")
                        }
                        else {
                            newWeeklyGoal = rawWeeklyGoal
                            print("\nGoal for your habit set at : \(newWeeklyGoal)")
                            break
                        }
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
                if !newUser{
                    print("""
                        
                                    ====================================
                                               LOG YOUR HABIT
                                    ====================================
                        
                                    Please select a habit from the list to log it:
                        
                        
                        """)
                    let chosenHabitIndex = habitSelector()

                    existingHabits[chosenHabitIndex].logCompletion(on: Date())
                    saveHabits(existingHabits)
                    triggerContinueScreen()
                }
                else {
                    triggerLoadScreen()
                }
                
            case "stats":
                validateNewUser()
                if !newUser{
                    print("""
                        
                                    ====================================
                                           KNOW YOUR HABIT'S STATS 
                                    ====================================
                        
                                    Please select a habit from the list to view its stats:
                        
                        
                        """)
                    let chosenHabitIndex = habitSelector()
                    
                    print("""
                          Habit name: \(existingHabits[chosenHabitIndex].habitName)
                          Completions this week: \(existingHabits[chosenHabitIndex].completionsThisWeek)
                          Streak: \(existingHabits[chosenHabitIndex].streak)
                         Weekly goal: \(existingHabits[chosenHabitIndex].weeklyGoal)
                         """)
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
