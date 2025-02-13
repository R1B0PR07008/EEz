//
//  files_func.swift
//  EEz
//
//  Created by Riboldi  on 15/01/25.
//

import Foundation
import CryptoKit
import Security
import CSV

/// func to import csv data
 
func getCSVData(ticker : String) -> Array<dat> {
	var records = [dat] ()
	

		stream = InputStream(url: URL(fileURLWithPath: "/Users/riboldi_jr/Documents/GitHub/EEz/EEz.swiftpm/Resources/\(ticker).csv")) /// Fix this
		do {
			let reader = try CSVReader(stream: stream, hasHeaderRow: true)
			let decoder = CSVRowDecoder()
			
			while reader.next() != nil {
				let row = try decoder.decode(dat.self, from: reader)
				records.append(row)
			}
		}
		catch {
			print("Error reading CSV file: \(error)")
		}
		
		return records
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

struct CryptoHelper {
	
	/// Encrypts JSON data using AES-GCM
	static func encryptJSON<T: Encodable>(_ object: T, key: SymmetricKey) -> (ciphertext: Data, nonce: Data)? {
		do {
			// Convert object to JSON
			let jsonData = try JSONEncoder().encode(object)
			
			// Generate a random nonce (12 bytes)
			let nonce = AES.GCM.Nonce()
			
			// Encrypt using AES-GCM
			let sealedBox = try AES.GCM.seal(jsonData, using: key, nonce: nonce)
			
			// Return encrypted data and nonce
			return (sealedBox.ciphertext, nonce.withUnsafeBytes { Data($0) })
		} catch {
			print("Encryption Error: \(error)")
			return nil
		}
	}
	
	/// Decrypts AES-GCM encrypted data back to JSON
	static func decryptJSON<T: Decodable>(ciphertext: Data, nonce: Data, type: T.Type, key: SymmetricKey) -> T? {
		do {
			// Convert nonce back
			let nonceObject = try AES.GCM.Nonce(data: nonce)
			
			// Create SealedBox from encrypted data
			let sealedBox = try AES.GCM.SealedBox(nonce: nonceObject, ciphertext: ciphertext, tag: Data())
			
			// Decrypt
			let decryptedData = try AES.GCM.open(sealedBox, using: key)
			
			// Decode JSON
			let decodedObject = try JSONDecoder().decode(T.self, from: decryptedData)
			return decodedObject
		} catch {
			print("Decryption Error: \(error)")
			return nil
		}
	}
}

/// In case I ever need it.
func encryptOldData() {
	let fileURL = URL(fileURLWithPath: "/Users/riboldi_jr/Documents/GitHub/EEz/EEz.swiftpm/Resources/bills.json")
	//  "/Users/riboldi_jr/Documents/GitHub/EEz/EEz.swiftpm/Resources/bills.json"

	do {
		// Load the old unencrypted data
		let oldData = try Data(contentsOf: fileURL)
		
		// Encrypt the data
		let key = KeychainHelper.retrieveKey()!
		let sealedBox = try AES.GCM.seal(oldData, using: key)
		let encryptedData = sealedBox.combined

		// Save encrypted data
		try encryptedData?.write(to: fileURL)

		print("✅ Old data successfully encrypted!")

		// TODO: Store the `key` securely (e.g., in the Keychain)
		
	} catch {
		print("❌ Error encrypting old data: \(error)")
	}
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
		print("ERROR2 \(error)")
		return []
	}
}

/// Bills Data loader

func saveToFileBills(_ bills: [RecentBillsData]) {
	let fileURL = URL(fileURLWithPath: "/Users/riboldi_jr/Documents/GitHub/EEz/EEz.swiftpm/Resources/bills.json")

	// Encode the data
	guard let encoded = try? JSONEncoder().encode(bills) else {
		print("Failed to encode bills.")
		return
	}

	// Get the encryption key
	guard let key = KeychainHelper.retrieveKey() else {
		print("Failed to retrieve encryption key.")
		return
	}

	// Encrypt data
	do {
		let sealedBox = try AES.GCM.seal(encoded, using: key)
		let encryptedData = sealedBox.combined // Encrypted payload

		// Save to file
		try encryptedData?.write(to: fileURL)
//		print("Bills successfully encrypted and saved!")
	} catch {
		print("Encryption failed: \(error)")
	}
}

func loadFromFileBills() -> [RecentBillsData] {
	let fileURL = URL(fileURLWithPath: "/Users/riboldi_jr/Documents/GitHub/EEz/EEz.swiftpm/Resources/bills.json")

	// Load encrypted data
	guard let encryptedData = try? Data(contentsOf: fileURL) else {
		print("No encrypted data found.")
		return []
	}

	// Get the encryption key
	guard let key = KeychainHelper.retrieveKey() else {
		print("Failed to retrieve encryption key.")
		return []
	}

	// Decrypt data
	do {
		let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
		let decryptedData = try AES.GCM.open(sealedBox, using: key)

		// Decode JSON
		let decodedBills = try JSONDecoder().decode([RecentBillsData].self, from: decryptedData)
//		print("Bills successfully decrypted!")
		return decodedBills
	} catch {
		print("Decryption failed: \(error)")
	}

	return []
}

func addNewBill(spent: Double, date: String, place: String, category: String) {
	let newBill = RecentBillsData(spent: spent, date: date, place: place, category: category)

	// Load existing bills (decrypted)
	var currentBills = loadFromFileBills()

	// Append the new bill
	currentBills.append(newBill)

	// Save updated bills (encrypted)
	saveToFileBills(currentBills)

	// Debugging: Reload and verify it was saved correctly
	let newBills = loadFromFileBills()
	print("New bill added. Total bills: \(newBills.count)")
}
