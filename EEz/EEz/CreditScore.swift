//
//  CreditScore.swift
//  EEz
//
//  Created by Riboldi on 14/12/24.
//

import SwiftUI
import Charts

/// vars

var total = 850
var current_Score = 600
var ScoreLeft = total-current_Score

struct creditScoreHIstory : Identifiable {
	let id = UUID()
	let date: String
	let score: Double
}

struct graph_Pie_credit: View {
	
	/// pie chart data
	
	let Budget = [
		("Current Score", Double(current_Score), green),
		("Left to Improve", Double(ScoreLeft), red)
	]
	
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
				ForEach(Budget, id: \.0) { category, value, color in
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
				ForEach(Budget, id: \.0) { category, _, color in
					HStack {
						Circle()
							.fill(color)
							.frame(width: 10, height: 10)
						Text(category)
							.font(.system(size: 16))
							.foregroundColor(black)
					}
				}
			}
		}
	}
}

struct CreditScore: View {
	
	var percentDiffMonthly_credit = 10
	
	let creditScoreHistory : [creditScoreHIstory] = [
		creditScoreHIstory(date: "2021-01-15", score: 700),
		creditScoreHIstory(date: "2021-02-15", score: 600),
		creditScoreHIstory(date: "2021-03-15", score: 650),
		creditScoreHIstory(date: "2021-04-15", score: 670),
		creditScoreHIstory(date: "2021-05-15", score: 690),
		creditScoreHIstory(date: "2021-06-15", score: 700),
		creditScoreHIstory(date: "2021-07-15", score: 730),
		creditScoreHIstory(date: "2021-08-15", score: 700)
	]
	
	var body: some View {

		NavigationView {
			VStack(spacing: 15) {
				graph_Pie_credit()
					.frame(width: 360, height: 310)

				
				RoundedRectangle(cornerRadius: 20)
					.fill(white)
					.frame(width: 370, height: 200)
					.overlay(
						HStack {
							VStack {
								Text("Your Current \nCredit Score \nHistory")
									.font(.system(size: 20, weight: .semibold))
								
								Spacer()
									.frame(height: 30)
								
								Text("Up \(percentDiffMonthly_credit)% from last month")
							}
							
							Divider().frame(width: 1, height: 170).overlay(Color(red: 176/255, green: 216/255, blue: 212/255))
								.padding(.horizontal, 10)
							
							Chart(creditScoreHistory) { item in
								LineMark(
									x: .value("Date", item.date),
									y: .value("Score", item.score)
								)
								.foregroundStyle(green)
								AreaMark(
									x: .value("Date", item.date),
									y: .value("Score", item.score)
								).foregroundStyle(
									LinearGradient(colors: [green.opacity(0.8), green.opacity(0.1)], startPoint: .top, endPoint: .bottom)
								)
							}
							.frame(width: 170, height: 160)
						}
					)
				
					RoundedRectangle(cornerRadius: 20)
						.fill(white)
						.frame(width: 370, height: 90)
						.overlay(
							VStack {
								Text("What to do to improve your score?")
									.font(.system(size: 20, weight: .semibold))
									.foregroundStyle(black)
									.frame(width: 350)
								HStack {
									Text("• Make sure to pay your bills on time. ")
										.font(.system(size: 18, weight: .semibold))
										.foregroundStyle(black)
										.padding(.horizontal, 20)
									
									Spacer()
								}
								.frame(width: 350)
							}
						)

			}
		}
	}
}

#Preview {
	CreditScore()
}
