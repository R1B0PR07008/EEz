//
//  files_func.swift
//  EEz
//
//  Created by Riboldi  on 15/01/25.
//

import Foundation
import SwiftUI
import CryptoKit
import Security
import CSV

/// func to import csv data
 
func csvStringToDictionary(csvString: String) -> [[String: String]]? {
	let lines = csvString.components(separatedBy: "\n").filter { !$0.isEmpty }
	guard let headerLine = lines.first else { return nil }
	
	let headers = headerLine.components(separatedBy: ",")
	var result: [[String: String]] = []
	
	for line in lines.dropFirst() {
		let values = line.components(separatedBy: ",")
		guard values.count == headers.count else { continue }
		
		var rowDict: [String: String] = [:]
		for (index, header) in headers.enumerated() {
			rowDict[header] = values[index]
		}
		result.append(rowDict)
	}
	
	return result
}

/// function to turn csv to swift array (stocks)

func parseCSVToDatArray(_ ticker: String) -> [dat] {
	let csvString = UserDefaults.standard.string(forKey: "\(ticker)_csv") ?? ""
	
//	print("\n####################################################### csvString ###########################################################\n\n\(csvString)")
	
	var result: [dat] = []
	
	// Split rows using "NEWLINE," while trimming extra commas
	let rows = csvString
		.split(separator: ",NEWLINE,")
		.dropFirst() // Remove header row
	
//	print("rows: \(rows)")
	
	for row in rows {
		let columns = row.split(separator: ",").dropFirst() // Drop index column

		if columns.count >= 8 { // Ensure correct number of columns
			let date = columns[1].trimmingCharacters(in: .whitespacesAndNewlines)
			let isLarger = columns[8].trimmingCharacters(in: .whitespacesAndNewlines)
			
			if let open = Double(columns[2]),
			   let high = Double(columns[3]),
			   let low = Double(columns[4]),
			   let close = Double(columns[5]),
			   let volume = Double(columns[6]),
			   let diff = Double(columns[7]) {
				
				let dataEntry = dat(Date: date, Open: open, High: high, Low: low, Close: close, Volume: volume, Diff: diff, isLarger: isLarger)
				result.append(dataEntry)
			}
		}
	}
	
	return result
}

/// Data Encryption functions

struct KeychainHelper {
	
	private static let keyIdentifier = "com.EEz.aesKey"
	
	/// Saves the AES key securely in Keychain
	static func storeKey(_ key: SymmetricKey) {
		let keyData = key.withUnsafeBytes { Data($0) }
		
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: keyIdentifier,
			kSecValueData as String: keyData,
			kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
		]
		
		// Delete old key if exists
		SecItemDelete(query as CFDictionary)
		
		// Store new key
		let status = SecItemAdd(query as CFDictionary, nil)
		if status == errSecSuccess {
			print("✅ AES Key stored in Keychain")
		} else {
			print("❌ Error storing AES Key: \(status)")
		}
	}

	/// Retrieves the AES key from Keychain
	static func retrieveKey() -> SymmetricKey? {
		let query: [String: Any] = [
			kSecClass as String: kSecClassGenericPassword,
			kSecAttrAccount as String: keyIdentifier,
			kSecReturnData as String: true,
			kSecMatchLimit as String: kSecMatchLimitOne
		]
		
		var result: AnyObject?
		let status = SecItemCopyMatching(query as CFDictionary, &result)
		
		if status == errSecSuccess, let keyData = result as? Data {
			return SymmetricKey(data: keyData)
		} else {
			print("❌ Error retrieving AES Key: \(status)")
			return nil
		}
	}
}

/// news loader

nonisolated(unsafe) var newsArray: [newsDataStructure] = [] // Stores parsed Swift array

func saveNewsToCSVString(_ news: [newsDataStructure]) {
	
	
	var csvString = "id,sourceId,sourceName,author,title,description,url,urlToImage,publishedAt,content\n" // CSV Header
	
	for item in news {
		let row = """
		"\(item.source)",\
		"\(item.author ?? "NULL")",\
		"\(item.title)",\
		"\(item.description)",\
		"\(item.publishedAt)",\
		"\(item.content)"
		"""
		csvString.append("\(row)\n")
	}
	
	// Store in global string variable
	UserDefaults.standard.set(csvString, forKey: "news_csv")
	print("✅ News saved to CSV string!")
}

