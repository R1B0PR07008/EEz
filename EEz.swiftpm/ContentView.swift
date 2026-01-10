import SwiftUI
import Charts
import Foundation
import Security
import CryptoKit


/// Maybe Change colors to match tabbar.

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

/// CSV Data for Stocks

struct dat : Identifiable, Decodable, Hashable {
	let id: UUID = UUID()
	let Date: String
	let Open: Double
	let High: Double
	let Low: Double
	let Close: Double
	let Volume: Double
	let Diff: Double
	let isLarger: String
}

/// CSV data for Credit Score history

struct CreditScoreHistory: Identifiable {
	let id = UUID()
	let month: String
	let score: Int
	let change: Int // Change from previous month
}

/// var for func

nonisolated(unsafe) var stream : InputStream!

/// Data For bills (monthly) list

//let bills = CryptoHelper.decryptCSVFromString(UserDefaults.standard.string(forKey: "bills_csv") ?? "", key: KeychainHelper.retrieveKey()!) ?? []

/// data structure for bills (monthly)

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

/// data structure for news

struct source : Identifiable, Codable, Hashable {
	let Id: UUID = UUID()
	let id: String?
	let name: String
}

struct newsDataStructure : Identifiable, Codable, Hashable {
	let id: UUID = UUID()
	let source: String
	let author: String?
	let title: String
	let description: String
	let publishedAt: String
	let content: String
}

/// data structure for bills (monthly)

struct RecentBillsData : Identifiable, Codable, Hashable {
	 let id: UUID = UUID()
	 let spent : Double
	 let date : String
	 let place : String
	 let category: String
}

/// Imported vars


/// formating functions

func formatWithCommas(number: Double) -> String {
	let formatter = NumberFormatter()
	formatter.numberStyle = .decimal // Use the decimal style to add commas
	formatter.groupingSeparator = "," // Set the separator to commas
	formatter.minimumFractionDigits = 0 // Remove decimals if not needed
	formatter.maximumFractionDigits = 2 // Set a limit for decimal places if needed
	
	if let formattedNumber = formatter.string(from: NSNumber(value: number)) {
		return formattedNumber
	}
	
	return "\(number)"
}

func replaceUnderscoresWithSpaces(in string: String) -> String {
	return string.replacingOccurrences(of: "_", with: " ")
}

func budget() -> Double {
	@AppStorage("MonthlyBudget") var monthly_budget : String = "1500"
	
	return monthly_budget.isEmpty ? 1500 : Double(monthly_budget) ?? 1500
}

func sumInvestmentValues(investments: [(String, String, Double, Int, Double, Color, String)]) -> Double {
	var totalValue: Double = 0.0
	
	for investment in investments {
		totalValue += investment.2 // The third element is the value in dollars
	}
	
	return totalValue
}

/// vars

nonisolated(unsafe) var budget_monthlyG : Double = budget()
nonisolated(unsafe) var spentG = getMonthlySpending()["2025-03"] ?? 0
nonisolated(unsafe) var investmentG : Double = sumInvestmentValues(investments: Investment_list)
nonisolated(unsafe) var LeftG : Double = budget_monthlyG-spentG

let formattedSpentG = formatWithCommas(number: spentG)
let formattedleftG = formatWithCommas(number: LeftG)

nonisolated(unsafe) var Credit_Score = 600

/// data for recent bills
 
let news: [newsDataStructure] = []

/// func to create swift data values of bills list

/// data for monthly spending

// function to preload these values is needed!
// month, spent, budget
let monthly_data = [
	("Jan", 1234.0, 1500.0),
	("Feb", 1233.0, 1500.0),
	("Mar", 1332.0, 1500.0),
	("Apr", 1345.0, 1500.0),
	("May", 1467.0, 1500.0),
	("Jun", 1345.0, 1500.0),
	("Jul", 1334.0, 1500.0),
	("Aug", 1444.0, 1500.0),
	("Sep", 1654.0, 1500.0),
	("Oct", 1235.0, 1500.0),
	("Nov", 1145.0, 1500.0),
	("Dec", 1545.0, 1500.0),
		
]

// MARK: -Pie Graph View

/// pie graph view

struct graph_Pie: View {
	
	@State private var investment = investmentG
	@State private var spent = spentG
	@State private var Left = LeftG

	// Pie chart data
	
	@State private var animatedAngles: [Double] = []
	@AppStorage("first_open") var first_open: Bool = true
	@AppStorage("Budget") var budget: String = ""

	var body: some View {
		
		let Budget = [
			("Left", Double(Left), green2),
			("Spent", Double(spent), red),
		]
		
		VStack {
			// Pie Chart
			Chart {
				ForEach(Budget, id: \.0) { category, value, color in
					if #available(iOS 17.0, *) {
						let targetValue = animatedAngles.first(where: { $0 == value }) ?? 0.0
						SectorMark(
							angle: .value("Value", targetValue),
							innerRadius: .ratio(0.75),
							outerRadius: .ratio(1.1),
							angularInset: 3
						)
						.foregroundStyle(color)
						.cornerRadius(30)
						
					} else {
					}
				}
			}
			.onAppear {
				// Initialize animation with zero values
				withAnimation(.easeIn(duration: 0.5)) {
					animatedAngles = Budget.map { _ in 0.0 }
				}
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
					// After a brief delay, set the final animated values
					withAnimation(.easeIn(duration: 1.0)) {
						animatedAngles = Budget.map { $0.1 }
					}
				}
			}
			.padding([Edge.Set.bottom], 20)
			
			// Legend
			HStack {
				ForEach(Budget, id: \.0) { category, _, color in
					HStack {
						Circle()
							.fill(color)
							.frame(width: 10, height: 10)
						Text(category)
							.font(.system(size: 20))
							.foregroundColor(black)
					}
				}
			}
		}
	}
}

// MARK: -Spent this month thingies

func getMonthlySpending() -> [String: Double] {
	var spendingByMonth: [String: Double] = [:]
	
	let bills = CryptoHelper.decryptCSVFromString( UserDefaults.standard.string(forKey: "bills_csv")!, key: KeychainHelper.retrieveKey()!)
	
	for bill in bills ?? [] as! [RecentBillsData] {
		
		let dateComponents = bill.date.prefix(7)
		
		spendingByMonth[String(dateComponents), default: 0] += bill.spent
	}
	
	return spendingByMonth
}

func parseDate(_ dateString: String) -> Date? {
	let formatter = DateFormatter()
	formatter.dateFormat = "yyyy-MM-dd"
	formatter.locale = Locale(identifier: "en_US_POSIX")
	return formatter.date(from: dateString)
}

func sumBillsByDate(_ bills: [RecentBillsData]) -> [(date: String, totalSpent: Double)] {
	var groupedBills: [String: Double] = [:]

	for bill in bills {
		groupedBills[bill.date, default: 0] += bill.spent
	}

	
	return groupedBills.sorted {
		guard let date1 = parseDate($0.key),
			  let date2 = parseDate($1.key) else {
			return false
		}
		return date1 < date2
	}.map { (date: $0.key, totalSpent: $0.value) }
}

struct Graph_line1: View {
	
	@State private var bills__ = sumBillsByDate(CryptoHelper.decryptCSVFromString(UserDefaults.standard.string(forKey: "bills_csv") ?? "", key: KeychainHelper.retrieveKey()!)!)
	
	var body: some View {
		Chart {
			ForEach(bills__, id: \.0) { date, value in
				
				LineMark(
					x: .value("Date", date),
					y: .value("Spent", value)
				)
				.interpolationMethod(.cardinal)
				.foregroundStyle(green)
				
				 AreaMark(
					x: .value("Date", date),
					y: .value("Spent", value)
				)
				.interpolationMethod(.cardinal)
				.foregroundStyle(LinearGradient(colors: [green, green.opacity(0.2)], startPoint: .top, endPoint: .bottom))
				
			}
		}
		.onAppear{
			bills__ = sumBillsByDate(CryptoHelper.decryptCSVFromString(UserDefaults.standard.string(forKey: "bills_csv") ?? "", key: KeychainHelper.retrieveKey()!)!)
			
			print(bills__)
			
		}
	}
}

