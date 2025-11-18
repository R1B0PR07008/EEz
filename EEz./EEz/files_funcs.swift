//
//  files_funcs.swift
//  EEz
//
//  Created by Riboldi  on 07/03/25.
//

import Foundation

/// Data structures

struct source : Identifiable, Codable, Hashable {
	let Id: UUID = UUID()
	let id: String?
	let name: String
}

struct newsDataStructure : Identifiable, Codable, Hashable {
	let id: UUID = UUID()
	let source: source
	let author: String?
	let title: String
	let description: String
	let url: String
	let urlToImage: String?
	let publishedAt: String
	let content: String
}

/// data structure for bills (monthly)

struct RecentBillsData : Identifiable, Codable, Hashable {
	 let id: UUID = UUID()
	 let Spent : Double
	 let Date : String
	 let Place : String
	 let category: String
}

/// funcs to load news data

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

	let newBill = RecentBillsData(Spent: spent, Date: date, Place: place, category: category)
	
	var currentBills = loadFromFileBills()
	
	currentBills.append(newBill)
	
	saveToFileBills(currentBills)
	
	var newBills = loadFromFileBills()
}
