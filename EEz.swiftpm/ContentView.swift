import SwiftUI
import UIKit
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

/// var for func

nonisolated(unsafe) var stream : InputStream!

/// Data For bills (monthly) list

let bills = CryptoHelper.decryptCSVFromString(UserDefaults.standard.string(forKey: "bills_csv") ?? "", key: KeychainHelper.retrieveKey()!) ?? []

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

// MARK: -Adjust to screen size

@MainActor func AdjustToScreenSize() -> Bool {
	let screensize = UIScreen.main.bounds
	
	var size : Bool
	
	if screensize.width <= 1080 {
		size = true
		
	}
	else {
		size = false
	}
	
	return size
	
}

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
						// Here, break down the logic into separate variables to avoid compiler overload
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
						// Fallback for earlier iOS versions
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
		// Extract the year and month from the date (e.g., "2024-12")
		let dateComponents = bill.date.prefix(7) // Get the first 7 characters "YYYY-MM"
		
		// Add the "spent" value to the corresponding month
		spendingByMonth[String(dateComponents), default: 0] += bill.spent
	}
	
	return spendingByMonth
}

// Function to convert date string to Date
func parseDate(_ dateString: String) -> Date? {
	let formatter = DateFormatter()
	formatter.dateFormat = "yyyy-MM-dd" // Ensures correct parsing of "YYYY-MM-DD"
	formatter.locale = Locale(identifier: "en_US_POSIX") // Ensures reliable parsing
	return formatter.date(from: dateString)
}

