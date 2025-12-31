import Foundation
struct HabitTrackerViewModel  {
    var habits: [Habit]
    
    init() {
        self.habits = loadHabits()
    }
    
        func isWeeklyGoalValid(goal: Int) -> Bool {
            goal >= 1
        }
    
    func canAddHabit(_ habit:String) -> Bool {
        if habits.contains(where: {$0.habitName.lowercased() == habit.lowercased()}) {
            return false
        }
        else {
            return true
        }
    }
    
    
    //Check if there are no habits created by user
    func isNewUser() -> Bool  {
        habits.isEmpty
    }
    
    
    mutating func deleteHabit(at index: Int) {
        habits.remove(at: index)
        saveHabits(habits)
    }
    
    mutating func addHabit(_ habit: Habit) {
        habits.append(habit)
        saveHabits(habits)
    }
    
    
    mutating func logHabit(at index: Int) -> LogStatus {
        //log habit
        let habitLogStat = habits[index].logCompletion(on: Date())
        //save to disk
        saveHabits(habits)
        return habitLogStat
        
       
    }
    
}