func loadNewsFromCSVString() -> [newsDataStructure] { /// WORKED FIRST TIME!!!!!!!!!!!!!!!
	
	let news = UserDefaults.standard.string(forKey: "news_csv")!
	
	let columns = news.components(separatedBy: ",")
	
	print("columns (news): \(columns)")
	
	// Ensure we have at least one full row (id, spent, date, place, category)
	guard columns.count > 6 else {
		print("Invalid CSV data")
		return []
	}
	
	var parsedNews: [newsDataStructure] = []
	
	for i in stride(from: 6, to: columns.count, by: 6) {
		if i + 4 < columns.count { // Ensure we don't go out of bounds
			
			let source = columns[i + 1]
			let author = columns[i + 2]
			let title = columns[i + 3]
			let description = columns[i + 4]
			let pubAt = columns[i + 5]
			let content = columns[i + 6]
			
			let bill = newsDataStructure(source: source, author: author, title: title, description: description, publishedAt: pubAt, content: content)
			parsedNews.append(bill)
		}
	}
	
	print("✅ News loaded into Swift array!")
	
	print(parsedNews)
	
	return parsedNews
}

/// Bills Data loader and encryption stuff
struct CryptoHelper {
	
	/// Encrypts an array of `RecentBillsData` and returns it as a Base64 encoded string
	static func encryptCSVToString(_ csvString: String, key: SymmetricKey) -> String? {
		
		do {
			let csvData = csvString.data(using: .utf8)!
			let nonce = AES.GCM.Nonce()

			let sealedBox = try AES.GCM.seal(csvData, using: key, nonce: nonce)

			// ✅ Convert nonce to `Data`
			let nonceData = nonce.withUnsafeBytes { Data($0) }
			
			// ✅ Store nonce + ciphertext + tag together
			var combinedData = Data()
			combinedData.append(nonceData) // Fix: Convert nonce to Data before appending
			combinedData.append(sealedBox.ciphertext)
			combinedData.append(sealedBox.tag)
			
			var result = combinedData.base64EncodedString()
			
			UserDefaults.standard.set(result, forKey: "bills_csv")
			
			return result
		} catch {
			print("❌ Encryption Error: \(error)")
			return nil
		}
	}
	
	/// Decrypts AES-GCM encrypted CSV data from a string and converts it to `[RecentBillsData]`
	static func decryptCSVFromString(_ encryptedString: String, key: SymmetricKey) -> [RecentBillsData]? {
		
		let encryptedString : String = UserDefaults.standard.string(forKey: "bills_csv")!
		
		guard let encryptedData = Data(base64Encoded: encryptedString) else {
			print("❌ Invalid encrypted data format.")
			return nil
		}

		// ✅ Ensure data is at least 28 bytes (12-byte nonce + tag + ciphertext)
		guard encryptedData.count > 28 else {
			print("❌ Encrypted data too short")
			return nil
		}

		// ✅ Extract nonce, ciphertext, and tag correctly
		let nonceData = encryptedData.prefix(12) // First 12 bytes (nonce)
		let ciphertextAndTag = encryptedData.suffix(from: 12) // Remaining bytes

		// ✅ Extract tag (last 16 bytes)
		let tag = ciphertextAndTag.suffix(16)
		let ciphertext = ciphertextAndTag.dropLast(16)

		do {
			let nonce = try AES.GCM.Nonce(data: nonceData) // Convert to nonce object
			let sealedBox = try AES.GCM.SealedBox(nonce: nonce, ciphertext: ciphertext, tag: tag)
			let decryptedData = try AES.GCM.open(sealedBox, using: key)
			
			// ✅ Convert decrypted CSV string to `[RecentBillsData]`
			if let csvString = String(data: decryptedData, encoding: .utf8) {
				
				UserDefaults.standard.set(String(csvString), forKey: "bills1_csv")
				
				return parseCSVToBills(csvString)
			}
		} catch {
			print("❌ Decryption Error: \(error)")
		}

		return nil
	}
	
