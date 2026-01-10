//
//  SwiftUIView.swift
//  EEz
//
//  Created by Riboldi  on 02/02/25.
//

import SwiftUI

/// Enconding and Decoding arrays as csv files:

func encodeArrayToCSV(_ array: [String]) -> String {
	let quotedValues = array.map { "\"\($0)\"" }
	return quotedValues.joined(separator: ",")
}

func decodeCSVToArray(_ csvString: String) -> [String] {
	let components = csvString.components(separatedBy: "\",\"")
	return components.map { $0.replacingOccurrences(of: "\"", with: "") }
}

nonisolated(unsafe) var customCategories: [String] = []

struct Add_bill: View {
	
	@AppStorage("billsRefreshTrigger") private var billsRefreshTrigger = 0
	
	@State private var selectedCategory: String = Category.Gas.rawValue
	@State private var newCategory: String = ""
	
	@State private var spent_ : String = ""
	@State private var date : Date = Date()
	@State private var dateStr : String = ""
	@State private var place : String = ""
	@State private var category : Category = .Subscriptions
	@State private var categoryStr : String = ""
	
	enum Category: String, CaseIterable, Identifiable {
		case Clothes, Fast_Food, Super_Market, Subscriptions, Gas, Coffee

		var id: Self { self }
		
		static var allCases: [Category] {
			return [.Clothes, .Fast_Food, .Super_Market, .Subscriptions, .Gas, .Coffee]
		}
	}
	
	private var customCategories: [String] {
		if let data = UserDefaults.standard.string(forKey: "customCategories"),
			let decoded = try? JSONDecoder().decode([String].self, from: Data(data.utf8)) {
			return decoded
		}
		return []
	}
	
	var allCategories: [String] {
		let defaultCategories = Category.allCases.map { $0.rawValue }
		return defaultCategories + customCategories
	}
	
	var body: some View {
		VStack {
			RoundedRectangle(cornerRadius: 20)
				.tintedGlassShape(color: white)
				.frame(width: 550, height: 650)
				.overlay(
					VStack {
						VStack (alignment: .leading) {
							
							Text("Add Bill")
								.font(.system(size: 40, weight: .semibold))
							
							RoundedRectangle(cornerRadius: 40)
								.tintedGlassShape(color: white2)
								.frame(width: 450, height: 60)
								.overlay(
									HStack {
										
										Text("Spent ($)")
											.font(.system(size: 20, weight: .semibold))
											.padding(.leading, 20)
											.frame(width: 170)
										
										RoundedRectangle(cornerRadius: 40)
											.tintedGlassShape(color: white)
											.frame(width: 200, height: 40)
											.overlay(
												TextField("$...", text: $spent_)
													.padding(.leading, 10)
													.font(.system(size: 20))
											)
									}
								)
								.padding(.bottom, 20)
							
							
							RoundedRectangle(cornerRadius: 40)
								.tintedGlassShape(color: white2)
								.frame(width: 450, height: 60)
								.overlay(
									HStack {
										
										Text("Date")
											.font(.system(size: 20, weight: .semibold))
											.padding(.leading, 20)
											.frame(width: 170)
										
										VStack{
											DatePicker(
												"",
												selection: $date,
												displayedComponents: [.date]
											)
											.frame(width: 100)
										}.frame(width: 200)
									}
								)
								.padding(.bottom, 20)
							
							RoundedRectangle(cornerRadius: 40)
								.tintedGlassShape(color: white2)
								.frame(width: 450, height: 60)
								.overlay(
									HStack {
										
										Text("Place (Store) ")
											.font(.system(size: 20, weight: .semibold))
											.padding(.leading, 20)
											.frame(width: 170)
										
										RoundedRectangle(cornerRadius: 40)
											.tintedGlassShape(color: white)
											.frame(width: 200, height: 40)
											.overlay(
												TextField("Store Name", text: $place)
													.padding(.leading, 10)
													.font(.system(size: 20))
											)
									}
								)
								.padding(.bottom, 20)
							
							RoundedRectangle(cornerRadius: 20)
								.tintedGlassShape(color: white2)
								.frame(width: 450, height: 120)
								.overlay(
									VStack (alignment: .leading) {
										
										Text("Category")
											.font(.system(size: 20, weight: .semibold))
											.padding(.leading, -60)
											.frame(width: 170)
										
										RoundedRectangle(cornerRadius: 20)
											.tintedGlassShape(color: white)
											.frame(width: 420, height: 50)
											.overlay(
												HStack {
													Picker("Select category", selection: $selectedCategory) {
														ForEach(allCategories, id: \.self) { category in
															Text(replaceUnderscoresWithSpaces(in: category)).tag(category)
														}
													}
													.accentColor(black)
													.padding(.leading, 10)
													.frame(width: 200)
													
													Spacer()
													
													HStack {
														RoundedRectangle(cornerRadius: 20)
															.tintedGlassShape(color: white2)
															.frame(width: 150, height: 40)
															.overlay(
																TextField("New category", text: $newCategory)
																	.padding(.leading, 20)
															)
														
														Button("Add") {
															if !newCategory.isEmpty && !customCategories.contains(newCategory) {
																addCategory(newCategory)
																newCategory = ""
															}
														}
														.frame(width: 55, height: 40)
														.background {
															TintedGlassShapeView(
																shape: RoundedRectangle(cornerRadius: 20),
																color: white2
															)
														}
														.foregroundStyle(black)
														.cornerRadius(20)
														.frame(width: 55)
													}
													.padding()
												}
											)
									}
								)
								.padding(.bottom, 50)
						}
						
						VStack {
							Button(action: {
								
								let dateFormatter = DateFormatter()
									dateFormatter.dateFormat = "yyyy-MM-dd"
									dateFormatter.timeZone = TimeZone.current  // Use local timezone
									dateStr = dateFormatter.string(from: date)
								
								categoryStr = replaceUnderscoresWithSpaces(in: selectedCategory)
								
								CryptoHelper.addNewBill(spent: Double(spent_)!, date: dateStr, place: place, category: categoryStr)
								
								// Trigger refresh
								billsRefreshTrigger += 1
								
							}, label: {
								RoundedRectangle(cornerRadius: 20)
									.tintedGlassShape(color: white2)
									.frame(width: 250, height: 70)
									.overlay(
										Text("Enter Bill Data")
											.foregroundColor(black)
											.font(.system(size: 30, weight: .semibold))
									)
							})
						}
					}
				)
		}
	}
	
	private func addCategory(_ category: String) {
		var updatedCategories = customCategories
		updatedCategories.append(category)

		if let encoded = try? JSONEncoder().encode(updatedCategories),
		   let jsonString = String(data: encoded, encoding: .utf8) {
			UserDefaults.standard.set(jsonString, forKey: "customCategories")
		}
	}
}

#Preview(traits: .landscapeLeft) {
	Add_bill()
}