func getBillsByCategory(category: String) -> [RecentBillsData] {
	let allBills = CryptoHelper.decryptCSVFromString(UserDefaults.standard.string(forKey: "bills_csv")!, key: KeychainHelper.retrieveKey()!)!
	
	print("\n all bills: \n\(allBills)")
	
	return allBills.filter { $0.category == category }
}

func graph_line(category: String) -> some View {
	
	let data = getBillsByCategory(category: category)

	return
		VStack{
			Chart {
				ForEach(data, id: \.id) {item in
					AreaMark(
						x: .value("Month", item.date),
						y: .value("Budget", item.spent+10)
					)
					.interpolationMethod(.cardinal)
					.foregroundStyle(
						LinearGradient (
							gradient: Gradient(colors: [green,green.opacity(0.1)]),
							startPoint: .top,
							endPoint: .bottom
						))
					LineMark(
						x: .value("Month", item.date),
						y: .value("Spent", item.spent)
					)
					.foregroundStyle(red)
					.interpolationMethod(.cardinal)
					
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

struct billsList: View {
	
	@State var bills : [RecentBillsData] = []
	
	func getTotalSpent(Categroy: String!) -> String {
		let catg = Categroy
		
		let vills_data : [RecentBillsData] = bills.filter {$0.category == catg}
		let totalSpent = vills_data.compactMap { $0.spent }.compactMap { Double($0) }.reduce(0, +)
		let formattedTotalSpent = String(format: "%.2f", totalSpent)
		
		return formattedTotalSpent
	}

	func get_categories() -> [String] {
		var cats : [String]
		
		cats = Array(Set(bills.compactMap { $0.category })).sorted()
		
		return cats
	}
	
	 var body: some View {
		  ScrollView {
			  VStack {
				  ForEach(get_categories(), id: \.self) { category in

					  
					  RoundedRectangle(cornerRadius: 20)
						  .tintedGlassShape(color: white)
						  .frame(width: 470, height: 200)
						  .overlay(
							  HStack (spacing: 15) {
								  VStack (spacing: 15){
									  Text("\(category)")
										  .font(.system(size: 30, weight: .bold, design: .default))
									  
									  RoundedRectangle(cornerRadius: 20)
										  .tintedGlassShape(color: white2)
										  .frame(width: 130, height: 60)
										  .overlay(
											  Text("$\(getTotalSpent(Categroy: category))")
												  .font(.system(size: 25, weight: .semibold))
										  )
								  }
								  
								  Divider().frame(width: 1, height: 130).background(Color.gray)
									  .padding(.horizontal, 20)
								  
								  graph_line(category: category)
								  
							  }
						  )
				  }
			  }
		  }
		  .onAppear {
					  bills = CryptoHelper.decryptCSVFromString(UserDefaults.standard.string(forKey: "bills_csv") ?? "", key: KeychainHelper.retrieveKey()!) ?? []
				  }
	 }
}

struct expandedSpentView: View {
	
	let bills: [RecentBillsData]  // Add this parameter
	
	@State private var budget_monthly = budget_monthlyG
	@State private var Left = budget_monthlyG-(getMonthlySpending()["2025-03"] ?? 0)
	@State private var spent = 0.0
	@State private var investment = sumInvestmentValues(investments: Investment_list)
	@State private var formattedSpent = formatWithCommas(number: getMonthlySpending()["2025-03"] ?? 0)
	@State private var formattedleft = formatWithCommas(number: budget_monthlyG-(getMonthlySpending()["2025-03"] ?? 0))
	
	 var body: some View {
		  VStack (alignment: .leading, spacing: 15) {
			  
			  HStack(spacing: 15) {
				  VStack(alignment: .leading, spacing: 15) {
					  
					  Text("Your Monthly Spending")
						  .font(.system(size: 45, weight: .semibold))
						  .frame(width: 470)
					  Text("Daily Data:")
						  .font(.system(size: 20, weight: .semibold))
					  
					  Graph_line1()
						  .frame(width: 500, height: 200)
					  
					  RoundedRectangle(cornerRadius: 20)
						  .tintedGlassShape(color: white2)
						  .frame(width: 500, height: 200)
						  .overlay(
							  HStack (spacing: 15) {
								  VStack {
									  Text("This Month \nYou've Spent:")
										  .font(.system(size: 25, weight: .semibold))
									  
									  RoundedRectangle(cornerRadius: 20)
										  .tintedGlassShape(color: white)
										  .frame(width: 150, height: 60)
										  .overlay(
											  Text("$\(formattedSpent)")
												  .font(.system(size: 25, weight: .semibold))
										  )
									  
								  }
								  
								  Divider().frame(width: 1, height: 130).background(Color.gray)
									  .padding(.horizontal, 20)
								  
								  VStack {
									  Text("You are:")
											  .font(.system(size: 25, weight: .semibold))
										  
										  RoundedRectangle(cornerRadius: 20)
											.tintedGlassShape(color: white)
											  .frame(width: 150, height: 60)
											  .overlay(
												  Text("$\(formattedleft)")
											  ).font(.system(size: 25, weight: .semibold))
									  
									  if Left > 0 {
										  Text("Under budget").font(.system(size: 25, weight: .semibold))
									  } else {
										  Text("Over budget").font(.system(size: 25, weight: .semibold))
									  }
								  }
								  
							  }
						  )
				  }
				  
				  VStack(spacing: 15) {
					  RoundedRectangle(cornerRadius: 20)
						  .tintedGlassShape(color: white2)
						  .frame(width: 500, height: 525)
						  
						  .overlay(
							  VStack (alignment: .leading) {
								  Text("Your Bills, Sorted:")
									  .font(.system(size: 40, weight: .semibold))
									  .padding(.top, 36)
									  .padding(.bottom, 20)
								  
								  billsList(bills: bills)  // Pass bills here
								  
							  }
						  )
						  
				  }
			  }
			  
		  }
		  .onAppear{
			  if spent != spentG {
				  var dif = spentG - spent
				  
				  spent = spent + dif
				  
				  formattedSpent = formatWithCommas(number: spent)
			  }
		  }
	 }
}

// MARK: -View for list animation

struct AnimatedBillRow: View {
	let index: Int
	let bill: RecentBillsData
	@Binding var appearIndices: Set<Int>

	var body: some View {
		RoundedRectangle(cornerRadius: 40)
			.tintedGlassShape(color: white2)
			.frame(width: 510, height: 60)
			.overlay(
				billContent
			)
			.opacity(appearIndices.contains(index) ? 1 : 0) // Control opacity based on the state
			.offset(y: appearIndices.contains(index) ? 0 : 30) // Slide-in effect
			.animation(.easeIn(duration: 0.5).delay(Double(index) * 0.2), value: appearIndices) // Gradual appearance with delay
			.onAppear {
				withAnimation {
					_ = appearIndices.insert(index)
				}
			}
	}

	// Extract the content of the bill row into a computed property
	var billContent: some View {
		HStack {
			Text("$\(bill.spent, specifier: "%.2f")") // Convert Double to formatted string
				.foregroundColor(black)
				.frame(width: 160)
				.font(.system(size: 22, weight: .semibold))

			Divider().frame(width: 1, height: 25).background(Color.gray)

			Text("\(bill.date)") // Date is already a string
				.foregroundColor(black)
				.frame(width: 160)
				.font(.system(size: 22, weight: .semibold))

			Divider().frame(width: 1, height: 25).background(Color.gray)

			Text("\(bill.place)") // Place is already a string
				.foregroundColor(black)
				.frame(width: 160)
				.font(.system(size: 22, weight: .semibold))
		}
	}
}

// MARK: -Stocks stuff


struct graph_stock: View {
	
	@State var stocks: [dat] = parseCSVToDatArray("aapl")
	
	@Environment(\.colorScheme) var colorScheme  // Add this line
	
	var body: some View {
		
		let topXvalues = Array(stocks.prefix(90))


		Chart {
			ForEach(topXvalues, id: \.self) {item in
				
				let condition: Bool = item.isLarger == "0"
				
				LineMark(
					x: .value("Date", item.Date),
					y: .value("Close Price", item.Close)
				)
				.interpolationMethod(.cardinal)
				.foregroundStyle(condition ? red : green)
				
			}
		}.frame(width: 600, height: 350)
			.chartYScale(domain: [150,300]) /// automate the max value
			.padding(.bottom, 10)
			.chartXAxis(.hidden)
			.overlay(alignment: .topTrailing) {  // Use overlay instead of annotation
				Text("AAPL")
					.font(.system(size: 22, weight: .semibold))
					.foregroundColor(.primary)
					.padding(.horizontal, 16)
					.padding(.vertical, 8)
					.background(
						RoundedRectangle(cornerRadius: 15)
							.fill(.thinMaterial)
							.overlay(
								RoundedRectangle(cornerRadius: 15)
									.fill(
										colorScheme == .dark
											? Color.black.opacity(0.2)
											: Color.white.opacity(0.3)
									)
							)
							.overlay(
								RoundedRectangle(cornerRadius: 15)
									.stroke(Color.white.opacity(0.3), lineWidth: 1)
							)
							.shadow(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 2)
					)
					.padding(12)  // Padding from chart edge
			}
		
	}
}

func stockPerf() -> (str: String, double: Double) {
	
	let top1 = Array(parseCSVToDatArray("aapl"))
	
	let stockPerf = top1[1].Diff
	
	let formated = String(format: "%.2f", stockPerf)
	
	return (str: formated, double: stockPerf)
}

struct stockPerfView: View {
	var body: some View {
		if Int(stockPerf().double) > 0 {
			Text("Up \(stockPerf().str)% \nfrom yesturday")
				.font(.system(size: 18,weight: .semibold))
		}
		else {
			Text("Down \(stockPerf().str)% \nfrom yesturday" )
				.font(.system(size: 18,weight: .semibold))
		}
	}
}

struct NewsView: View {
	
	var body: some View {
		
		let newsData : [newsDataStructure] = Array(loadNewsFromCSVString())
		
		ScrollView {
			VStack () {
				ForEach(newsData, id: \.self) { news in
					
					RoundedRectangle(cornerRadius: 20)
						.tintedGlassShape(color: white2)
						.frame(minWidth: 330, idealWidth: 330, maxWidth: 330, minHeight: 120, idealHeight: 160, maxHeight: 200)
						.padding(.horizontal, 15)
						.overlay(
							VStack (alignment: .leading) {
								
								let title = news.title
								
								Text("\(title)")
									.font(.system(size: 20, weight: .semibold))
								Text("Source: \(news.source)")
									.font(.system(size: 20))
									
								
							}
								.frame(width: 310)
								.padding(20)
						)
					
				}
			}
		}
	}
}

struct ExpandedStocksView: View {
	 var body: some View {
		  HStack(spacing: 15) {
			  RoundedRectangle(cornerRadius: 20)
				  .tintedGlassShape(color: white)
				  .frame(width: 650, height: 500)
				  .overlay(
					  VStack (alignment: .leading){
						  Text("AAPL Stock")
							  .font(.system(size: 35, weight: .semibold))
						  Text("Data for the last 3 months (90 days) of 2024")
							  .font(.system(size: 20))
							  .padding(.bottom, 30)
						  
						  graph_stock()
						  
					  }
				  )
			  
			  RoundedRectangle(cornerRadius: 20)
				  .tintedGlassShape(color: white)
				  .frame(width: 360, height: 500)
				  .overlay(
					  VStack (alignment: .leading){
						  HStack {
							  Text("Stock \nPerformance \nToday")
								  .font(.system(size: 30, weight: .semibold))
								  .padding(.leading, 20)
							  
							  Divider()
								  .frame(width: 1, height: 90)
								  .overlay(divider)
							  
							  RoundedRectangle(cornerRadius: 20)
								  .tintedGlassShape(color: white2)
								  .frame(width: 120, height: 60)
								  .overlay(content: {
									  Text("\(stockPerf().str)%")
										  .font(.system(size: 30, weight: .semibold))
								  })
							  
						  }
						  .padding([.top, .bottom], 20)
						  
						  HStack {
							  Text("Beta (β) \nRisk")
								  .font(.system(size: 30, weight: .semibold))
								  .padding(.leading, -30)
								  .frame(width: 200)
							  
							  Divider()
								  .frame(width: 1, height: 90)
								  .overlay(divider)
							  
							  RoundedRectangle(cornerRadius: 20)
								  .tintedGlassShape(color: white2)
								  .frame(width: 120, height: 60)
								  .overlay(content: {
									  Text("1.24")
										  .font(.system(size: 30, weight: .semibold))
								  })
								  .padding(.trailing, 20)
								  .padding(.leading, 10)
						  }
						  .padding(.bottom, 07)
						  
						  Text("Recent News")
							  .font(.system(size: 35, weight: .semibold))
							  .padding(.leading, 15)
						  
						  NewsView()
						  
					  }
				  )
		  }
	 }
}


// MARK: -Speding Summary stuff

struct graph_spendingSummary: View {
	
	@State private var animatedData: [(String, Double, Double)] = []
	
	@State private var first_open: Bool = false
	
	@Environment(\.colorScheme) var colorScheme
	
	private func animateData() {
			for (index, dataPoint) in monthly_data.enumerated() {
				DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.2) {
					withAnimation(.easeOut(duration: 0.5)) {
						animatedData.append((dataPoint.0, dataPoint.1, dataPoint.2))
				}
			}
		}
	}
	
	@State private var line_width = 2
	
	var body : some View {
		Chart {
			ForEach(animatedData, id: \.0) { month, spent, budget in
				Plot {
					BarMark(
						x: .value("month", month),
						yStart: .value("start", 0),
						yEnd: .value("spent", spent)
					)
					.foregroundStyle(
						LinearGradient(colors: [green, accent.opacity(0.4)], startPoint: .top, endPoint: .bottom)
					)
					.cornerRadius(5)
					
					RuleMark(
						y: .value("budget", budget)
					)
					.lineStyle(StrokeStyle(lineWidth: CGFloat(line_width)))
					.foregroundStyle(red)
					.annotation(position: .top, alignment: .leading, content: {
						Text("Budget: $1500")
							.font(.system(size: 14, weight: .medium))
							.foregroundColor(.primary)
							.padding(.horizontal, 12)
							.padding(.vertical, 6)
							.background(
								RoundedRectangle(cornerRadius: 10)
									.fill(.regularMaterial)
									.overlay(
										RoundedRectangle(cornerRadius: 10)
											.fill(
												colorScheme == .dark
													? Color.black.opacity(0.3)  // Dark overlay in dark mode
												: Color.white.opacity(0.95)   // White overlay in light mode
											)
									)
									.overlay(
										RoundedRectangle(cornerRadius: 10)
											.stroke(Color.white.opacity(0.02), lineWidth: 1)
									)
							)
							.padding(.bottom, 10)
					})
					
				}
			}
		}
		.frame(width: 460, height: 300)
		.chartYScale(domain: [0,1800])
		.onAppear {
			if !first_open {
				animateData()
				first_open = true
			}
		}
	}
}

// MARK: -Extension for glass effect

extension Shape {
	func tintedGlassShape(color: Color = .green) -> some View {
		TintedGlassShapeView(shape: self, color: color)
	}
}

struct TintedGlassShapeView<S: Shape>: View {
	let shape: S
	let color: Color
	@Environment(\.colorScheme) var colorScheme  // Detects dark mode
	
	var body: some View {
		shape
			.fill(.ultraThinMaterial)
			.overlay(
				shape.fill(
					LinearGradient(
						colors: colorScheme == .dark ? [
							// Dark mode - more subtle tint
							color.opacity(0.20),
							color.opacity(0.10)
						] : [
							// Light mode - original tint
							color.opacity(0.10),
							color.opacity(0.05)
						],
						startPoint: .topLeading,
						endPoint: .bottomTrailing
					)
				)
			)
			.shadow(
				color: colorScheme == .dark
					? Color.white.opacity(0.05)  // Subtle light shadow in dark mode
					: Color.black.opacity(0.1),   // Dark shadow in light mode
				radius: 8,
				x: 0,
				y: 4
			)
			.overlay(
				shape.stroke(
					colorScheme == .dark
						? Color.white.opacity(0.15)  // Dimmer border in dark mode
						: Color.white.opacity(0.3),  // Brighter border in light mode
					lineWidth: 1.5
				)
			)
	}
}

// MARK: -Expanded Credit score

struct CreditScoreLineGraph: View {

	let creditData: [CreditScoreHistory]

	var body: some View {
		Chart {
			ForEach(creditData) { entry in

				LineMark(
					x: .value("Month", entry.month),
					y: .value("Credit Score", entry.score)
				)
				.interpolationMethod(.cardinal)
				.foregroundStyle(green)

				AreaMark(
					x: .value("Month", entry.month),
					yStart: .value("Base", 300),
					yEnd: .value("Credit Score", entry.score)
				)
				.interpolationMethod(.cardinal)
				.foregroundStyle(
					LinearGradient(
						colors: [green.opacity(0.5), green.opacity(0.15)],
						startPoint: .top,
						endPoint: .bottom
					)
				)
			}
		}
		.chartYScale(domain: 300...850)
		.chartYAxis {
			AxisMarks(position: .leading)
		}
		.frame(height: 250)
	}
}

struct CreditScoreRangeRowCompact: View {
	let range: String
	let label: String
	let color: Color
	
	var body: some View {
		HStack {
			RoundedRectangle(cornerRadius: 8)
				.fill(color)
				.frame(width: 75, height: 28)
				.overlay(
					Text(range)
						.font(.system(size: 13, weight: .bold))
						.foregroundColor(.white)
				)
			
			Text(label)
				.font(.system(size: 15, weight: .semibold))
				.foregroundColor(black)
			
			Spacer()
		}
	}
}

struct CreditFactorRowCompact: View {
	let percentage: String
	let title: String
	
	var body: some View {
		HStack(spacing: 10) {
			Text(percentage)
				.font(.system(size: 18, weight: .bold))
				.foregroundColor(green)
				.frame(width: 45, alignment: .leading)
			
			Text(title)
				.font(.system(size: 15, weight: .semibold))
				.foregroundColor(black)
			
			Spacer()
		}
	}
}

struct ExpandedCreditScore: View {
	var body: some View {
		HStack (spacing: 15) {
			
			VStack {
			
				Text("Your Credit Score History")
					.font(.system(size: 30, weight: .semibold))
					.padding(.bottom, 30)
					.padding(.top, 10)
				
				CreditScoreLineGraph(creditData: (try? creditHelper.decryptCreditScoreHistory()) ?? [])
					.frame(width: 450)
					.padding(.bottom, 10)
				
				HStack (spacing: 15) {
					RoundedRectangle(cornerRadius: 20)
						.tintedGlassShape(color: white2)
						.frame(width: 220, height: 240)
						.overlay {
							VStack {
								
								Text("Score Ranges")
									.font(.system(size: 25, weight: .semibold))
									.padding(.bottom, 10)
								
								VStack(spacing: 6) {
									CreditScoreRangeRowCompact(range: "800-850", label: "Exceptional", color: green)
									CreditScoreRangeRowCompact(range: "740-799", label: "Very Good", color: green.opacity(0.7))
									CreditScoreRangeRowCompact(range: "670-739", label: "Good", color: orange.opacity(0.7))
									CreditScoreRangeRowCompact(range: "580-669", label: "Fair", color: orange)
									CreditScoreRangeRowCompact(range: "300-579", label: "Poor", color: red)
								}
								.padding(.leading, 10)
								.padding(.bottom, 10)
							}
							.padding(15)
						}
					
					RoundedRectangle(cornerRadius: 20)
						.tintedGlassShape(color: white2)
						.frame(width: 260, height: 240)
						.overlay {
							VStack {
								
								Text("How it's Calculated")
									.font(.system(size: 25, weight: .semibold))
									.padding(.bottom, 10)
								
								Spacer()
								
								VStack(spacing: 6) {
									CreditFactorRowCompact(percentage: "35%", title: "Payment History")
										.padding(.bottom, 7)
									CreditFactorRowCompact(percentage: "30%", title: "Credit Utilization")
										.padding(.bottom, 7)
									CreditFactorRowCompact(percentage: "15%", title: "Length of History")
										.padding(.bottom, 7)
									CreditFactorRowCompact(percentage: "10%", title: "Credit Mix")
										.padding(.bottom, 7)
									CreditFactorRowCompact(percentage: "10%", title: "New Credit")
								}
								.padding(.leading, 20)
								.padding(.bottom, 10)
							}
							.padding(15)
						}
				}
			}
			
			
			VStack (spacing: 15) {
				RoundedRectangle(cornerRadius: 20)
					.tintedGlassShape(color: white2)
					.frame(width: 500, height: 213)
					.overlay {
						VStack (alignment: .leading) {
							Text("What is a Credit Score?")
								.font(.system(size: 30, weight: .semibold))
								.padding(.bottom, 10)
							
							
							
							Text("Credit Score is a three-digit number (300-850) that represents your creditworthiness - how likely you are to repay borrowed money. Lenders, landlords, and employers use it to evaluate your financial responsibility.")
								.font(.system(size: 18, weight: .semibold))
							
							
						}
						.padding(20)
					}
				
				RoundedRectangle(cornerRadius: 20)
					.tintedGlassShape(color: white2)
					.frame(width: 500, height: 363)
					.overlay{
						VStack (alignment: .leading) {
							Text("How do you Build a Credit Score?")
								.font(.system(size: 30, weight: .semibold))
								.padding(.bottom, 10)
							
							build_list(
								num: "1",
								message: "Get a Credit Card.",
								message2: "Start with a secured or student card."
							)
							
							build_list(
								num: "2",
								message: "Always Pay on Time.",
								message2: "Set up automatic payments."
							)
							
							build_list(
								num: "3",
								message: "Monitor Your Credit.",
								message2: "Check for errors before they get big."
							)
							
							build_list(
								num: "4",
								message: "Keep Balances Low",
								message2: "Try to use less than 30% of your credit card's limit."
							)
							
							build_list(
								num: "5",
								message: "Be an Authorized User",
								message2: "Your parents can make you an Authorized user in their\n credit cards to build your credit."
							)
						}
						.padding(20)
					}
			}
		}
	}
}
		
struct build_list: View {
	let num: String
	let message: String
	let message2: String
	
	var body: some View {
		HStack {
			Circle()
				.tintedGlassShape(color: white)
				.frame(width: 40, height: 40)
				.overlay(
					Text(num)
					.font(.system(size: 20, weight: .semibold))
				)
			VStack(alignment: .leading) {
				Text(message)
					.font(.system(size: 20, weight: .semibold))
				Text(message2)
					.font(.system(size: 15, weight: .semibold))
			}
		}
	}
	
}

// MARK: -Dashboard View

@available(iOS 17.0, *)
struct ContentView: View {
	
	@State private var budget_monthly = budget_monthlyG
	@State private var Left = budget_monthlyG-(getMonthlySpending()["2025-03"] ?? 0)
	@State private var spent = 0.0
	@State private var investment = sumInvestmentValues(investments: Investment_list)
	@State private var formattedSpent = formatWithCommas(number: getMonthlySpending()["2025-03"] ?? 0)
	@State private var formattedleft = formatWithCommas(number: budget_monthlyG-(getMonthlySpending()["2025-03"] ?? 0))
	
	/// for light-dark mode detector
	
	@Environment(\.colorScheme) var colorScheme
	
	/// Vars
	
	@AppStorage("SavingGoal") var SavingGoal : String = ""
	
	@AppStorage("first_open") var first_open : Bool = true
	
	@AppStorage("appTour") var appTour : Bool = true
	
	/// function to animate the graph
	
	@State private var AnimationCurve : UnitCurve = .circularEaseInOut
	
	@State var stocks: [dat] = parseCSVToDatArray("aapl")
	
	@State private var tog1 : Bool = false // spent this month square
	@State private var tog2 : Bool = false // saving goal square
	@State private var tog3 : Bool = false // Stocks page
	
	@State private var appearIndices: Set<Int> = []
	
	// billsList Vars/funcs
	
	@State var bills : [RecentBillsData] = []
	@AppStorage("billsRefreshTrigger") private var billsRefreshTrigger = 0
	
	func getTotalSpent(Categroy: String!) -> String {
		let catg = Categroy
		
		let vills_data : [RecentBillsData] = bills.filter {$0.category == catg}
		let totalSpent = vills_data.compactMap { $0.spent }.compactMap { Double($0) }.reduce(0, +)
		let formattedTotalSpent = String(format: "%.2f", totalSpent)
		
		return formattedTotalSpent
	}
	
	func get_categories() -> [String] {
		var cats : [String]
		
		cats = Array(Set(bills.compactMap { $0.category })).sorted()
		
		return cats
	}
	
	private func loadBills() {
		bills = CryptoHelper.decryptCSVFromString(
			UserDefaults.standard.string(forKey: "bills_csv") ?? "",
			key: KeychainHelper.retrieveKey()!
		) ?? []
		
		// Recalculate spending values
		spentG = getMonthlySpending()["2025-03"] ?? 0
		LeftG = budget_monthlyG - spentG
		
		// Update formatted strings
		spent = spentG
		formattedSpent = formatWithCommas(number: spentG)
		formattedleft = formatWithCommas(number: LeftG)
		Left = LeftG
	}
	
	var billsList_: some View {
		
		VStack {
			HStack {
				Text("Recent Bills")
					.font(.system(size: 35, weight: .semibold))
					.padding(.leading, 40)
					.padding(.top, 30)
				
				Spacer()
			}
			
			HStack() {
				
				VStack {
					Text("Spent")
						.foregroundColor(black)
						.font(.system(size: 22, weight: .semibold))
						.frame(width: 160)
				}
				
				
				Divider().frame(width: 1).overlay(divider)
				
				
				VStack {
					Text("Date")
						.foregroundColor(black)
						.font(.system(size: 22, weight: .semibold))
						.frame(width: 160)
				}
				
				
				Divider().frame(width: 1).overlay(divider)
				
				
				VStack {
					Text("Place")
						.foregroundColor(black)
						.font(.system(size: 22, weight: .semibold))
						.frame(width: 160)
				}
				
				
			}
			.padding()
			.padding(.bottom, 0)
			.frame(width: 350, height: 60)
			
			ScrollView {
				VStack {
					
					ForEach(bills.sorted(by: { $0.date > $1.date })) { bill in
						AnimatedBillRow(index: bills.sorted(by: { $0.date > $1.date }).firstIndex(where: { $0.id == bill.id }) ?? 0, bill: bill, appearIndices: $appearIndices)
							.transition(.asymmetric(
								insertion: .move(edge: .top).combined(with: .opacity),
								removal: .opacity
							))
					}
					
				}
				.animation(.spring(response: 0.6, dampingFraction: 0.8), value: bills.count)
			}
			.onAppear {
				bills = CryptoHelper.decryptCSVFromString(UserDefaults.standard.string(forKey: "bills_csv") ?? "", key: KeychainHelper.retrieveKey()!) ?? []
			}
			
			
		}
	}
	
	var body: some View {
		ZStack {
			
			LinearGradient(
				colors: colorScheme == .dark ? [
					green2.opacity(0.4),      // Use your existing colors!
					Color.black,
					green.opacity(0.3),
					green2.opacity(0.2)
				] : [
					green.opacity(0.4),                    // Your app's green
					green2.opacity(0.2),
					Color.white,
					green.opacity(0.5),
					green2.opacity(0.5)
				],
				startPoint: .topLeading,
				endPoint: .bottomTrailing
			)
			.edgesIgnoringSafeArea(.all)
			
			ScrollView {
				ScrollViewReader { proxy in
					HStack (spacing: 15) {
						
						VStack (spacing: 15) {
							
							HStack (spacing: 15) {
								
								RoundedRectangle(cornerRadius: 20)
									.tintedGlassShape(color: white)
									.opacity(tog2 ? 0 : 1)
									.opacity(tog3 ? 0 : 1)
									.zIndex(1)
									.frame(
										width: (tog3 || tog2) ? 0 : tog1 ? 1100 : 270,
										height: (tog3 || tog2) ? 0 : tog1 ? 650 : 250
									)
									.overlay(
										VStack {
											
											if !tog1 {
												VStack {
													HStack {
														Text("Monthly \nSpending")
															.font(.system(size: 35, weight: .semibold))
															.padding(.top, 20)
															.padding(.leading, 20)
														
														Spacer()
														
														Image(systemName: "arrow.down.left.and.arrow.up.right.circle")
															.resizable()
															.frame(width: 25, height: 25)
															.padding(.trailing, 15)
															.padding(.top, -40)
													}
													
													Spacer()
													
													RoundedRectangle(cornerRadius: 20)
														.tintedGlassShape(color: white2)
														.frame(width: 170, height: 80)
														.overlay(
															Text("$\(formattedSpent)")
																.font(.system(size: 30, weight: .semibold))
														)
														.padding(.bottom, 20)
												}
											} else {
												
												expandedSpentView(bills: bills)
												
											}
										}
										
											.opacity(tog2 ? 0 : 1)
											.opacity(tog3 ? 0 : 1)
									)
									.onTapGesture {
										withAnimation (.timingCurve(AnimationCurve, duration: 0.55)) {
											tog1.toggle()
											if tog1 {
												proxy.scrollTo("top", anchor: .top)
											}
										}
									}
									.padding(.leading, tog1 ? 25 : 0)
									.animation(.easeInOut, value: tog1)
								
								
								
								RoundedRectangle(cornerRadius: 20)
									.tintedGlassShape(color: white)
									.frame(width: (tog1 || tog3 || tog2) ? 0 : 230, height: (tog1 || tog3 || tog2) ? 0 : 250)
									.opacity(tog1 ? 0 : 1)
									.opacity(tog3 ? 0 : 1)
									.overlay(
										VStack {
											if !tog2 {
												Text("Your Saving Goal")
													.font(.system(size: 35, weight: .semibold))
													.padding(.top, 20)
												
												RoundedRectangle(cornerRadius: 20)
													.tintedGlassShape(color: white2)
													.frame(width: 150, height: 80)
													.overlay (
														Text("$\(SavingGoal)")
															.font(.system(size: 30, weight: .semibold))
													)
											}
											
										}
											.opacity(tog1 ? 0 : 1)
											.opacity(tog3 ? 0 : 1)
										
									)
									.onTapGesture {
										withAnimation (.easeInOut(duration: 0.45)) {
											//										tog2.toggle()
										}
									}
							}
							.id("top")
							
							HStack (spacing: 15) {
								RoundedRectangle(cornerRadius: 20)
									.tintedGlassShape(color: white2)
									.opacity(tog1 ? 0 : 1)
									.opacity(tog3 ? 0 : 1)
									.frame(
										width: tog2 ? 1100 : (tog1 || tog3) ? 0 : 230,
										height: tog2 ? 650 : (tog1 || tog3) ? 0 : 250
									)
									.overlay(
										VStack {
											if !tog2 {
												VStack {
													HStack {
														Text("Credit \nScore")
															.font(.system(size: 35, weight: .semibold))
														
														Image(systemName: "arrow.down.left.and.arrow.up.right.circle")
															.resizable()
															.frame(width: 25, height: 25)
															.padding(.leading, 60)
															.padding(.top, -60)
															.opacity(tog1 ? 0 : 1)
															.opacity(tog3 ? 0 : 1)
															.opacity(tog2 ? 0 : 1)
													}
													
													RoundedRectangle(cornerRadius: 20)
														.tintedGlassShape(color: white)
														.frame(width: 150, height: 80)
														.overlay(
															Text("600")
																.font(.system(size: 30, weight: .semibold))
														)
												}
													.opacity(tog1 ? 0 : 1)
													.opacity(tog3 ? 0 : 1)
											}
											else {
												ExpandedCreditScore()
											}
										}
									)
									.onTapGesture {
										withAnimation (.timingCurve(AnimationCurve, duration: 0.55)) {
											tog2.toggle()
											if tog2 {
												proxy.scrollTo("top", anchor: .top)
											}
										}
									}
									.padding(.leading, tog2 ? 25 : 0)
									.animation(.easeInOut, value: tog1)
								
								
								
								RoundedRectangle(cornerRadius: 20)
									.tintedGlassShape(color: white2)
									.opacity(tog1 ? 0 : 1)
									.opacity(tog2 ? 0 : 1)
									.frame(
										width:  (tog1 || tog2) ? 0 : tog3 ? 1100 : 270,
										height: (tog1 || tog2) ? 0 : tog3 ? 650 : 250
									)
									.overlay(
										VStack (alignment: tog3 ? .leading : .center) {
											HStack {
												Text("Stock Performance")
													.padding(.top, 20)
													.font(.system(size: tog3 ? 50 : 35, weight: .semibold))
													.padding(.bottom, 5)
													.padding(.leading, 10)
												
												
												Image(systemName: "arrow.down.left.and.arrow.up.right.circle")
													.resizable()
													.frame(width: 25, height: 25)
													.padding(.trailing, 10)
													.padding(.top, -40)
													.opacity(tog1 ? 0 : 1)
													.opacity(tog3 ? 0 : 1)
													.opacity(tog2 ? 0 : 1)
											}
											
											/// Stocks Data Graph
											
											if !tog3 {
												RoundedRectangle(cornerRadius: 20)
													.tintedGlassShape(color: white)
													.frame(width: 240, height: 120)
													.frame(width: (tog1 || tog3 || tog2) ? 0 : 240, height: (tog1 || tog3 || tog2) ? 0 : 120)
													.padding(.bottom, 10)
													.overlay(
														HStack (spacing: 10) {
															Text("AAPL")
																.font(.system(size: 23, weight: .semibold))
															
															Divider()
																.frame(width: 1, height: 90)
																.overlay(divider)
															
															stockPerfView()
														}
															.padding(.bottom, 10)
														
													)
											} else {
												
												ExpandedStocksView()
											}
										}
											.opacity(tog1 ? 0 : 1)
											.opacity(tog2 ? 0 : 1)
									)
									.onTapGesture {
										withAnimation {
											tog3.toggle()
											if tog3 {
												proxy.scrollTo("top", anchor: .top)
											}
										}
									}
							}
							
							RoundedRectangle(cornerRadius: 20)
								.tintedGlassShape(color: white)
								.opacity(tog1 ? 0 : 1)
								.opacity(tog2 ? 0 : 1)
								.opacity(tog3 ? 0 : 1)
								.frame(width: 515, height: 400)
								.frame(width: (tog1 || tog3 || tog2) ? 0 : 515, height: (tog1 || tog3 || tog2) ? 0 : 400)
								.overlay(
									VStack (alignment: .leading) {
										Text("Spending Summary")
											.font(.system(size: 35, weight: .semibold))
										
										graph_spendingSummary()
										
									}
										.opacity(tog1 ? 0 : 1)
										.opacity(tog2 ? 0 : 1)
										.opacity(tog3 ? 0 : 1)
								)
							
						}
						
						
						VStack (spacing: 15) {
							RoundedRectangle(cornerRadius: 20)
								.tintedGlassShape(color: white2)
								.opacity(tog1 ? 0 : 1)
								.opacity(tog2 ? 0 : 1)
								.opacity(tog3 ? 0 : 1)
								.frame(width: 550, height: 300)
								.frame(width: (tog1 || tog3 || tog2) ? 0 : 550, height: (tog1 || tog3 || tog2) ? 0 : 300)
								.overlay(
									HStack {
										
										VStack {
											HStack {
												Text("Your Data, Visualized")
													.font(.system(size: 45, weight: .semibold))
												//													.padding(.top, 20)
													.padding(.bottom,15)
													.padding(.horizontal, 15)
													.frame(width: 240)
												
												
											}
											
										}
										.padding(.horizontal, 20)
										
										graph_Pie()
											.frame(width: 240, height: 260)
											.padding(.horizontal, 20)
									}
										.opacity(tog1 ? 0 : 1)
										.opacity(tog2 ? 0 : 1)
										.opacity(tog3 ? 0 : 1)
									
									
									
									
								)
							
							/// Recent Bills (uncategorized)
							
							RoundedRectangle(cornerRadius: 20)
								.tintedGlassShape(color: white)
								.opacity(tog1 ? 0 : 1)
								.opacity(tog2 ? 0 : 1)
								.opacity(tog3 ? 0 : 1)
								.frame(width: 550, height: 615)
								.frame(width: (tog1 || tog3 || tog2) ? 0 : 550, height: (tog1 || tog3 || tog2) ? 0 : 615)
								.overlay(
									
									VStack {
										
										billsList_
									}
										.opacity(tog1 ? 0 : 1)
										.opacity(tog2 ? 0 : 1)
										.opacity(tog3 ? 0 : 1)
									
										.frame(height: 615)
									
								)
							
						}
						.id("bottom")
					}
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.onChange(of: st5) { _, newValue in
							guard newValue else { return }
							withAnimation {
								proxy.scrollTo("bottom", anchor: .bottom)
							}
						}
						.onChange(of: st4) { _, newValue in
							guard newValue else { return }
							withAnimation {
								proxy.scrollTo("top", anchor: .top)
							}
						}
						.onChange(of: st7) { _, newValue in
							withAnimation {
								if newValue == true {
									proxy.scrollTo("top", anchor: .top)
								} else if st8 != true {
									proxy.scrollTo("bottom", anchor: .bottom)
								}
							}
						}
					
				}
			}
			.scrollContentBackground(.hidden) // THIS IS THE KEY LINE!
			.background(Color.clear)
			.scrollDisabled(tog1)
			.scrollDisabled(tog2)
			.scrollDisabled(tog3)
			.onTapGesture(perform: {
				
				withAnimation{
					if tog1 {
						tog1.toggle()
					}
					else if tog2 {
						tog2.toggle()
					}
					else if tog3 {
						tog3.toggle()
					}
				}
			})
			.onAppear {
				// Load bills initially
				loadBills()
				
				if spent != spentG {
					var dif = spentG - spent
					
					spent = spent + dif
					
					formattedSpent = formatWithCommas(number: spent)
				}
				  
			}
			.onChange(of: billsRefreshTrigger) { _, _ in
				// Reload bills whenever trigger changes
				loadBills()
			}
			
			if appTour == true {
				app_tour.opacity(1)
			}
			else if appTour == false {
				withAnimation {
					app_tour.opacity(0)
				}
			}
			
		}
	}
	
	/// App tour code
	
	@State private var sharedPosition = ScrollPosition()
	
	@AppStorage("selectedTab") private var selectedTab: Int = 0
	
	/// Code for app tour
	
	@AppStorage("st1") var st1 : Bool = true
	@AppStorage("st2") var st2 : Bool = false
	@AppStorage("st3") var st3 : Bool = false
	@AppStorage("st4") var st4 : Bool = false
	@AppStorage("st5") var st5 : Bool = false
	@AppStorage("st6") var st6 : Bool = false
	@AppStorage("st7") var st7 : Bool = false
	@AppStorage("st8") var st8 : Bool = false
	
	var app_tour: some View {
		ScrollView {
			ScrollViewReader { proxy in
				ZStack {
					
					HStack (spacing: 15) {
						
						VStack (spacing: 15) {
							
							HStack (spacing: 15) {
								
								RoundedRectangle(cornerRadius: 20)
									.fill(st1 ? Color.clear : (colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7)))
									.zIndex(1)
									.frame(
										width: 270,
										height: 250
									)
								
								
								RoundedRectangle(cornerRadius: 20)
									.fill(st2 ? Color.clear : (colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7)))
									.frame(width: 230, height: 250)
								
							}
							.id("top")
							
							HStack (spacing: 15) {
								RoundedRectangle(cornerRadius: 20)
									.fill(st3 ? Color.clear : (colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7)))
									.frame(width: 230, height: 250)
								
								
								
								
								RoundedRectangle(cornerRadius: 20)
									.fill(st4 ? Color.clear : (colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7)))
									.frame(
										width: 270,
										height: 250
									)
								
							}
							
							RoundedRectangle(cornerRadius: 20)
								.fill(st5 ? Color.clear : (colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7)))
								.frame(width: 515, height: 400)
							
							
						}
						
						
						VStack (spacing: 15) {
							RoundedRectangle(cornerRadius: 20)
								.fill(st7 ? Color.clear : (colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7)))
								.frame(width: 550, height: 300)
							
							
							/// Recent Bills (uncategorized)
							
							RoundedRectangle(cornerRadius: 20)
								.fill(st6 ? Color.clear : (colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7)))
								.frame(width: 550, height: 615)
							
							
						}
						.id("bottom")
					}
					.frame(maxWidth: .infinity, maxHeight: .infinity)
					
					/// st1 explanation
					VStack {
						RoundedRectangle(cornerRadius: 20)
							.tintedGlassShape(color: white)
							.opacity(st1 ? 1 : 0)
							.frame(width: 350, height: 250)
							.overlay(
								VStack {
									Text("By clicking on this page, you can view all you expences for the month sorted by category. There are also graphs that show you, in a graphic—easier to understand—way, how much you spend in each category and in each day of the month.")
									
									HStack{
										Spacer()
										
										Button(action: {
											withAnimation{
												st1 = false
												st2 = true
											}
										}, label: {
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
												.frame(width: 100, height: 40)
												.overlay(
													HStack {
														
														Text("Next")
														Image(systemName: "arrow.forward")
													}
												)
										})
										.padding(10)
									}
									
								}
									.padding(10)
									.opacity(st1 ? 1 : 0)
							)
							.padding(.bottom, 670)
							.padding(.trailing, 150)
						
						
						
					}
					
					/// st2 explanation
					VStack {
						RoundedRectangle(cornerRadius: 20)
							.tintedGlassShape(color: white)
							.opacity(st2 ? 1 : 0)
							.frame(width: 350, height: 160)
							.overlay(
								VStack {
									Text("Part of managing your money responsably, is learning how to save. Here you can set a saving goal.")
									
									HStack {
										
										Button(action: {
											withAnimation{
												st1 = true
												st2 = false
											}
										}, label: {
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
												.frame(width: 110, height: 40)
												.overlay(
													HStack {
														Image(systemName: "arrow.backward")
														Text("Previous")
													}
												)
										})
										.padding(10)
										
										Spacer()
										
										Button(action: {
											withAnimation{
												st2 = false
												st3 = true
											}
										}, label: {
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
												.frame(width: 100, height: 40)
												.overlay(
													HStack {
														
														Text("Next")
														Image(systemName: "arrow.forward")
													}
												)
										})
										.padding(10)
									}
									
								}
									.padding(10)
									.opacity(st2 ? 1 : 0)
							)
							.padding(.bottom, 700)
							.padding(.trailing, -350)
						
						
						
					}
					
					/// st3 explanation
					VStack {
						RoundedRectangle(cornerRadius: 20)
							.tintedGlassShape(color: white)
							.opacity(st3 ? 1 : 0)
							.frame(width: 350, height: 160)
							.overlay(
								VStack {
									Text("Here you can view your credit score. You can also get an explanation of how it works by clicking it.")
									
									HStack {
										
										Button(action: {
											withAnimation{
												st2 = true
												st3 = false
											}
										}, label: {
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
												.frame(width: 110, height: 40)
												.overlay(
													HStack {
														Image(systemName: "arrow.backward")
														Text("Previous")
													}
												)
										})
										.padding(10)
										
										Spacer()
										
										Button(action: {
											withAnimation{
												st3 = false
												st4 = true
											}
										}, label: {
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
												.frame(width: 100, height: 40)
												.overlay(
													HStack {
														
														Text("Next")
														Image(systemName: "arrow.forward")
													}
												)
										})
										.padding(10)
									}
									
								}
									.padding(10)
									.opacity(st3 ? 1 : 0)
							)
							.padding(.bottom, 150)
							.padding(.trailing, 200)
						
						
						
					}
					
					/// st4 explanation
					VStack {
						RoundedRectangle(cornerRadius: 20)
							.tintedGlassShape(color: white)
							.opacity(st4 ? 1 : 0)
							.frame(width: 350, height: 200)
							.overlay(
								VStack {
									Text("By clicking this, you can view your stock investments. It shows you a line graph for the stock price of t your stock over time, shows you risk factors, and recent news that may affect your stocks's price.")
									
									HStack {
										
										Button(action: {
											withAnimation{
												st3 = true
												st4 = false
											}
										}, label: {
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
												.frame(width: 110, height: 40)
												.overlay(
													HStack {
														Image(systemName: "arrow.backward")
														Text("Previous")
													}
												)
										})
										.padding(10)
										
										Spacer()
										
										Button(action: {
											withAnimation{
												st4 = false
												st5 = true
												proxy.scrollTo("bottom", anchor: .bottom)
											}
										}, label: {
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
												.frame(width: 100, height: 40)
												.overlay(
													HStack {
														
														Text("Next")
														Image(systemName: "arrow.forward")
													}
												)
										})
										.padding(10)
									}
									
								}
									.padding(10)
									.opacity(st4 ? 1 : 0)
							)
							.padding(.bottom, 150)
							.padding(.trailing, -350)
						
						
						
					}
					
					/// st5 explanation
					VStack {
						RoundedRectangle(cornerRadius: 20)
							.tintedGlassShape(color: white)
							.opacity(st5 ? 1 : 0)
							.frame(width: 350, height: 260)
							.overlay(
								VStack {
									Text("This graph allows you to see you monthly expences in a graphic, and thus easier to understand, way. This helps people seeif they are spending too much instead of just seeing a number. The red line alows you to see where your budget is set and whether you met it or not and by how much.")
									
									HStack {
										
										Button(action: {
											withAnimation{
												st4 = true
												st5 = false
												proxy.scrollTo("top", anchor: .top)
											}
										}, label: {
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
												.frame(width: 110, height: 40)
												.overlay(
													HStack {
														Image(systemName: "arrow.backward")
														Text("Previous")
													}
												)
										})
										.padding(10)
										
										Spacer()
										
										Button(action: {
											withAnimation{
												st5 = false
												st6 = true
												proxy.scrollTo("bottom", anchor: .bottom)
											}
										}, label: {
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
												.frame(width: 100, height: 40)
												.overlay(
													HStack {
														
														Text("Next")
														Image(systemName: "arrow.forward")
													}
												)
										})
										.padding(10)
									}
									
								}
									.padding(10)
									.opacity(st5 ? 1 : 0)
							)
							.padding(.bottom, -350)
							.padding(.trailing, -350)
						
						
						
					}
					
					/// st6 explanation
					VStack {
						RoundedRectangle(cornerRadius: 20)
							.tintedGlassShape(color: white)
							.opacity(st6 ? 1 : 0)
							.frame(width: 350, height: 230)
							.overlay(
								VStack {
									Text("Here you can see all your bills for the month in a list, sorted from newest to oldest. Can also see when, where,a and how much you spent. This is automatically synced up with the spending summary and monthly spending pages.")
									
									HStack {
										
										Button(action: {
											withAnimation{
												st5 = true
												st6 = false
												proxy.scrollTo("bottom", anchor: .bottom)
											}
										}, label: {
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
												.frame(width: 110, height: 40)
												.overlay(
													HStack {
														Image(systemName: "arrow.backward")
														Text("Previous")
													}
												)
										})
										.padding(10)
										
										Spacer()
										
										Button(action: {
											withAnimation{
												st6 = false
												st7 = true
												proxy.scrollTo("top", anchor: .top)
											}
										}, label: {
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
												.frame(width: 100, height: 40)
												.overlay(
													HStack {
														
														Text("Next")
														Image(systemName: "arrow.forward")
													}
												)
										})
										.padding(10)
									}
									
								}
									.padding(10)
									.opacity(st6 ? 1 : 0)
							)
							.padding(.bottom, -350)
							.padding(.trailing, 400)
						
						
						
					}
					
					/// st7 explanation
					VStack {
						RoundedRectangle(cornerRadius: 20)
							.tintedGlassShape(color: white)
							.opacity(st7 ? 1 : 0)
							.frame(width: 350, height: 190)
							.overlay(
								VStack {
									Text("This pie graph shows you in a visual way how much of your monthly budget you've spent and how much you have left.")
									
									HStack {
										
										Button(action: {
											withAnimation{
												st6 = true
												st7 = false
												proxy.scrollTo("bottom", anchor: .bottom)
											}
										}, label: {
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
												.frame(width: 110, height: 40)
												.overlay(
													HStack {
														Image(systemName: "arrow.backward")
														Text("Previous")
													}
												)
										})
										.padding(10)
										
										Spacer()
										
										Button(action: {
											withAnimation{
												st7 = false
												st8 = true
											}
										}, label: {
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
												.frame(width: 100, height: 40)
												.overlay(
													HStack {
														
														Text("Next")
														Image(systemName: "arrow.forward")
													}
												)
										})
										.padding(10)
									}
									
								}
									.padding(10)
									.opacity(st7 ? 1 : 0)
							)
							.padding(.bottom, 670)
							.padding(.trailing, 400)
						
						
						
					}
					
				}
			}
		}
		.scrollDisabled(true)
	}
}

