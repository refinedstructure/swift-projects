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
    

func saveHabits(habits:[Habit]){
    let fm = FileManager.default
    let pwd = URL(fileURLWithPath: fm.currentDirectoryPath, isDirectory: true)
    let dataDir = pwd.appendingPathComponent("data", isDirectory: true)
    let fileURL = dataDir.appendingPathComponent("habits.json")
    
    
    do {
        
        try fm.createDirectory(at: dataDir, withIntermediateDirectories: true, attributes: nil)
        let data = try habitEncoder.encode(habits)
        try data.write(to: fileURL, options: .atomic)
        print("Saved \(habits.count) habits to \(fileURL.path) ")
    }
    catch {
        print("Failed to save habits: ", error)
    }
    
}
