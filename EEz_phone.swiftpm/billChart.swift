//
//  billChart.swift
//  EEz
//
//  Created by Riboldi  on 07/11/24.
//

import SwiftUI
import Charts

/// "cookie" var

nonisolated(unsafe) var cookie: String = "Gas"

/// data structure

struct bills_data : Identifiable, Codable {
	let id: UUID
	let category: String
	let data_: [Data_]
}

struct Data_ : Identifiable, Codable {
	let id: UUID
	let month: String
	let value: Double
	let budget: Double
}

/// Bills data

var Bills_Data: [bills_data] {
	get { loadFromFile() }
	set { saveToFile(newValue) }
}

/// func for graph by category

func graph_line(category: String) -> some View {
	
	var data : [EEz.Data_] = []
	
	if let Bills = Bills_Data.first(where: { $0.category == category })?.data_ {
		data = Bills
		print(Bills)
	} else {
		print("No bill found for the \(category) category.")
	}
	
	return
	
		VStack{
			Chart {
				ForEach(data, id: \.id) {item in
					AreaMark(
						x: .value("Month", item.month),
						y: .value("Spent", item.budget)
					)
					.foregroundStyle(
						LinearGradient (
							gradient: Gradient(colors: [green,green.opacity(0.1)]),
							startPoint: .top,
							endPoint: .bottom
						))
					LineMark(
						x: .value("Month", item.month),
						y: .value("Sales", item.value)
					)
					.foregroundStyle(red)
					
				}
			}.frame(width:180, height: 150)
			
			// X-Axis Stuff
				.chartXAxis {
					AxisMarks(values: .automatic) { _ in
						AxisGridLine()
						AxisTick()
						AxisValueLabel()
							.font(.system(size: 6, weight: .medium, design: .rounded)) // X-axis label font
					}
				}
			
				.chartXAxisLabel("Month")
				.chartYAxisLabel("$ (USD)")
			
			// Y-Axis Stuff
				.chartYAxis {
					AxisMarks(values: .automatic) { _ in
						AxisGridLine()
						AxisTick()
						AxisValueLabel()
							.font(.system(size: 7, weight: .medium, design: .rounded)) // Y-axis label font
					}
				}
			
			HStack(spacing: 6) {
				
				Circle()
					.fill(red)
					.frame(width: 8, height: 8)
				
				Text("Spent")
					.font(.system(size: 14))
				
				Circle()
					.fill(green)
					.frame(width: 8, height: 8)
				
				Text("Budget")
					.font(.system(size: 14))
				
			}
		}
}

func getTotalSpent(Categroy: String!) -> String {
	let catg = Categroy
	
	let vills_data : [[String : String]] = bills.filter {$0["Category"] == catg}
	let totalSpent = vills_data.compactMap { $0["Spent"] }.compactMap { Double($0) }.reduce(0, +)
	let formattedTotalSpent = String(format: "%.2f", totalSpent)
	
	return formattedTotalSpent
}

