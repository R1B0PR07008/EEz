//
//  Invest_Portfo.swift
//  EEz
//
//  Created by Riboldi  on 02/01/25.
//

import SwiftUI
import Charts

/// investment data

let Investment_list = [ /// Name, Category, Value ($), Performance, Color
	("APPL", "Stock", 1000, 10,green),
	("Beach House", "Real State", 1500, -9999999, purple),
	("Accenture", "Stock", 500, -3, red),
	("IBM", "Stock", 750, 20,orange)
]

let sortedByPerfMIN = Investment_list.sorted { $0.3 < $1.3 } 

let sortedByPerfMAX = Investment_list.sorted { $1.3 < $0.3 }

let sortedByValfMAX = Investment_list.sorted { $1.2 < $0.2 }

struct graph_Pie_InP: View {
	
	/// Bills data
	
	let bills: [[String: String]] = [
		["id": "1", "Spent": "100", "date": "12-3-2024", "place": "McDonalds"],
		["id": "2", "Spent": "130", "date":  "12-5-2024", "place":  "Gas"],
		["id": "3", "Spent": "150", "date":  "12-6-2024", "place":  "Walmart"],
		["id": "4", "Spent": "170", "date":  "12-7-2024", "place":  "Decathlon"]
	]
	
	/// first view stuff
	
	@AppStorage("first_open") var first_open : Bool = true
	
	/// other vars(hopefully global)
	
	@AppStorage("Budget") var budget : String = ""
	
	var body: some View {
		VStack {
			Chart {
				ForEach(Investment_list, id: \.0) { name, category, value, _, color in
							SectorMark(
								angle: .value("Value", value),
								innerRadius: .ratio(0.6),
								outerRadius: .ratio(1.0),
								angularInset: 30
							)
							.foregroundStyle(color)
							.cornerRadius(20)
							.shadow(color: color.opacity(0.8),radius: 5)
						}
			}
				.padding([Edge.Set.bottom], 20)
			
			HStack {
				ForEach(Investment_list, id: \.0) { name, _, _, _, color in
					HStack {
						Circle()
							.fill(color)
							.frame(width: 10, height: 10)
						Text(name)
							.font(.system(size: 16))
							.foregroundColor(black)
					}
				}
			}
		}
	}
}


struct Invest_Portfo: View {
    var body: some View {
		VStack {
			graph_Pie_InP()
				.frame(width: 370, height: 310)
				.padding(.bottom, 10)
			
			RoundedRectangle(cornerRadius: 20)
				.fill(white)
				.frame(width: 370, height: 130)
				.overlay(
					HStack {
						
						VStack {
							Text("Best Performing \nInvestment")
								.font(.system(size: 20, weight: .semibold))
							
							RoundedRectangle(cornerRadius: 20)
								.fill(white2)
								.frame(width: 150, height: 50)
								.overlay(
									Text("\(sortedByPerfMAX[0].0)")
										.font(.system(size: 18, weight: .semibold))
								)
							
						}
						
						Divider().frame(width: 1, height: 115).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
						
						
						VStack {
							Text("Worst Performing \nInvestment")
								.font(.system(size: 20, weight: .semibold))
							
							RoundedRectangle(cornerRadius: 20)
								.fill(white2)
								.frame(width: 150, height: 50)
								.overlay(
									Text("\(sortedByPerfMIN[1].0)")
										.font(.system(size: 18, weight: .semibold))
								)
						}
					}
				)
			
			RoundedRectangle(cornerRadius: 20)
				.fill(white)
				.frame(width: 370, height: 194)
				.overlay(
					VStack {
						Text("Where are you invested?")
							.font(.system(size: 20, weight: .semibold))
							.padding([.top, .bottom], 10)
						
						RoundedRectangle(cornerRadius: 20)
							.fill(white2)
							.frame(width: 350, height: 40)
							.overlay(
								HStack {
									Text("Name")
										.font(.system(size: 15, weight: .semibold))
										.frame(width: 95)
									
									Divider().frame(width: 1, height: 25).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
									
									Text("Category")
										.font(.system(size: 15, weight: .semibold))
										.frame(width: 85)
									
									Divider().frame(width: 1, height: 25).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
									
									Text("Value")
										.font(.system(size: 15, weight: .semibold))
										.frame(width: 65)
									
									Divider().frame(width: 1, height: 25).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
									
									Text("Perf.")
										.font(.system(size: 15, weight: .semibold))
										.frame(width: 45)
										
									
								}
							)

						ScrollView {
							VStack {
								ForEach(sortedByValfMAX, id: \.0) { name, category, value, performance, _ in
									
									RoundedRectangle(cornerRadius: 20)
										.fill(white2)
										.frame(width: 350, height: 40)
										.overlay(
											HStack {
												Text("\(name)")
													.font(.system(size: 15, weight: .semibold))
													.frame(width: 89)
												
												Divider().frame(width: 1, height: 25).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
												
												Text("\(category)")
													.font(.system(size: 15, weight: .semibold))
													.frame(width: 85)
												
												Divider().frame(width: 1, height: 25).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
												
												Text("\(value)")
													.font(.system(size: 15, weight: .semibold))
													.frame(width: 65)
												
												Divider().frame(width: 1, height: 25).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
												
												if performance != -9999999 {
													Text("\(performance)")
														.font(.system(size: 15, weight: .semibold))
														.frame(width: 45)
												}
												else {
													Text("~")
														.font(.system(size: 15, weight: .semibold))
														.frame(width: 45)
												}
												
											}
										)
								}
							}
						}
						
					}
				)
		}
    }
}

#Preview {
    Invest_Portfo()
}