	/// Encrypts CSV data using AES-GCM
	static func encryptCSV(_ csvString: String, key: SymmetricKey) -> (ciphertext: Data, nonce: Data)? {
		do {
			let csvData = csvString.data(using: .utf8)!
			let nonce = AES.GCM.Nonce()
			let sealedBox = try AES.GCM.seal(csvData, using: key, nonce: nonce)
			return (sealedBox.ciphertext, nonce.withUnsafeBytes { Data($0) })
		} catch {
			print("Encryption Error: \(error)")
			return nil
		}
	}
	
	/// Decrypts AES-GCM encrypted data back to CSV string
	static func decryptCSV(ciphertext: Data, nonce: Data, key: SymmetricKey) -> String? {
		do {
			let nonceObject = try AES.GCM.Nonce(data: nonce)
			let sealedBox = try AES.GCM.SealedBox(nonce: nonceObject, ciphertext: ciphertext, tag: Data())
			let decryptedData = try AES.GCM.open(sealedBox, using: key)
			return String(data: decryptedData, encoding: .utf8)
		} catch {
			print("Decryption Error: \(error)")
			return nil
		}
	}
	
	/// Parses CSV string into an array of `RecentBillsData`
	static func parseCSVToBills(_ csvString: String) -> [RecentBillsData] {
		let columns = csvString.components(separatedBy: ",")
		
		// Ensure we have at least one full row (id, spent, date, place, category)
		guard columns.count > 5 else {
			print("Invalid CSV data")
			return []
		}
		
		var parsedBills: [RecentBillsData] = []
		
		// Skip the first 5 elements (headers) and process in chunks of 5
		for i in stride(from: 5, to: columns.count, by: 5) {
			if i + 4 < columns.count { // Ensure we don't go out of bounds
				
				let spent = Double(columns[i + 1])!
				let date = columns[i + 2]
				let place = columns[i + 3]
				let category = columns[i + 4]
				
				let bill = RecentBillsData(spent: spent, date: date, place: place, category: category)
				parsedBills.append(bill)
			}
		}
		
		return parsedBills
	}
	
	static func parseCSVToBill2(_ csvString: String) -> [RecentBillsData] {
		let columns = csvString.components(separatedBy: ",")
		
		// Ensure we have at least one full row (id, spent, date, place, category)
		guard columns.count > 5 else {
			print("Invalid CSV data")
			return []
		}
		
		var parsedBills: [RecentBillsData] = []
		
		// Skip the first 5 elements (headers) and process in chunks of 5
		for i in stride(from: 5, to: columns.count, by: 5) {
			if i + 4 < columns.count { // Ensure we don't go out
		
				let spent = Double(columns[i + 5])!
				let date = columns[i + 1]
				let place = columns[i + 2]
				let category = columns[i + 3]
				
				let bill = RecentBillsData(spent: spent, date: date, place: place, category: category)
				parsedBills.append(bill)
			}
		}
		
		return parsedBills
	}

	
	static func serializeBillsToCSV(_ bills: [RecentBillsData]) -> String {
		var csvString = "id,spent,date,place,category" // Header row
		
		for bill in bills {
			csvString.append(",\(bill.id),\(bill.spent),\(bill.date),\(bill.place),\(bill.category)")
		}
		
		return csvString
	}
	
	static func addNewBill(spent: Double, date: String, place: String, category: String) { /// for some reason this fucntion is encrypting the old (already encrypted) data so it is double encrypting it (I think). Not ideal.
		
		let key = KeychainHelper.retrieveKey()!
		
		let encryptedData = UserDefaults.standard.string(forKey: "bills_csv")!
		
//		print("\n encrypted data: \(encryptedData)")
		
		let decryptedData : [RecentBillsData]! = decryptCSVFromString(encryptedData, key: key)!
		
		var modifieableData : [RecentBillsData]! = decryptedData!
		
//		print("\n decrypted data: \(type(of: modifieableData))")
		
		let newData = RecentBillsData(spent: spent, date: date, place: place, category: category)
		
		modifieableData.append(newData)
		
//		print("\n New data \(modifieableData)")
		
		let newDataCsv = serializeBillsToCSV(modifieableData)
		
//		print("\n New data csv: \n\(newDataCsv)")
		
		let encryptedNewData = encryptCSVToString(newDataCsv, key: key)!
		
//		print("\n new encrypted data: \n\(encryptedNewData)")
		
//		print("\n new data Decrypted: \n\(decryptCSVFromString(encryptedData, key: key)!)")
		
		
		
	}
}
