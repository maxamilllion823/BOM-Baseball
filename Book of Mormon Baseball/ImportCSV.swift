//
//  ImportCSV.swift
//  Book of Mormon Baseball
//
//  Created by Max Merrell on 12/4/23.
//

import Foundation

func parseCSV() -> [[String]] {
    var data = ""
    if let path = Bundle.main.path(forResource: "lds-scriptures", ofType: "csv") {
        do {
            data = try String(contentsOfFile: path, encoding: .utf8)
        } catch {
            print("Error Loading data")
        }
    }
    
    var result: [[String]] = []
    let rows = data.components(separatedBy: "\n")
    
    for row in rows {
        var columns: [String] = []
        var currentColumn = ""
        var inQuotes = false

        for char in row {
            if char == "\"" {
                inQuotes.toggle()
            } else if char == "," && !inQuotes {
                columns.append(currentColumn)
                currentColumn = ""
            } else {
                currentColumn.append(char)
            }
        }

        columns.append(currentColumn)
        result.append(columns)
    }
    
    return result
}