struct billChart: View {
    var body: some View {
		
		NavigationView(content: {
			
			VStack {
				Text("Bills Sorted By Category")
					.font(.system(size: 20, weight: .semibold))
				
						ScrollView(Axis.Set.vertical) {
							VStack(alignment: .leading) {
								
								NavigationLink(destination: bills_inDepth(), label: {
									RoundedRectangle(cornerRadius: 25)
										.fill(white)
										.frame(width: 370,height: 200)
										.overlay(
											HStack(alignment: .center) {
												VStack {
													Text("Gas")
														.font(.system(size: 20, weight: .semibold))
													
													RoundedRectangle(cornerRadius: 30)
														.fill(white2)
														.frame(width: 100,height: 50)
														.overlay(
															Text(getTotalSpent(Categroy: "Gas"))
																.font(.system(size: 20, weight: .semibold))
														)
													
													Button(action: {print(Bills_Data)}, label: {
														Text("hello")
													})
													
												}.frame(width: 130)
												
												Divider().frame(width: 1, height: 160).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
												
												graph_line(category: "Gas")
												
												
												
											}
										)
								})
								.foregroundStyle(black)
								.simultaneousGesture(TapGesture().onEnded({
									cookie = "Gas"
								}))
								
								
								NavigationLink(destination: bills_inDepth(), label: {
									RoundedRectangle(cornerRadius: 25)
										.fill(white)
										.frame(width: 370,height: 200)
										.overlay(
											HStack(alignment: .center) {
												VStack {
													Text("Super Market")
														.font(.system(size: 20, weight: .semibold))
													
													RoundedRectangle(cornerRadius: 30)
														.fill(white2)
														.frame(width: 100,height: 50)
														.overlay(
															Text(getTotalSpent(Categroy: "Super Market"))
																.font(.system(size: 20, weight: .semibold))
														)
												}.frame(width: 130)
												
												Divider().frame(width: 1, height: 160).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
												
												graph_line(category: "Super Market")
												
											}
										
										)
								})
								.foregroundStyle(black)
								.simultaneousGesture(TapGesture().onEnded({
									cookie = "Super Market"
								}))
								
								
								NavigationLink(destination: bills_inDepth(), label: {
									RoundedRectangle(cornerRadius: 25)
										.fill(white)
										.frame(width: 370,height: 200)
										.overlay(
											HStack(alignment: .center) {
												VStack {
													Text("Fast Food")
														.font(.system(size: 20, weight: .semibold))
													
													RoundedRectangle(cornerRadius: 30)
														.fill(white2)
														.frame(width: 100,height: 50)
														.overlay(
															Text(getTotalSpent(Categroy: "Fast Food"))
																.font(.system(size: 20, weight: .semibold))
														)
												}.frame(width: 130)
												
												Divider().frame(width: 1, height: 160).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
												
												graph_line(category: "Fast Food")
												
											}
										)
								})
								.foregroundStyle(black)
								.simultaneousGesture(TapGesture().onEnded({
									cookie = "Fast Food"
								}))
								
								
								NavigationLink(destination: bills_inDepth(), label: {
									RoundedRectangle(cornerRadius: 25)
										.fill(white)
										.frame(width: 370,height: 200)
										.overlay(
											HStack(alignment: .center) {
												VStack {
													Text("Clothes")
														.font(.system(size: 20, weight: .semibold))
													
													RoundedRectangle(cornerRadius: 30)
														.fill(white2)
														.frame(width: 100,height: 50)
														.overlay(
															Text(getTotalSpent(Categroy: "Clothes"))
																.font(.system(size: 20, weight: .semibold))
														)
												}.frame(width: 130)
												
												Divider().frame(width: 1, height: 160).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
												
												graph_line(category: "Clothes")
												
											}
										)
								})
								.foregroundStyle(black)
								.simultaneousGesture(TapGesture().onEnded({
									cookie = "Clothes"
								}))

								
								NavigationLink(destination: bills_inDepth(), label: {
									RoundedRectangle(cornerRadius: 25)
										.fill(white)
										.frame(width: 370,height: 200)
										.overlay(
											HStack(alignment: .center) {
												VStack {
													Text("Subscriptions")
														.font(.system(size: 20, weight: .semibold))
													
													RoundedRectangle(cornerRadius: 30)
														.fill(white2)
														.frame(width: 100,height: 50)
														.overlay(
															Text(getTotalSpent(Categroy: "Subscriptions"))
																.font(.system(size: 20, weight: .semibold))
														)
												}.frame(width: 130)
												
												Divider().frame(width: 1, height: 160).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
												
												graph_line(category: "Subscriptions")
												
											}
										)
								})
								.foregroundStyle(black)
								.simultaneousGesture(TapGesture().onEnded({
									cookie = "Subscriptions"
								}))
								
								
							}
						}
			}
				})
    }
}

#Preview {
    billChart()
}