// Function to sort RecentBillsData by date and spent
func sumBillsByDate(_ bills: [RecentBillsData]) -> [(date: String, totalSpent: Double)] {
	var groupedBills: [String: Double] = [:]

	for bill in bills {
		groupedBills[bill.date, default: 0] += bill.spent
	}

	// Sort the results by date
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
	 var body: some View {
		  ScrollView {
			  VStack {
				  ForEach(get_categories(), id: \.self) { category in

					  
					  RoundedRectangle(cornerRadius: 20)
						  .fill(white)
						  .frame(width: 470, height: 200)
						  .overlay(
							  HStack (spacing: 15) {
								  VStack (spacing: 15){
									  Text("\(category)")
										  .font(.system(size: 30, weight: .bold, design: .default))
									  
									  RoundedRectangle(cornerRadius: 20)
										  .fill(white2)
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
	 }
}

//struct expandedSpentView: View {
//	
//	@State private var budget_monthly = budget_monthlyG
//	@State private var Left = budget_monthlyG-(getMonthlySpending()["2025-03"] ?? 0)
//	@State private var spent = 0.0
//	@State private var investment = sumInvestmentValues(investments: Investment_list)
//	@State private var formattedSpent = formatWithCommas(number: getMonthlySpending()["2025-03"] ?? 0)
//	@State private var formattedleft = formatWithCommas(number: budget_monthlyG-(getMonthlySpending()["2025-03"] ?? 0))
//	
//	var body: some View {
//		VStack (alignment: .leading, spacing: 15) {
//			
//			HStack(spacing: 15) {
//				VStack(alignment: .leading, spacing: 15) {
//					
//					Text("Your Monthly Spending")
//						.font(.system(size: 45, weight: .semibold))
//						.frame(width: 470)
//					Text("Daily Data:")
//						.font(.system(size: 20, weight: .semibold))
//					
//					Graph_line1()
//						.frame(width: 500, height: 200)
//					
//					RoundedRectangle(cornerRadius: 20)
//						.fill(white2)
//						.frame(width: 500, height: 200)
//						.overlay(
//							HStack (spacing: 15) {
//								VStack {
//									Text("This Month \nYou've Spent:")
//										.font(.system(size: 25, weight: .semibold))
//									
//									RoundedRectangle(cornerRadius: 20)
//										.fill(white)
//										.frame(width: 150, height: 60)
//										.overlay(
//											Text("$\(formattedSpent)")
//												.font(.system(size: 25, weight: .semibold))
//										)
//									
//								}
//								
//								Divider().frame(width: 1, height: 130).background(Color.gray)
//									.padding(.horizontal, 20)
//								
//								VStack {
//									Text("You are:")
//											.font(.system(size: 25, weight: .semibold))
//										
//										RoundedRectangle(cornerRadius: 20)
//											.fill(white)
//											.frame(width: 150, height: 60)
//											.overlay(
//												Text("$\(formattedleft)")
//											).font(.system(size: 25, weight: .semibold))
//									
//									if Left > 0 {
//										Text("Under budget").font(.system(size: 25, weight: .semibold))
//									} else {
//										Text("Over budget").font(.system(size: 25, weight: .semibold))
//									}
//								}
//								
//							}
//						)
//				}
//				
//				VStack(spacing: 15) {
//					RoundedRectangle(cornerRadius: 20)
//						.fill(white2)
//						.frame(width: 500, height: 525)
//						
//						.overlay(
//							VStack (alignment: .leading) {
//								Text("Your Bills, Sorted:")
//									.font(.system(size: 40, weight: .semibold))
//									.padding(.top, 36)
//									.padding(.bottom, 20)
//								
//								billsList()
//								
//							}
//						)
//						
//				}
//			}
//			
//		}
//		.onAppear{
//			if spent != spentG {
//				var dif = spentG - spent
//				
//				spent = spent + dif
//				
//				formattedSpent = formatWithCommas(number: spent)
//			}
//		}
//	}
//}

// MARK: -View for list animation

struct AnimatedBillRow: View {
	let index: Int
	let bill: RecentBillsData
	@Binding var appearIndices: Set<Int>

	var body: some View {
		RoundedRectangle(cornerRadius: 40)
			.fill(white2) // Use your custom color `white2`
			.frame(width: 510, height: 57)
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
				.annotation(position: .topTrailing,content: {
					RoundedRectangle(cornerRadius: 20)
						.fill(white2)
						.frame(width: 110, height: 55)
						.overlay(
							Text("AAPL")
								.font(.system(size: 25, weight: .semibold))
						)
						.padding(.bottom, 10)
						.padding(.leading, 95)
				})
				
				
				
			}
		}
			.chartYScale(domain: [150,300]) /// automate the max value
			.padding(.bottom, 10)
			.chartXAxis(.hidden)
		
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
						.fill(white2)
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

//struct ExpandedStocksView: View {
//	 var body: some View {
//		  HStack(spacing: 15) {
//			  RoundedRectangle(cornerRadius: 20)
//				  .fill(white)
//				  .frame(width: 650, height: 500)
//				  .overlay(
//					  VStack (alignment: .leading){
//						  Text("AAPL Stock")
//							  .font(.system(size: 35, weight: .semibold))
//						  Text("Data for the last 3 months (90 days) of 2024")
//							  .font(.system(size: 20))
//							  .padding(.bottom, 30)
//						  
//						  graph_stock()
//						  
//					  }
//				  )
//			  
//			  RoundedRectangle(cornerRadius: 20)
//				  .fill(white)
//				  .frame(width: 360, height: 500)
//				  .overlay(
//					  VStack (alignment: .leading){
//						  HStack {
//							  Text("Stock \nPerformance \nToday")
//								  .font(.system(size: 30, weight: .semibold))
//								  .padding(.leading, 20)
//							  
//							  Divider()
//								  .frame(width: 1, height: 90)
//								  .overlay(divider)
//							  
//							  RoundedRectangle(cornerRadius: 20)
//								  .fill(white2)
//								  .frame(width: 120, height: 60)
//								  .overlay(content: {
//									  Text("\(stockPerf().str)%")
//										  .font(.system(size: 30, weight: .semibold))
//								  })
//							  
//						  }
//						  .padding([.top, .bottom], 20)
//						  
//						  HStack {
//							  Text("Beta (β) \nRisk")
//								  .font(.system(size: 30, weight: .semibold))
//								  .padding(.leading, -30)
//								  .frame(width: 200)
//							  
//							  Divider()
//								  .frame(width: 1, height: 90)
//								  .overlay(divider)
//							  
//							  RoundedRectangle(cornerRadius: 20)
//								  .fill(white2)
//								  .frame(width: 120, height: 60)
//								  .overlay(content: {
//									  Text("1.24")
//										  .font(.system(size: 30, weight: .semibold))
//								  })
//								  .padding(.trailing, 20)
//								  .padding(.leading, 10)
//						  }
//						  .padding(.bottom, 07)
//						  
//						  Text("Recent News")
//							  .font(.system(size: 35, weight: .semibold))
//							  .padding(.leading, 15)
//						  
//						  NewsView()
//						  
//					  }
//				  )
//		  }
//	 }
//}

// MARK: -Dashboard View

@available(iOS 17.0, *)
struct ContentView: View {
	
	/// spending summary graph vars:
	
	@State private var animatedData: [(String, Double, Double)] = []
	
	@State private var first_open1: Bool = false
	
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
	
	@State private var budget_monthly = budget_monthlyG
	@State private var Left = budget_monthlyG-(getMonthlySpending()["2025-03"] ?? 0)
	@State private var spent = 0.0
	@State private var investment = sumInvestmentValues(investments: Investment_list)
	@State private var formattedSpent = formatWithCommas(number: getMonthlySpending()["2025-03"] ?? 0)
	@State private var formattedleft = formatWithCommas(number: budget_monthlyG-(getMonthlySpending()["2025-03"] ?? 0))
	
	/// vars to adjust to screen
	
	@State private var decre1 : CGFloat = 0
	@State private var decre2 : CGFloat = 0
	@State private var decre3 : CGFloat = 0
	@State private var decre4 : CGFloat = 0
	@State private var decre5 : CGFloat = 0
	@State private var decre6 : CGFloat = 0
	@State private var fontdecre1 : CGFloat = 0
	@State private var fontdecre2 : CGFloat = 0
	@State private var posAdj1 : CGFloat = 0
	@State private var posAdj2 : CGFloat = 0
	@State private var posAdj3 : CGFloat = 0
	
	@State private var sizeBool : Bool = AdjustToScreenSize()
	
	/// Vars

	@AppStorage("SavingGoal") var SavingGoal : String = ""
	
	@AppStorage("first_open") var first_open : Bool = true
	
	/// function to animate the graph
	
	@State private var AnimationCurve : UnitCurve = .circularEaseInOut
	
	@State var stocks: [dat] = parseCSVToDatArray("aapl")
	
	@State private var tog1 : Bool = false // spent this month square
	@State private var tog2 : Bool = false // saving goal square
	@State private var tog3 : Bool = false // Stocks page
	
	@State private var appearIndices: Set<Int> = []
	
	var graph_spendingSummary : some View {
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
					.annotation(position: .top, alignment: .leading,content: {
						RoundedRectangle(cornerRadius: 10)
							.fill(white2)
							.frame(width: 150, height: 30)
							.overlay(content: {
								Text("Budget: $1500")
							})
							.padding(.bottom, 10)
					})
					
				}
			}
		}
		.frame(width: 460-decre2, height: 300)
		.chartYScale(domain: [0,1800])
		.onAppear {
			if !first_open1 {
				animateData()
				first_open1 = true
			}
		}
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
					
					ForEach(bills) { bill in
						AnimatedBillRow(index: bills.firstIndex(where: { $0.id == bill.id }) ?? 0, bill: bill, appearIndices: $appearIndices)
					}

				}
			}
			
			
		}
	}
	
	var monthlySpeding : some View {
		RoundedRectangle(cornerRadius: 20)
			.fill(white)
			.opacity(tog2 ? 0 : 1)
			.opacity(tog3 ? 0 : 1)
			.zIndex(1)
			.frame(width: tog1 ? 1100-decre1 : 270-decre2, height: tog1 ? 650 :  250)
			.position(
				x: tog1 ?  UIScreen.main.bounds.width / 2  : 168-posAdj2, /// 168
				y: tog1 ? UIScreen.main.bounds.height / 2 - 50 : 125
			)
			.overlay(
				VStack {
					
					if !tog1 {
						Text("Monthly \nSpending")
							.font(.system(size: 35, weight: .semibold))
							.padding(.top, 20)
							
						RoundedRectangle(cornerRadius: 20)
							.fill(white2)
							.frame(width: 170, height: 80)
							.overlay(
								Text("$\(formattedSpent)")
									.font(.system(size: 30, weight: .semibold))
							)
					} else {

						 expandedSpentView
					}
				}
					.opacity(tog2 ? 0 : 1)
					.opacity(tog3 ? 0 : 1)
					.position(
						x: tog1 ? UIScreen.main.bounds.width / 2  : 168-posAdj2, /// 168
						y: tog1 ? UIScreen.main.bounds.height / 2 - 50 : 125
					)
			)
			.onTapGesture {
				withAnimation (.timingCurve(AnimationCurve, duration: 0.55)) {
					tog1.toggle()
				}
			}
			.animation(.easeInOut, value: tog1)
	}
	
	var savingGoal : some View {
		RoundedRectangle(cornerRadius: 20)
			.fill(white)
			.position(
				x: tog2 ? UIScreen.main.bounds.width / 2 - 15: 80-posAdj1, /// 80
				y: tog2 ? UIScreen.main.bounds.height / 2 - 50 : 125
			)
			.frame(width: tog2 ? 1100-decre1 : 230-decre3, height: tog2 ? 650 :  250) /// 1100, 230
			.opacity(tog1 ? 0 : 1)
			.opacity(tog3 ? 0 : 1)
			.overlay(
				VStack {
					if !tog2 {
						Text("Your Saving Goal")
							.font(.system(size: 35, weight: .semibold))
							.padding(.top, 20)
						
						RoundedRectangle(cornerRadius: 20)
							.fill(white2)
							.frame(width: 150, height: 80)
							.overlay (
								Text("$\(SavingGoal)")
									.font(.system(size: 30, weight: .semibold))
							)
					}
					
				}
					.opacity(tog1 ? 0 : 1)
					.opacity(tog3 ? 0 : 1)
					.position(
						x: tog2 ? UIScreen.main.bounds.width / 2 - 15: 80-posAdj1, /// 80
						y: tog2 ? UIScreen.main.bounds.height / 2 - 50 : 122
					)
				
			)
			.onTapGesture {
				withAnimation (.easeInOut(duration: 0.45)) {
//										tog2.toggle()
				}
			}
	}
	
	var ExpandedStocksView: some View {
		 HStack(spacing: sizeBool ? 10 : 15) {
			 RoundedRectangle(cornerRadius: 20)
				 .fill(white)
				 .frame(width: 650-decre6, height: 500)
				 .overlay(
					 VStack (alignment: .leading){
						 Text("AAPL Stock")
							 .font(.system(size: 35, weight: .semibold))
						 Text("Data for the last 3 months (90 days) of 2024")
							 .font(.system(size: 20))
							 .padding(.bottom, 30)
						 
						 graph_stock()
							 .frame(width:600-decre6, height: 350)
						
					 }
				 )
			 
			 RoundedRectangle(cornerRadius: 20)
				 .fill(white)
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
								 .fill(white2)
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
								 .fill(white2)
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
		 .padding(.leading, sizeBool ? 50 : 0) /// mod
	}
	
	var expandedSpentView: some View {
		VStack (alignment: .leading, spacing: 15) {
			
			HStack(spacing: 15) {
				VStack(alignment: .leading, spacing: 15) {
					
					Text("Your Monthly Spending")
						.font(.system(size: 45-fontdecre2, weight: .semibold)) /// 45
						.frame(width: 470-decre6) /// 470
					Text("Daily Data:")
						.font(.system(size: 20, weight: .semibold))
					
					Graph_line1()
						.frame(width: 500-decre6, height: 200) /// 500
					
					RoundedRectangle(cornerRadius: 20)
						.fill(white2)
						.frame(width: 500-decre6, height: 200) /// 500
						.overlay(
							HStack (spacing: 15) {
								VStack {
									Text("This Month \nYou've Spent:")
										.font(.system(size: 25, weight: .semibold))
									
									RoundedRectangle(cornerRadius: 20)
										.fill(white)
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
											.fill(white)
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
						.fill(white2)
						.frame(width: 500, height: 525)
						
						.overlay(
							VStack (alignment: .leading) {
								Text("Your Bills, Sorted:")
									.font(.system(size: 40, weight: .semibold))
									.padding(.top, 36)
									.padding(.bottom, 20)
								
								billsList()
								
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
	
	var body: some View {
			ScrollView {
				HStack (spacing: sizeBool ? 10 : 15) {
					
					VStack (spacing: sizeBool ? 10 : 15) {
						
						HStack (spacing: sizeBool ? 10 : 15) {
							
							monthlySpeding
							
							savingGoal
						}
						
						HStack (spacing: sizeBool ? 10 : 15) {
							RoundedRectangle(cornerRadius: 20)
								.fill(white2)
								.opacity(tog1 ? 0 : 1)
								.opacity(tog2 ? 0 : 1)
								.opacity(tog3 ? 0 : 1)
								.frame(width: 230-decre3, height: 250)
								.overlay(
									VStack {
										Text("Your Credit Score")
											.font(.system(size: 35, weight: .semibold))
										
										RoundedRectangle(cornerRadius: 20)
											.fill(white)
											.frame(width: 150, height: 80)
											.overlay(
												Text("600")
													.font(.system(size: 30, weight: .semibold))
											)
									}
										.opacity(tog1 ? 0 : 1)
										.opacity(tog2 ? 0 : 1)
										.opacity(tog3 ? 0 : 1)
								)
								.padding(.leading, -15)
							
							
							
							RoundedRectangle(cornerRadius: 20)
								.fill(white2)
								.opacity(tog1 ? 0 : 1)
								.opacity(tog2 ? 0 : 1)
								.position(
									x: tog3 ? UIScreen.main.bounds.width / 2-140 : 135-posAdj3,
									y: tog3 ? UIScreen.main.bounds.height / 2 - 320 : 125
								)
								.frame(width: tog3 ? 1100-decre1 : 270-decre2, height: tog3 ? 650 :  250)
								.overlay(
									VStack (alignment: tog3 ? .leading : .center) {
										Text("Stock Performance")
											.padding(.top, 20)
											.font(.system(size: tog3 ? 50 : 35, weight: .semibold))
											.padding(.bottom, 5)
											.padding(.leading, sizeBool ? 50 : 0)
											.padding(.trailing, sizeBool ? 0 : 40)
										
										/// Stocks Data Graph
										
										if !tog3 {
											RoundedRectangle(cornerRadius: 20)
												.fill(white)
												.frame(width: 240-decre2, height: 120)
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
												.padding(.leading, sizeBool  ? -5 : 0)
										} else {
											
											 ExpandedStocksView
										}
									}
										.opacity(tog1 ? 0 : 1)
										.opacity(tog2 ? 0 : 1)
										.position(
											x: tog3 ? UIScreen.main.bounds.width / 2 - 160: 125, ///
											y: tog3 ? UIScreen.main.bounds.height / 2 - 320 : 125
										)
										.padding(.leading, sizeBool ? 0 : 10)
								)
							
								.onTapGesture {
									withAnimation {
										tog3.toggle()
									}
								}
						}
						
						RoundedRectangle(cornerRadius: 20)
							.fill(white)
							.opacity(tog1 ? 0 : 1)
							.opacity(tog2 ? 0 : 1)
							.opacity(tog3 ? 0 : 1)
							.frame(width: 510-decre4, height: 400)
							.overlay(
								VStack (alignment: .leading) {
									Text("Spending Summary")
										.font(.system(size: 35, weight: .semibold))
										
									graph_spendingSummary
										
								}
									.opacity(tog1 ? 0 : 1)
									.opacity(tog2 ? 0 : 1)
									.opacity(tog3 ? 0 : 1)
							)
							.padding(.leading, sizeBool ? -15 : 0)
							
					}
					
					
					VStack (spacing:  sizeBool ? 10 : 15) {
						RoundedRectangle(cornerRadius: 20)
							.fill(white2)
							.opacity(tog1 ? 0 : 1)
							.opacity(tog2 ? 0 : 1)
							.opacity(tog3 ? 0 : 1)
							.frame(width: 550, height: 300)
							.position(x: 240, y: 150)
							.overlay(
								HStack {
									
									VStack {
										HStack {
											Text("Your Data, Visualized")
												.font(.system(size: 45-fontdecre1, weight: .semibold))
												.padding(.top, 20)
												.padding(.bottom,15)
												.padding(.horizontal, 15)
											
											Spacer()
										}
											
									}
									.padding(.horizontal, 20)
									
									graph_Pie()
										.frame(width: 220-decre2, height: 260)
										.padding(.horizontal, 20)
								}
									.opacity(tog1 ? 0 : 1)
									.opacity(tog2 ? 0 : 1)
									.opacity(tog3 ? 0 : 1)
									.position(x: 240, y: 150)
								
								
								
							)
						
						/// Recent Bills (uncategorized)
						
						RoundedRectangle(cornerRadius: 20)
							.fill(white)
							.opacity(tog1 ? 0 : 1)
							.opacity(tog2 ? 0 : 1)
							.opacity(tog3 ? 0 : 1)
							.frame(width: 550, height: 615)
							.position(x: 240, y: 150)
							.overlay(
								
								VStack {
									
									billsList_
								}
									.opacity(tog1 ? 0 : 1)
									.opacity(tog2 ? 0 : 1)
									.opacity(tog3 ? 0 : 1)
									.position(x: 240, y: 70)
									.frame(height: 615)
									.padding(.top, 300)
							)
						
					}
				}
			}
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
			.onAppear{
				
				if spent != spentG {
					var dif = spentG - spent
					
					spent = spent + dif
					
					formattedSpent = formatWithCommas(number: spent)
				}
				
				let screensize = UIScreen.main.bounds
				
				print("screen size: width: \(screensize.width), height: \(screensize.height)")
				
				if screensize.width == 1080 {
					decre1 = 100
					decre2 = 30
					decre3 = 20
					decre4 = 45
					decre5 = 20
					decre6 = 50
					fontdecre1 = 8
					fontdecre1 = 5
					posAdj1 = 20
					posAdj2 = 18
					posAdj3 = 15
				}else {
					decre1 = 0
					decre2 = 0
					fontdecre1 = 0
				}
				
			}
	}
}

struct tabView: View {
	var body: some View {
		if #available(iOS 18.0, *) {
			TabView {
				Tab("Dashboard", systemImage: "house.fill") {
					ContentView()
				}

				Tab("Portfolio", systemImage: "briefcase") {
					portfolioPage()
				}

				Tab("Account", systemImage: "person.crop.circle.fill") {
					Account()
				}
				 
				Tab("Add Bill", systemImage: "plus") {
					 Add_bill()
				 }
				
			}
			.onAppear() {
				UITabBar.appearance().barTintColor = UIColor(white)
				UITabBar.appearance().backgroundColor = UIColor(white)
				UITabBar.appearance().unselectedItemTintColor = UIColor(black2)
				UITabBar.appearance().barTintColor = UIColor(white)
				}
		} else {
			// Fallback on earlier versions
		}
	}
}
