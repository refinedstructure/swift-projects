import Foundation

let APP_VERSION = "1.1.1"


enum UserIntent:String {
    case add = "add"
    case delete = "delete"
    case list = "list"
    case log = "log"
    case stats = "stats"
    case quit = "quit"
    case home = "home"
}




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
            
            Welcome to your new CLI habit tracker!
            
            Note: All habits are saved locally at ~/Documents/data/habits.json
            
            Available commands:
              add        - Create a new habit        
              quit       - Exit the app              
            
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
            
            Welcome back to CLI habit tracker!
            
            Note: All habits are saved locally at ~/Documents/data/habits.json
            
            Available commands:
              ➡️ add        - Create a new habit        
              ➡️ list       - Show all habits           
              ➡️ log        - Log today's completion    
              ➡️ stats      - View streaks & progress   
              ➡️ delete     - Delete habits   
              ➡️ quit       - Exit the app               
            
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
            
            
            
            Available commands: add, list, log, stats, delete, quit. Tip: Type "home" to go back to main menu
            Type a command and press Enter.
            ------------------------------------

            """)
                
            }
            
        }
            
        func habitSelector() -> Int? {
            if !viewModel.isNewUser() { //check if array is not empty
                print("Select a habit \n\n")
                var counter:Int = 0
                var selectedHabitPosition: Int = 0
                for habit in viewModel.habits{
                    print("\(counter + 1): \(habit.habitName)\n")
                    counter += 1
                } //array's at 0 start-- user shd see 1 start
                while let input = readLine(strippingNewline: true) {
                    if let userInput = Int(input) {
                        if userInput > counter || userInput <= 0 {
                            print( "\n\nPlease enter the corresponding number for the habit to select it")
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
        
        
        //reusable confirmation dialogbox
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
        // MAIN menu
        while let input = readLine(strippingNewline: true) {
            let command = UserIntent(rawValue: input)
            switch command {
            
            case .delete:
                    if let selectedConfigHabit = habitSelector() {
                        let confirmMsg  = "\n\nAre you sure you want to delete \(viewModel.habits[selectedConfigHabit].habitName)?"
                        let confirmation = confirmDialog(confirmationMsg: confirmMsg)
                        if confirmation {
                            
                            print("\n\nThe habit \(viewModel.habits[selectedConfigHabit].habitName) has been deleted. \n")
                            viewModel.deleteHabit(at: selectedConfigHabit)
                            triggerContinueScreen()
                            
                        }
                        else {
                            print("\n No change made.\n")
                            triggerContinueScreen()
                        }
                    }
                    else {
                        print("\n\nThere are no habits to delete. You can create a new habit using the 'add' command\n\n\n")
                        triggerLoadScreen()
                    }
            case .home:
                triggerLoadScreen()
            case .add:
                var newHabitName:String = ""
                var newWeeklyGoal:Int = 1
                print("\n\nGive your habit a name \n")
                while let nameInput = readLine(strippingNewline: true) {
                    if !nameInput.isEmpty { //check if habit name already exists
                            if !viewModel.canAddHabit(nameInput)
                        {
                            print("\n\nA habit by the name \(nameInput) already exists. Try a different name!")
                        }
                        else {
                            newHabitName = nameInput
                            print("\nYour habit will be called \(newHabitName)")
                            break
                        }
                    }
                    else {
                        print("Make sure you enter a name for your habit\n")
                    }
                }
                print("\nEnter weekly goal for this habit [Should be a whole number] Ex: 4\n")
                while let goalInput = readLine(strippingNewline: true) {
                    
                    if let rawWeeklyGoal = Int(goalInput) {
                        if !viewModel.isWeeklyGoalValid(goal: rawWeeklyGoal){
                            print("\n\nYour goal can't be zero or negative. Try again! \n")
                        }
                        else {
                            newWeeklyGoal = rawWeeklyGoal
                            print("\nGoal for your habit set at : \(newWeeklyGoal)")
                            break
                        }
                    }
                    else {
                        print("\nMake sure you enter a goal that is a whole number \n")
                    }
                }
                
                //LOG HABIT

                let newHabit = Habit(habitName: newHabitName, weeklyGoal: newWeeklyGoal)

                viewModel.addHabit(newHabit)
                
                if viewModel.isNewUser(){
                    print("\n\nCongrats! You've created your first habit. \n\n Habit Name: \(newHabitName)\n\n Weekly Goal: \(newWeeklyGoal) \n\n ")
                }
                else {
                    print("\n\nCongrats! You've created a new habit. \n\n Habit Name: \(newHabitName) \n\n Weekly Goal: \(newWeeklyGoal) \n\n")
                    
                }

                triggerContinueScreen()
                
            case .list:
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
                else {
                    print("No habits to display. Type \"add\" to add a new habit. \n \n")
                }
                triggerContinueScreen()
                
            case .log:
                print("""
                    
                                ====================================
                                           LOG YOUR HABIT
                                ====================================
                    
                                Please select a habit from the list to log it:
                    
                    
                    """)
                if let chosenHabitIndex = habitSelector(){
                    let loggingResult: LogStatus = viewModel.logHabit(at: chosenHabitIndex)
                    
                    switch loggingResult {
                    case .loggedAlreadyTodayFail: print("❌ You already logged this habit today!")
                    case .loggedBeforeFail: print("❌ You already logged this habit before! ")
                    case .loggedHistoricalSuccess: print("📆 ✅ Earlier day logged!")
                    case .loggedTodaySuccess: print("💪 ✅ Logged successfully!")
                    }
                    
                    

                    triggerContinueScreen()
                }
                else {
                    print("No habits to display. Type \"add\" to add a new habit. \n \n")
                    triggerContinueScreen()
                }
                
            case .stats:
           

                        if  let chosenHabitIndex = habitSelector() {
                            print("""
                                
                                            ====================================
                                                   KNOW YOUR HABIT'S STATS 
                                            ====================================
                                
                                
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
            case .quit:
                print("Goodbye!")
                exit(0)
            default:
                print("Not a valid command. Try again. \n \n")
                triggerContinueScreen()
            }
            
        }
    }
}
