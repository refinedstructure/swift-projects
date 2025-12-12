//
//  JSONCode.swift
//  HabitTracker
//
//  Created by Abhishek on 10.12.2025.
//

import Foundation
    let habitEncoder:JSONEncoder = {
        let j = JSONEncoder()
        //make it readable
        j.outputFormatting = [.prettyPrinted, .sortedKeys]
        j.dateEncodingStrategy = .iso8601
        
        return j
    }()

    let habitDecoder:JSONDecoder = {
        let j = JSONDecoder()
        j.dateDecodingStrategy = .iso8601
        return j
    }()
    

func saveHabits(_ habits:[Habit]){
    let fm = FileManager.default
    //saving to documents folder
    if let documentsPath = fm.urls(for: .documentDirectory, in: .userDomainMask).first {
        let dataDir = documentsPath.appendingPathComponent("data")
        let fileURL = dataDir.appendingPathComponent("habits.json")
        
        do {
            
            try fm.createDirectory(at: dataDir, withIntermediateDirectories: true, attributes: nil)
            let data = try habitEncoder.encode(habits)
            try data.write(to: fileURL, options: .atomic)
            print("Saved \(habits.count) habits to \(fileURL.path) ")
        }
        catch {
            print("Failed to save habits: \(error)")
        }
        
    }
    else {
        
        print("That didn't work. Check access to documents folder")
    }
}


func loadHabits() -> [Habit] {
    var habits: [Habit] = []
    let fm = FileManager.default
    if let documentsPath = fm.urls(for: .documentDirectory, in: .userDomainMask).first {
        let dataDir = documentsPath.appendingPathComponent("data")
        let fileURL = dataDir.appendingPathComponent("habits.json")
        
       
        
        if fm.fileExists(atPath: fileURL.path) {
            // load habits
            do {
                let habitsRawData = try Data(contentsOf: fileURL)
                habits = try habitDecoder.decode([Habit].self, from: habitsRawData)
                print("\(habits.count) habits found. Loading now" )
                
            }
            catch
            {
                print("The following error occured when reading the file: \(error)")
            }
        }
        else {
            print("No habits found" )
        }
        
  
    }
    else {
        print("That didn't work. Check access to documents folder")
    }
    
    return habits
}
