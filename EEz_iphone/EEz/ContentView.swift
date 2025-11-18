//
//  ContentView.swift
//  EEz
//
//  Created by Riboldi  on 27/02/25.
//

import SwiftUI
import SwiftData
import Charts

let green = Color(UIColor(named: "Green")!)
let green2 = Color(UIColor(named: "Green2")!)
let white = Color(UIColor(named: "back")!)
let white2 = Color(UIColor(named: "back2")!)
let black = Color(UIColor(named: "text")!)
let black2 = Color(UIColor(named: "black")!)
let red = Color(UIColor(named: "red")!)
let orange = Color(UIColor(named: "Orange")!)
let purple = Color(UIColor(named: "Purple")!)
let accent = Color(UIColor(named: "AccentColor")!)
let divider = Color(UIColor(named: "Divider")!)


/// DATA Stuff

struct MonthlyBudget : Codable, Hashable, Identifiable {
	var id : UUID = UUID()
	var total : Double
	var spent : Double
}

let budget_data : [MonthlyBudget] = [MonthlyBudget(total: 1600, spent: 500)]




struct ContentView: View {
    var body: some View {
		VStack (alignment: .leading) {
			
			HStack (spacing: 10){
				
				RoundedRectangle(cornerRadius: 20)
					.fill(white)
					.frame(width: 270, height: 270)
					.overlay(
						Chart {
							ForEach(budget_data) { data in
								SectorMark(
									angle: .value("Spent", data.spent),
									innerRadius: .ratio(0.5),
									angularInset: 10
								)
								.foregroundStyle(red)
								.cornerRadius(20)

								SectorMark(
									angle: .value("Left", data.total - data.spent),
									innerRadius: .ratio(0.5)
								)
								.foregroundStyle(green2)
								.cornerRadius(20)
							}
						}
						.frame(height: 200)
					)
			
				RoundedRectangle(cornerRadius: 20)
					.fill(white)
					.frame(width: 100, height: 270)
					.overlay(
						Text("HI")
					)
				
			}
		}
    }
}

#Preview {
    ContentView()
}
