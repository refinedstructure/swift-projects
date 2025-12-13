import Foundation
struct Habit:Codable {
    var habitName:String
    var weeklyGoal: Int
    var logs:[Date] = []
    var calendar:Calendar{ Calendar.current }
    var today: Date { Date() }
    
    //check if user has logged today.
    var hasLoggedToday: Bool {
        for log in logs {
            if calendar.isDate(log, inSameDayAs: today) {
                return true
            }
        }
        return false
    }
    
    
    var lastCompletionDate:Date? {
        return logs.max()
    }
   
    
    init(habitName: String, weeklyGoal: Int, logs: [Date] = []) {
        self.habitName = habitName
        if weeklyGoal < 1 {
            print("Weekly goal cannot be negative or zero. Setting it to 1. You can change it later if you want.")
            self.weeklyGoal = 1
        }
        else {
            self.weeklyGoal = weeklyGoal
        }
        self.logs = logs
    }
    
    mutating func logCompletion(on date: Date) {
        if logs.contains(where: { calendar.isDate($0, inSameDayAs: date) }) {
            if calendar.isDate(date, inSameDayAs: today) {
                print("You already logged this today! Take a break!")
            }
            else {
                print("You've already logged your habit for this day before!")
            }
        }
        else {
            logs.append(date)
            if calendar.isDate(date, inSameDayAs: today) {
                print("Congrats on completing your habit for today! Keep going!")
            }
            else {
                print("Keep the streak going! I've added this date to your log")
            }
        }
    }
    
    
    
    // calculating # of attempts past 7 days
        var completionsThisWeek:Int {
            var daysThisWeek = 0
            for loggedDay in logs{
                if let dayDiff = calendar.dateComponents([.day], from: loggedDay, to: today).day {
                    if dayDiff < 7 && dayDiff >= 0 {
                        daysThisWeek += 1
                    }
                }
            }
            if daysThisWeek == 0 {
                print("You haven't logged this habit in the past 7 days")
            }
            return daysThisWeek
        }
        
        //CLAMPING PROGRESS BETWEEN 0.0 and 1.0 so that we'd be able to calc %
        var progress: Double {
            if completionsThisWeek <= weeklyGoal {
                return Double(completionsThisWeek)/Double(weeklyGoal)
            }
            else {
                return 1.0
            }
        }
    
    //Calc streaks
    var streak: Int {
        //Streak logic:
        // Logged dates could be multiple on the same day at different times. We first convert dates in the logs array to start of day. Then turn it into a set for uniqueness.
        // We then pick the streak’s starting day: today if logged, otherwise yesterday.
        // Walk backward one day at a time while each day exists in the logs.
        // Count each consecutive logged day and stop when a day is missing.
        // Return the number of consecutive days, starting from the most recent log.
        
        var streakCount = 0
        //keep only unique values using SET. Normalize to start of day for comparison
        let formattedLogs = Set(logs.map { calendar.startOfDay(for:$0) })
        
        var dayZeroOfStreak: Date
        let startofToday = calendar.startOfDay(for:today)
        //CALCULATE DAY ZERO
        if formattedLogs.contains(startofToday) {
            //make today day zero if today's logged.
            dayZeroOfStreak = startofToday
        }
        else {
            //make yesterday day zero if today's not logged
            if let startOfYesterday = calendar.date(byAdding:.day, value: -1, to: startofToday) {
                dayZeroOfStreak = calendar.startOfDay(for: startOfYesterday)
            }
            else {
                return 0
            }
            
        }
        //START COUNTING BAKC FROM DAY ZERO
        
        for _ in formattedLogs {
            if formattedLogs.contains(dayZeroOfStreak) {
                streakCount += 1
                if let yesterday = calendar.date(byAdding:.day, value: -1, to: dayZeroOfStreak){
                    
                    dayZeroOfStreak = calendar.startOfDay(for: yesterday)
                }
                else {
                    break
                }
            }
            else {
                break
            }
        }

        
        return streakCount

    }
           
    }
    
    

