//
//  files_func.swift
//  EEz
//
//  Created by Riboldi  on 15/01/25.
//

import Foundation

func saveToFile(_ bills: [bills_data]) {
	let fileURL = URL(fileURLWithPath: "/Users/riboldi_jr/Documents/GitHub/EEz/EEz.swiftpm/Resources/data.json")
	if let encoded = try? JSONEncoder().encode(bills) {
		try? encoded.write(to: fileURL)
	}
}

func loadFromFile() -> [bills_data] {
	let fileURL = URL(fileURLWithPath: "/Users/riboldi_jr/Documents/GitHub/EEz/EEz.swiftpm/Resources/data.json")
	if let data = try? Data(contentsOf: fileURL),
	   let decoded = try? JSONDecoder().decode([bills_data].self, from: data) {
		return decoded
	}
	return []
}
