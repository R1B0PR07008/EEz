//
//  ContentView.swift
//  EEz
//
//  Created by Riboldi  on 07/11/24.

import SwiftUI
import Charts

let defaults = UserDefaults.standard

/// my colours

let green = Color(UIColor(named: "Green")!)
let green2 = Color(UIColor(named: "Green2")!)
let white = Color(UIColor(named: "back")!)
let white2 = Color(UIColor(named: "back2")!)
let black = Color(UIColor(named: "text")!)
let black2 = Color(UIColor(named: "black")!)
let red = Color(UIColor(named: "red")!)
let orange = Color(UIColor(named: "Orange")!)
let purple = Color(UIColor(named: "Purple")!)

/// Demo chart/table data

var budget_monthly = 8300
var spent = 4000
var investment = 2000
var Left = budget_monthly-spent

/// rounded rectangle 2 vars

var i_rr2_1 = 0

/// Bills data 

let bills: [[String: String]] = [
	["id": "1", "Spent": "10", "date": "12-3-2024", "place": "McDonalds", "Category": "Fast Food"],
	["id": "2", "Spent": "20", "date": "12-4-2024", "place": "McDonalds", "Category": "Fast Food"],
	["id": "3", "Spent": "130", "date":  "12-5-2024", "place":  "Gas", "Category": "Gas"],
	["id": "4", "Spent": "150", "date":  "12-6-2024", "place":  "Walmart", "Category": "Super mMrket"],
	["id": "5", "Spent": "170", "date":  "12-7-2024", "place":  "Decathlon", "Category": "Clothes"],
	["id": "6", "Spent": "40", "date":  "12-9-2024", "place":  "Zara", "Category": "Clothes"],
	["id": "7", "Spent": "15", "date": "12-8-2024", "place": "KFC", "Category": "Fast Food"],
	["id": "8", "Spent": "150", "date":  "12-10-2024", "place":  "Costco", "Category": "Super Market"],
	["id": "9", "Spent": "30", "date":  "12-11-2024", "place":  "Gas", "Category": "Gas"],
	["id": "10", "Spent": "40", "date":  "12-12-2024", "place":  "Gas", "Category": "Gas"],
	["id": "11", "Spent": "60", "date":  "12-13-2024", "place":  "Zara", "Category": "Clothes"],
	["id": "12", "Spent": "50", "date":  "12-14-2024", "place":  "Walmart", "Category": "Super Market"],
	["id": "13", "Spent": "10", "date":  "12-14-2024", "place":  "Disney+", "Category": "Subscriptions"],
	["id": "14", "Spent": "14", "date":  "12-14-2024", "place":  "HBO", "Category": "Subscriptions"],
	["id": "15", "Spent": "10", "date":  "12-14-2024", "place":  "Paramount+", "Category": "Subscriptions"],
	["id": "16", "Spent": "12", "date":  "12-14-2024", "place":  "Netflix", "Category": "Subscriptions"],
	
]

struct graph_Pie: View {
    
    /// pie chart data
    
    let Budget = [
        ("Left", Double(Left), green),
        ("Spent", Double(spent), red),
		("Invested", Double(spent), orange)
	]
    
    /// Bills data
    
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

struct graph_Line: View {
    
    let monthly_data = [ /// find a better way to display the months!!!
        ("1", 12343),
        ("2", 12332),
        ("3", 23324),
        ("4", 23455),
        ("5", 45675),
        ("6", 13456),
    ]
    
