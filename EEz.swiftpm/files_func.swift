//
//  files_func.swift
//  EEz
//
//  Created by Riboldi  on 15/01/25.
//

import Foundation

/// bills data loader

func saveToFile(_ bills: [bills_data]) {
	let fileURL = URL(fileURLWithPath: "/Users/riboldi_jr/Documents/GitHub/EEz/EEz.swiftpm/Resources/data.json") /// FIX THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	if let encoded = try? JSONEncoder().encode(bills) {
		try? encoded.write(to: fileURL)
	}
}

func loadFromFile() -> [bills_data] {
	let fileURL = URL(fileURLWithPath: "/Users/riboldi_jr/Documents/GitHub/EEz/EEz.swiftpm/Resources/data.json") /// FIX THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	if let data = try? Data(contentsOf: fileURL),
	   let decoded = try? JSONDecoder().decode([bills_data].self, from: data) {
		return decoded
	}
	return []
}

/// news loader

func saveToFileNews(_ bills: [newsDataStructure]) {
	let fileURL = URL(fileURLWithPath: "/Users/riboldi_jr/Documents/GitHub/EEz/EEz.swiftpm/Resources/news.json") /// FIX THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	if let encoded = try? JSONEncoder().encode(news) {
		try? encoded.write(to: fileURL)
	}
}

func loadFromFileNews() -> [newsDataStructure] {
	let fileURL = URL(fileURLWithPath: "/Users/riboldi_jr/Documents/GitHub/EEz/EEz.swiftpm/Resources/news.json") /// FIX THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	do {
		let data = try Data(contentsOf: fileURL)
		let decoded = try JSONDecoder().decode([newsDataStructure].self, from: data)
			return decoded
	} catch {
		print("ERROR \(error)")
	}
	return []
}
