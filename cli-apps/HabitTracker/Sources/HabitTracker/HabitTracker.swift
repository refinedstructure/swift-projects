import Foundation

let APP_VERSION = "0.1.1"

@main
struct HabitTracker {
    static func main() {
        
        //load viewmodel
        var viewModel = HabitTrackerViewModel()
        //LOADING screen to show when user first startss or types "home"
        func triggerLoadScreen() {

            if viewModel.isNewUser()
                
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
              1. add        - Create a new habit        
              2. list       - Show all habits           
              3. log        - Log today's completion    
              4. stats      - View streaks & progress   
              5. delete     - Delete habits   
              5. quit       - Exit the app              
            
            Type a command and press Enter.
            ------------------------------------
            

            """)
            }
                
        }
        
    
        
        func triggerContinueScreen() {
            
            if viewModel.isNewUser() {
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
        func habitSelector() -> Int? {
            if !viewModel.isNewUser() {
                var counter:Int = 0
                var selectedHabitPosition: Int = 0
                for habit in viewModel.habits{
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
                            break
                        }
                    }
                    else {
                        print("Please enter a number")
                    }
                }
                return selectedHabitPosition
            }
            else {
                return nil
            }
        }
        
        
        
        func confirmDialog(confirmationMsg: String) -> Bool {
            var confirmation:Bool = false
            print(confirmationMsg + " type (y/n)")
            while let userInput = readLine(strippingNewline: true) {
                
                if userInput.lowercased() == "y" {
                    confirmation = true
                    break
                }
                else if userInput.lowercased() == "n"{
                    confirmation = false
                    break
                }
                else {
                    print("Please enter either y or n")
                }
                
            }
            return confirmation
        }
        
        
        
        
        //INITIAL LOAD
        
        triggerLoadScreen()
        
        
        
        // GET INPUT
        while let input = readLine(strippingNewline: true) {
            switch input {
                
            case "delete":
                    if let selectedConfigHabit = habitSelector() {
                        let confirmMsg  = "Are you sure you want to delete \(viewModel.habits[selectedConfigHabit].habitName)?"
                        let confirmation = confirmDialog(confirmationMsg: confirmMsg)
                        if confirmation {
                            
                            print("The habit \(viewModel.habits[selectedConfigHabit].habitName) has been deleted. \n")
                            viewModel.deleteHabit(at: selectedConfigHabit)
                            triggerContinueScreen()
                            
                        }
                        else {
                            print("\n No change made.\n")
                            triggerContinueScreen()
                        }
                    }
                    else {
                        print("There are no habits to delete. You can create one using the 'add' command\n\n\n")
                        triggerLoadScreen()
                    }
            case "home":

                triggerLoadScreen()
            case "add":
                var newHabitName:String = ""
                var newWeeklyGoal:Int = 1
                print("\n\nEnter name for this habit \n")
                while let nameInput = readLine(strippingNewline: true) {
                    if !nameInput.isEmpty {
                            if !viewModel.canAddHabit(nameInput)
                        
                        {
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
                        if !viewModel.isWeeklyGoalValid(goal: rawWeeklyGoal){
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
                if viewModel.isNewUser(){
                    print("Congrats! You've created your first habit. Habit Name: \(newHabitName) Weekly Goal \(newWeeklyGoal) \n ")
                }
                else {
                    print("Congrats! You've created a new habit. Habit Name: \(newHabitName) Weekly Goal \(newWeeklyGoal) \n")
                    
                }

                let newHabit = Habit(habitName: newHabitName, weeklyGoal: newWeeklyGoal)

                viewModel.addHabit(newHabit)
                
                print("\n\n\n")
                //showing load screen for now but worth creating a "next command screen" soon

                triggerContinueScreen()
                
            case "list":
                print("""
                    
                                ====================================
                                              YOUR HABITS
                                ====================================
                    """)

                if !viewModel.isNewUser() {
                    print("\n\nYou are tracking \(viewModel.habits.count) habits. Here they are: \n")
                    for habit in viewModel.habits{
                        print("Habit: \(habit.habitName) Streak: \(habit.streak) days\n")
                    }
                }
                triggerContinueScreen()
                
            case "log":
                if let chosenHabitIndex = habitSelector(){
                    print("""
                        
                                    ====================================
                                               LOG YOUR HABIT
                                    ====================================
                        
                                    Please select a habit from the list to log it:
                        
                        
                        """)
                    
                    viewModel.logHabit(at: chosenHabitIndex)
                    print("\nYour habit was successfully logged!\n\n")
                    triggerContinueScreen()
                }
                else {
                    print("No habits to display. Type \"add\" to add a new habit. \n \n")
                    triggerContinueScreen()
                }
                
            case "stats":
                
              
                        if  let chosenHabitIndex = habitSelector() {
                            print("""
                                
                                            ====================================
                                                   KNOW YOUR HABIT'S STATS 
                                            ====================================
                                
                                            Please select a habit from the list to view its stats:
                                
                                
                                """)
                        
                        if let compDate = viewModel.habits[chosenHabitIndex].lastCompletionDate {
                            print("""
                          Habit name: \(viewModel.habits[chosenHabitIndex].habitName)
                          Completions this week: \(viewModel.habits[chosenHabitIndex].completionsThisWeek)
                          Streak: \(viewModel.habits[chosenHabitIndex].streak)
                         Weekly goal: \(viewModel.habits[chosenHabitIndex].weeklyGoal)
                         Last Logged On: \(compDate)
                         """)
                            triggerContinueScreen()
                        }
                        else {
                            print("""
                          Habit name: \(viewModel.habits[chosenHabitIndex].habitName)
                          Completions this week: \(viewModel.habits[chosenHabitIndex].completionsThisWeek)
                          Streak: \(viewModel.habits[chosenHabitIndex].streak)
                         Weekly goal: \(viewModel.habits[chosenHabitIndex].weeklyGoal)
                         """)
                            triggerContinueScreen()
                        }
                    }
                else{
                    print("No habits to display. Type \"add\" to add a new habit. \n \n")
                    triggerContinueScreen()
                }
            case "quit":
                print("Goodbye!")
                exit(0)
            default:
                print("Not a valid command. Try again. \n \n")
                triggerContinueScreen()
            }
            
        }
    }
}