    var body: some View {
        Chart {
            ForEach(monthly_data, id: \.0) { month, value in
                LineMark(
                    x: .value("Month", month),
                    y: .value("Spent", value)
                )
                .foregroundStyle(green)
                
                AreaMark(
                        x: .value("Month", month),
                        y: .value("Spent", value)
                    )
                .foregroundStyle(
                    LinearGradient (
                        gradient: Gradient(colors: [green,green.opacity(0.1)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                ) /// adjust this color
            }
        }.frame(width: 190, height: 80)
            .padding(.top, 10)
    }
}

struct ContentView2: View {
    
    /// pie chart data
    
    let Budget = [
        ("Left", Double(Left), green),
        ("Spent", Double(spent), red)
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
    @AppStorage("SavingGoal") var SavingGoal : String = "300"
    @AppStorage("CurrentSaving") var CurrentSaving: Double = 200
    @AppStorage("ModularSmallRectangle") var ModularSmallRectangle : Bool = true
    @AppStorage("Pref_stock") var Pref_stock : String = "APPL"
    @AppStorage("Stocks_questionMark") var Stocks_questionMark : Bool = true
    
    /// other vars
    
    @State var stocks: [dat] = getCSVData()
    var show = false
    
    /// Dark mode detection
    
    @Environment(\.colorScheme) var colorScheme
    
    /// Make stocks optional
    
    func OPT_Stocks() {
        if Pref_stock == "" {
            UserDefaults.standard.set(false, forKey: "Stocks_questionMark")
            UserDefaults.standard.set(false, forKey: "ModularSmallRectangle")
        }
        else {
            UserDefaults.standard.set(true, forKey: "Stocks_questionMark")
        }
    }
    
    func ChangeBakcgroudGradient(item: String) -> RadialGradient {
        if item == "1" {
            if colorScheme == .light {
                return RadialGradient(colors: [green.opacity(0.5), white.opacity(0.2)], center: .center, startRadius: 0, endRadius: 200)
            }
            else {
                return RadialGradient(colors: [green.opacity(0.2), white.opacity(0.22)], center: .center, startRadius: 0, endRadius: 200)
            }
        }
        else {
            if colorScheme == .light {
                return RadialGradient(
                    gradient: Gradient(colors: [green.opacity(0.6), green]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 60
                )
            }
            else {
                return RadialGradient(
                    gradient: Gradient(colors: [green.opacity(0.62), green]),
                    center: .center,
                    startRadius: 0,
                    endRadius: 60
                )
            }

        }
    }
    
	/// ACTUAL VIEW CODE
	
    var body: some View {
        @AppStorage("SavingGoalDouble") var SavingGoalDouble: Double = (SavingGoal as NSString).doubleValue
        
        NavigationView {
            VStack(spacing: 15) {

                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(
                        ChangeBakcgroudGradient(item: "1")
                    )
                    .frame(width: 360, height:  330)
                    .overlay(
                        
                        /// Graph
                        
                        graph_Pie()
                            .frame(width: 360, height: 310)
                            .padding(.top, 10)
                        
                    )
                
                HStack(spacing: 15) {
                    VStack (spacing: 15) {
                        NavigationLink(destination: dashMonthly()) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(white)
                                .frame(width: 220, height:  260)
                                .overlay(
                                    VStack {
                                        Text("Spent this month")
                                            .font(.system(size: 20))
                                            .fontWeight(.semibold)
                                        
                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(white2)
                                            .frame(width: 130, height: 50)
                                            .overlay (
                                                Text("$\(spent)")
                                                    .font(.system(size: 20, weight: .semibold))
                                            )
                                            .padding(.bottom, 10)
                                            .shadow(color: white.opacity(0.8),radius: 5)
                                        
                                        Divider().frame(width: 190, height: 1).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
                                        
                                        /// graph 2
                                        
                                        Text("Monthly Spending")
                                        
                                        graph_Line()
                                        
                                    }
                                ).foregroundColor(black)
                        }
                        NavigationLink(destination: CreditScore()
                            .navigationTitle("Credit Score")) {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(white)
                                .frame(width: 220, height: 70)
                                .overlay(
                                    HStack {
                                        Text("Credit \nScore")
                                            .foregroundStyle(black)
                                            .font(.system(size: 18, weight: .semibold))
                                        
                                        RoundedRectangle(cornerRadius: 40)
                                            .fill(white2)
                                            .frame(width: 100, height: 45)
                                            .overlay(content: {
                                                Text("600")
                                                    .foregroundStyle(black)
                                                    .font(.system(size: 20, weight: .bold))
                                            })
                                    }
                                )
                        }
                    }
                    
                    VStack (spacing: 15) {
                            if !ModularSmallRectangle {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(white)
                                    .frame(width: 125, height: 210)
                                    .overlay(
                                        VStack {
                                            Text("Saving \n Goal")
                                                .font(.system(size: 20, weight: .semibold))
                                            
                                            
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(white2)
                                                .frame(width: 90, height: 40)
                                                .overlay (
                                                    Text("$\(SavingGoal)")
                                                        .font(.system(size: 18, weight: .semibold))
                                                )
                                                .padding(.bottom, 5)
                                                .shadow(color: white.opacity(0.8),radius: 5)
                                            
                                            /// Graph that shows how close you are to the goal.
                                            
                                            Chart {
                                                BarMark (
                                                    x: .value("", ""),
                                                    y: .value("Ammount saved",CurrentSaving)
                                                )
                                                .foregroundStyle(
                                                    LinearGradient(colors: [green, green.opacity(0.2)], startPoint: .top, endPoint: .bottom)
                                                )
                                            }
                                            .frame(width: 90, height: 70)
                                            .chartYScale(domain: [0, SavingGoalDouble])
											.chartXAxis(.hidden)
                                            
                                        }
                                            .onLongPressGesture {
                                                if Stocks_questionMark {
                                                    UserDefaults.standard.set(true , forKey: "ModularSmallRectangle")
                                                }
                                            }
                                            
                                        
                                    )
                            }
                            else if ModularSmallRectangle && Stocks_questionMark {
                                NavigationLink(destination: Stocks()
                                    .navigationTitle("Stocks")) {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(white)
                                    .frame(width: 125, height: 210)
                                    .overlay(
                                        VStack {
                                            Text("Stocks")
                                                .font(.system(size: 20, weight: .semibold))
                                                .padding(.bottom, 5)
                                            
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(white2)
                                                .frame(width: 90, height: 40)
                                                .overlay (
                                                    Text("\(Pref_stock)")
                                                        .font(.system(size: 15, weight: .semibold))
                                                )
                                                .padding(.bottom, 5)
                                                .shadow(color: white.opacity(0.8),radius: 5)
                                            
                                            Chart(stocks[0...6]) { item in
                                                LineMark(
                                                    x: .value("Date", item.Date),
                                                    y: .value("Close Price", item.Close)
                                                )
                                                .foregroundStyle(green)
                                                
                                                
                                                AreaMark(
                                                    x: .value("Date", item.Date),
                                                    y: .value("Close Price", item.Close)
                                                )
                                                .foregroundStyle(
                                                    LinearGradient (
                                                        gradient: Gradient(colors: [green,green.opacity(0.1)]),
                                                        startPoint: .top,
                                                        endPoint: .bottom
                                                    )
                                                )
                                            }.frame(width: 90, height: 80)
                                                .chartYScale(domain: [0,210]) /// automate the max value
                                                .chartXAxis(.hidden)
                                            
                                        }
                                            .onLongPressGesture {
                                                UserDefaults.standard.set(false , forKey: "ModularSmallRectangle")
                                            }
                                            
                                    )
                                }.foregroundStyle(black)
                            }
                            
                        
                        Button(action: {
                            UserDefaults.standard.set(true , forKey: "first_open")
                            print(first_open)
                        }) {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundStyle(
                                    ChangeBakcgroudGradient(item: "2")
                                )
                                .frame(width: 125, height: 125)
                                .overlay(
                                    Image(systemName: "plus")
                                        .resizable()
                                        .foregroundColor(black)
                                        .frame(width: 35, height: 35)
                                )
                    
                        }
                    }
                }
                Spacer()
            }
        }.onAppear() {
            OPT_Stocks()
        }
    }
}

struct ViewMain : View {
    var body: some View {
    
        TabView {
            
            Tab("Dashboard", systemImage: "house.fill") {
                ContentView2()
            }
            
            Tab("Bill Charts", systemImage: "dollarsign.gauge.chart.leftthird.topthird.rightthird") {
                billChart()
					
            }
			
			Tab("Portfolio", systemImage: "briefcase") {
				Invest_Portfo()
			}
            
            Tab("Acount", systemImage: "person.crop.circle.fill") {
                Account()
            }
        }
        .padding(.top, 20)
        .onAppear() {
            UITabBar.appearance().barTintColor = UIColor(white)
            UITabBar.appearance().backgroundColor = UIColor(white)
            UITabBar.appearance().unselectedItemTintColor = UIColor(black2)	
            UITabBar.appearance().barTintColor = UIColor(white)
        }
    }
}

#Preview {
    ViewMain()
}
