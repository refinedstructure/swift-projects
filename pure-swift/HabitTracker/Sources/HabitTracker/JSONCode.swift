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

let FILENAME:String = "habits.json"
let FOLDERNAME:String = "data"

func generatePATH(docPath: URL, file:String,folder:String) -> URL {
    let dataDir = docPath.appendingPathComponent(folder)
    let fileURL = dataDir.appendingPathComponent(file)
    return fileURL
}


func saveHabits(_ habits:[Habit]){
    let fm = FileManager.default
    //saving to documents folder
    if let documentsPath = fm.urls(for: .documentDirectory, in: .userDomainMask).first {
        let dataDir = documentsPath.appendingPathComponent(FOLDERNAME)
        let fileURL = generatePATH(docPath: documentsPath, file: FILENAME, folder: FOLDERNAME)
        
        do {
            
            try fm.createDirectory(at: dataDir, withIntermediateDirectories: true, attributes: nil)
            let data = try habitEncoder.encode(habits)
            try data.write(to: fileURL, options: .atomic)
        }
        catch {
            print("Failed to save habits: \(error)")
        }
        
    }
}


func loadHabits() -> [Habit] {
    var habits: [Habit] = []
    let fm = FileManager.default
    if let documentsPath = fm.urls(for: .documentDirectory, in: .userDomainMask).first {
        
        let fileURL = generatePATH(docPath: documentsPath, file: FILENAME, folder: FOLDERNAME)
        if fm.fileExists(atPath: fileURL.path) {
            // load habits
            do {
                let habitsRawData = try Data(contentsOf: fileURL)
                habits = try habitDecoder.decode([Habit].self, from: habitsRawData)
            }
            catch
            {
                print("The following error occured when reading the file: \(error)")
            }
        }
    }
    
    return habits
}