struct tabView: View {
	@State private var showAddBill = false
	@Environment(\.colorScheme) var colorScheme
	@AppStorage("selectedTab") private var selectedTab: Int = 0
	@AppStorage("appTour") var appTour : Bool = true
	
	@AppStorage("st1") var st1 : Bool = true
	@AppStorage("st2") var st2 : Bool = false
	@AppStorage("st3") var st3 : Bool = false
	@AppStorage("st4") var st4 : Bool = false
	@AppStorage("st5") var st5 : Bool = false
	@AppStorage("st6") var st6 : Bool = false
	@AppStorage("st7") var st7 : Bool = false
	@AppStorage("st8") var st8 : Bool = false
	@AppStorage("st9") var st9 : Bool = false
	@AppStorage("st10") var st10 : Bool = false
	@AppStorage("st11") var st11 : Bool = false
	@AppStorage("st12") var st12 : Bool = false
	@AppStorage("st13") var st13 : Bool = false
	@AppStorage("st14") var st14 : Bool = false
	
	var body: some View {
		HStack {
			if #available(iOS 18.0, *) {
				ZStack {
					TabView (selection: $selectedTab) {
						ContentView()
							.tabItem { Label("Dashboard", systemImage: "house.fill") }
							.tag(0)
						
						portfolioPage()
							.tabItem { Label("Portfolio", systemImage: "briefcase") }
							.tag(1)
						
						Account()
							.tabItem { Label("Account", systemImage: "person.crop.circle.fill") }
							.tag(2)
					}
					
					// Floating Add Bill button
					VStack {
						HStack {
							Spacer()
							Button {
								withAnimation(.easeInOut(duration: 0.3)) {
									showAddBill = true
								}
							} label: {
								Image(systemName: "plus")
									.font(.system(size: 20, weight: .bold))
									.foregroundStyle(colorScheme == .dark ? .white : .black)  // Adaptive color
									.padding(10)
									.background {
										if colorScheme == .dark {
											Circle().tintedGlassShape(color: white)
										} else {
											Circle()
												.fill(.white.opacity(0.6))
												.shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
										}
									}
							}
							.padding(.trailing, 370)
							.padding(.top, 2.5)
						}
						
						Spacer()
						
					}
					
					// Add Bill overlay - appears on top
					if showAddBill {
						Color.black.opacity(0.4)
							.ignoresSafeArea()
							.onTapGesture {
								withAnimation(.easeInOut(duration: 0.3)) {
									showAddBill = false
								}
							}
						
						Add_bill()
							.transition(.scale.combined(with: .opacity))
					}
					
					/// app tour
					
					VStack {
						HStack {
							Circle()
								.fill(st8 ? Color.clear : (colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7)))
								.frame(width: 40, height: 40)
								.padding(.bottom, 725)
								.padding(.leading, 398)
						}
						
					}
					.opacity(appTour  ? 1 : 0)
					
					VStack {
						RoundedRectangle(cornerRadius: 20)
							.fill(colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7))
							.frame(width: 350, height: 50)
							.padding(.bottom, 720)
					}
					.opacity(appTour  ? 1 : 0)
					
					/// st8 explanation
					VStack {
						RoundedRectangle(cornerRadius: 20)
							.tintedGlassShape(color: white)
							.opacity(st8 ? 1 : 0)
							.frame(width: 350, height: 190)
							.overlay(
								VStack {
									Text("By clicking here you can add any bill by simply giving it 4 bits of information: Price, Date, Place, Category.")
									
									HStack {
										
										Button(action: {
											withAnimation{
												st7 = true
												st8 = false
											}
										}, label: {
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
												.frame(width: 110, height: 40)
												.overlay(
													HStack {
														Image(systemName: "arrow.backward")
														Text("Previous")
													}
												)
										})
										.padding(10)
										
										Spacer()
										
										Button(action: {
											withAnimation{
												st8 = false
												selectedTab = 1
												st9 = true
											}
										}, label: {
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
												.frame(width: 100, height: 40)
												.overlay(
													HStack {
														
														Text("Next")
														Image(systemName: "arrow.forward")
													}
												)
										})
										.padding(10)
									}
									
								}
									.padding(10)
									.opacity(st8 ? 1 : 0)
							)
							.padding(.bottom, 470)
							.padding(.leading, 400)
						
						
						
						
					}
					.opacity(appTour  ? (st8 ? 1 : 0) : 0)
					
					/// st14 welcome
					VStack {
						RoundedRectangle(cornerRadius: 20)
							.tintedGlassShape(color: white)
							.opacity(st14 ? 1 : 0)
							.frame(width: 550, height: 650)
							.overlay(
								VStack {
									
									if let logo = UIImage(named: "Logo") {
										Image(uiImage: logo)
											.resizable() // Allow resizing
											.frame(width: 230, height: 230) // Set size
											.clipShape(RoundedRectangle(cornerRadius: 16)) // Optional: Add styling
											.padding(.top, 150)
									}
									
									Text("Welcome to EEz!")
										.font(.system(size: 40, weight: .bold))
										
									Spacer()
									
									HStack {
										
										Button(action: {
											withAnimation{
												st13 = true
												st14 = false
												selectedTab = 2
											}
										}, label: {
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
												.frame(width: 110, height: 40)
												.overlay(
													HStack {
														Image(systemName: "arrow.backward")
														Text("Previous")
													}
												)
										})
										.padding(10)
										
										Spacer()
										
										Button(action: {
											withAnimation{
												st14 = false
												appTour =  false
											}
										}, label: {
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
												.frame(width: 250, height: 40)
												.overlay(
													HStack {
														
														Text("Finish, for real this time.")
														Image(systemName: "arrow.forward")
													}
												)
										})
										.padding(10)
									}
									
								}
									.padding(10)
									.opacity(st14 ? 1 : 0)
							)
						
						
						
						
					}
					.opacity(appTour  ? 1 : 0)
					
				}
			}
		}
		.onAppear{
			selectedTab = 0
			
			st1 = true
			st2 = false
			st3 = false
			st4 = false
			st5 = false
			st6 = false
			st7 = false
			st8 = false
			st9 = false
			st10 = false
			st11 = false
			st12 = false
			st13 = false
			st14 = false
			
			print(st1, st2, st3, st4, st5, st6, st7, st8, st9, st10, st11, st12, st13, st14, "App Tour: ", appTour)
		}
	}
}
