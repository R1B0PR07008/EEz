//
//  files_func.swift
//  EEz
//
//  Created by Riboldi  on 15/01/25.
//

import Foundation

/// news loader

func saveToFileNews(_ bills: [newsDataStructure]) {
	let fileURL = URL(fileURLWithPath: "/Users/riboldi_jr/Documents/GitHub/EEz/EEz.swiftpm/Documents/news.json") /// FIX THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	if let encoded = try? JSONEncoder().encode(news) {
		try? encoded.write(to: fileURL)
	}
}

func loadFromFileNews() -> [newsDataStructure] {
	let fileURL = URL(fileURLWithPath: "/Users/riboldi_jr/Documents/GitHub/EEz/EEz.swiftpm/Documents/news.json") /// FIX THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	do {
		let data = try Data(contentsOf: fileURL)
		let decoded = try JSONDecoder().decode([newsDataStructure].self, from: data)
			return decoded
	} catch {
		print("ERROR2 \(error)")
		return []
	}
}

/// Bills Data loader

func saveToFileBills(_ bills: [RecentBillsData]) {
	let fileURL = URL(fileURLWithPath: "/Users/riboldi_jr/Documents/GitHub/EEz/EEz.swiftpm/Documents/bills.json") /// FIX THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	print("\nfunction: \(bills)")
	if let encoded = try? JSONEncoder().encode(bills) {
		try? encoded.write(to: fileURL)
	}
}

func loadFromFileBills() -> [RecentBillsData] {
	let fileURL = URL(fileURLWithPath: "/Users/riboldi_jr/Documents/GitHub/EEz/EEz.swiftpm/Documents/bills.json") /// FIX THIS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	do {
		let data = try Data(contentsOf: fileURL)
		let decoded = try JSONDecoder().decode([RecentBillsData].self, from: data)
			return decoded
	} catch {
		print("ERROR3 \(error)")
		return []
	}
}

func addNewBill(spent: Double, date: String, place: String, category: String) {

	let newBill = RecentBillsData(spent: spent, date: date, place: place, category: category)
	
	var currentBills = loadFromFileBills()
	
	currentBills.append(newBill)
	
	saveToFileBills(currentBills)
	
	var newBills = loadFromFileBills()
}

