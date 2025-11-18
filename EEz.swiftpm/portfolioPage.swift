//
//  SwiftUIView.swift
//  EEz
//
//  Created by Riboldi  on 26/01/25.
//

import SwiftUI
import Charts

let Investment_list = [ /// Name, Category, Value ($), Performance, Beta risk, Color
	("AAPL", "Stock", 15000.0, 10, 1.24,green, ""),
	("Beach House", "Real State", 150000.0, -9999999, -9999999, purple, ""),
	("Accenture", "Stock", 10000.0, -3, 1.25, red, ""),
	("IBM", "Stock", 9000.0, 20, 0.71, orange, "")
]

nonisolated(unsafe) var stocks_aapl: [dat] = parseCSVToDatArray("aapl")
nonisolated(unsafe) var stocks_acn: [dat] = parseCSVToDatArray("acn")
nonisolated(unsafe) var stocks_ibm: [dat] = parseCSVToDatArray("ibm")

nonisolated(unsafe) var tog4: Bool = false

struct stocksList : Identifiable, Hashable {
	let id: UUID = UUID()
	let ticker: String
	let data: [dat]
	let risk: Double
	let perf: Double
}

let stocks_list : [stocksList] = [ /// ticker, data, beta risk, perf
	stocksList(ticker: "AAPL", data: stocks_aapl, risk: 1.24, perf: 10),
	stocksList(ticker: "ACN", data: stocks_acn,risk: 1.25, perf: -3),
	stocksList(ticker: "IBM", data: stocks_ibm, risk: 0.71,perf: 20)
]

let sortedByPerfMIN = Investment_list.sorted { $0.3 < $1.3 }

let sortedByPerfMAX = Investment_list.sorted { $1.3 < $0.3 }

let sortedByValfMAX = Investment_list.sorted { $1.2 < $0.2 }

let sortedByValfMIN = Investment_list.sorted { $0.2 < $1.2 }

struct graph_Pie_InP: View {
	
	@State private var animatedValues: [Double] = []
	
	private func animateChart() {
			animatedValues = Array(repeating: 0, count: Investment_list.count)

			DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
				withAnimation(.easeInOut(duration: 0.8)) {
					animatedValues = Investment_list.map { Double($0.2) } /// Animate to actual values
				}
			}
		}
	
	var body: some View {
		HStack {
			VStack (alignment: .leading) {
				
				Text("Your Investments, \nVisualized")
					.font(.system(size: 30, weight: .semibold))
				
				Chart {
					ForEach(Array(Investment_list.enumerated()), id: \.0) { index, data in
						if #available(iOS 17.0, *) {
							SectorMark(
								angle: .value("Value", animatedValues.indices.contains(index) ? animatedValues[index] : 0),
										innerRadius: .ratio(0.7),
										outerRadius: .ratio(1.0),
										angularInset: 5
							)
								.foregroundStyle(data.5)
								.cornerRadius(10)
							}
						}
					}
					.padding(.trailing, 20)
					.onAppear {
						animateChart()
					}
			}
				
			
			RoundedRectangle(cornerRadius: 20)
				.fill(white2)
				.frame(width: 200, height: 455)
				.overlay(
					VStack (alignment: .leading) {
						ForEach(Investment_list, id: \.0) { name, _, _, _, _, color, _ in
							HStack {
								Circle()
									.fill(color)
									.frame(width: 20, height: 20)
								Text(name)
									.font(.system(size: 23))
									.foregroundColor(black)
							}
						}
						.padding(.top, 10)
						
						Spacer()
					}

				)
		}
	}
}

struct investment_list_view: View {
	
	@State private var showItems = false // Controls the animation
	
	var body: some View {
		ForEach(Array(Investment_list.enumerated()), id: \.element.0) { index, investment in
				  let (name, category, value, perf, risk, _, _) = investment
			
				let formattedValue = formatWithCommas(number: value)
			
				  RoundedRectangle(cornerRadius: 20)
					  .fill(white)
					  .frame(width: 460, height: 160)
					  .overlay(
						  HStack {
							  VStack {
								  Text(name)
									  .font(.system(size: 30, weight: .semibold))
								  
								  Text(category)
									  .font(.system(size: 20, weight: .semibold))
							  }
							  .frame(width: 150)
							  
							  Divider().frame(width: 1, height: 100).background(Color.gray)
								  .padding(.horizontal, 20)
							  
							  VStack {
								  Text("Value: $\(formattedValue)")
									  .font(.system(size: 30, weight: .semibold))
								  
								  if perf != -9999999 {
									  Text("Performance: \(perf)")
										  .font(.system(size: 20, weight: .semibold))
								  } else {
									  Text("Performance: N/A")
										  .font(.system(size: 20, weight: .semibold))
								  }
							  }
							  .frame(width: 210)
						  }
					  )
					  .padding(.bottom, 2)
					  .opacity(showItems ? 1 : 0) // Start invisible
					  .offset(y: showItems ? 0 : 20) // Start lower
					  .animation(.easeOut(duration: 0.5).delay(Double(index) * 0.2), value: showItems) // Delay each item
			  }
		
		Spacer()
			.frame(height: 120)
		
		  .onAppear {
			  showItems = true // Triggers the animation when the view appears
		  }
		  .onDisappear {
			  showItems = false
		  }
	}
}





// MARK: -Stocks Perf Stuff
//@available(iOS 17.0, *)
//struct stocks_perf_view: View {
//
//	@State var tog4: Bool = false
//
//	var graph: some View {
//		ScrollView (.horizontal) {
//			LazyHStack {
//				ForEach(stocks_list, id: \.self) { item in
//
//					let formated_perf = String(format: "%.1f", item.perf)
//
//					let formated_risk = String(format: "%.2f", item.risk)
//
//					let maxCloseP = item.data.max(by: { $0.Close < $1.Close })?.Close ?? 0
//
//					RoundedRectangle(cornerRadius: 20)
//						.fill(white)
//						.frame(width: tog4 ? 1100 : 500 , height: tog4 ? 660 : 130)
//						.position(
//							x: tog4 ?  UIScreen.main.bounds.width / 2  : 250,
//							y: tog4 ? UIScreen.main.bounds.height / 2 - 50 : 75
//						)
//						.zIndex(1)
//						.overlay(
//							HStack {
//								VStack (alignment: .leading) {
//
//									Text("\(item.ticker) (last 3 months of 2024)")
//									Chart() {
//										let topXvalues = Array(item.data.prefix(90))
//
//										ForEach(topXvalues, id: \.self) {item in
//
//
//											let condition: Bool = item.isLarger == "0"
//
//											LineMark(
//												x: .value("Date", item.Date),
//												y: .value("Close Price", item.Close)
//											)
//											.foregroundStyle(condition ? red : green)
//											.interpolationMethod(.cardinal)
//
//										}
//
//									}.frame(width: 230, height: 70)
//										.chartYScale(domain: [maxCloseP - 100, maxCloseP + 100]) /// automate the max value
//										.padding(.bottom, 10)
//										.chartXAxis(.hidden)
//								}
//								.frame(width: 230)
//
//								Divider().frame(width: 1, height: 90).background(Color.gray)
//									.padding(.horizontal, 20)
//
//								VStack (alignment: .leading) {
//									Text("Performance: \(formated_perf)%")
//										.font(.system(size: 20, weight: .semibold))
//										.padding(.bottom, 10)
//
//									Text("Beta Risk: \(formated_risk)")
//										.font(.system(size: 20, weight: .semibold))
//								}
//							}
//						)
//						.onTapGesture {
//							withAnimation {
//								tog4.toggle()
//								print(tog4)
//							}
//							print("QWERTYUIOPAGHJKL:ZXCVBNM")
//						}
//				}
//			}
//			.scrollTargetLayout()
//		}
//		.scrollTargetBehavior(.viewAligned)
//		.safeAreaPadding(.horizontal, 25)
//	}
//}

@available(iOS 17.0, *)
struct portfolioPage: View {
	
	@State private var tog4: Bool = false
	
	var body: some View {
		ZStack {
			ScrollView {
				VStack (spacing: 15) {
					HStack (spacing: 15) {
						RoundedRectangle(cornerRadius: 20)
							.fill(white)
							.frame(width: 600, height: 500)
							.overlay(
								graph_Pie_InP()
									.frame(width: 550, height: 450)
									.opacity(tog4 ? 0 : 1)
							)
							.opacity(tog4 ? 0 : 1)
						
//						RoundedRectangle(cornerRadius: 20)
//							.fill(white2)
//							.frame(width: 500, height: 500)
//							.opacity(tog4 ? 0 : 1)
//							.overlay(
//								ScrollView {
//									VStack {
//										investment_list_view()
//									}
//								}
//									.padding(.top, 20)
//									.opacity(tog4 ? 0 : 1)
//							)
						
						RoundedRectangle(cornerRadius: 20)
							.fill(white2)
							.frame(width: 500, height: 500)
							.opacity(tog4 ? 0 : 1)
							.overlay(
								ZStack {
									ScrollView {
										VStack {
											investment_list_view()
										}
										.padding(.top, 20)
										.opacity(tog4 ? 0 : 1)
									}
									
									// Fade overlay at the bottom of the parent RoundedRectangle
									VStack {
										Spacer()
										LinearGradient(
											gradient: Gradient(stops: [
												.init(color: .clear, location: 0),
												.init(color: white2, location: 1)  // Matches the rectangle fill color
											]),
											startPoint: .top,
											endPoint: .bottom
										)
										.frame(height: 130)
										.allowsHitTesting(false)
									}
								}
								.clipShape(RoundedRectangle(cornerRadius: 20))  // Clips the entire overlay to rounded corners
							)
						
						///

						
					}
					
					HStack (spacing: 15) {
							RoundedRectangle(cornerRadius: 20)
								.fill(white2)
								.frame(width: tog4 ? 1200 : 520, height: tog4 ? 900 : 200)
//								.position(
//									x: tog4 ?  UIScreen.main.bounds.width / 2 - 000  : 295,
//									y: tog4 ? UIScreen.main.bounds.height / 2 - 500 : 100
//								)
								.opacity(tog4 ? 0 : 1)
								.overlay(
									VStack (alignment: .leading) {
										Text("Stocks Performance Summary")
											.font(.system(size: 30, weight: .semibold))
											.padding(.leading, 25)
											.padding(.bottom, -15)
											.padding(.top, 10)
											.opacity(tog4 ? 0 : 1)
										
										stocks_perf_view
//											.zIndex(tog4 ? 3 : 1)
									}
										.padding(.leading, -15)
//										.position(
//											x: tog4 ?  UIScreen.main.bounds.width / 2  : 315,
//											y: tog4 ? UIScreen.main.bounds.height / 2 - 50 : 100
//										)
									
									
								)
								
								
							
							HStack (spacing: 15) {
								RoundedRectangle(cornerRadius: 20)
									.fill(white)
									.frame(width: 287.5, height: 200)
//									.position(x: 115, y: 100)
									.opacity(tog4 ? 0 : 1)
									
									.overlay(
										VStack {
											Text("Best Performing Investment")
												.font(.system(size: 25, weight: .semibold))
												.padding(.leading, -20)
											
											RoundedRectangle(cornerRadius: 20)
												.fill(white2)
												.frame(width: 230, height: 80)
												.overlay(
													HStack {
														Text("\(sortedByPerfMAX[0].0)")
															.font(.system(size: 25, weight: .semibold))
															.frame(width: 100)
														
														Divider().frame(width: 1, height: 40).background(Color.gray)
														
														Text(sortedByPerfMAX[0].3 > 0 ? "+\(sortedByPerfMAX[0].3)%" : "\(sortedByPerfMAX[0].3)%")
															.font(.system(size: 25, weight: .semibold))
															.frame(width: 70)
														
													}
												)
											
										}
											.opacity(tog4 ? 0 : 1)
											.position(x: 140,y: 100)
									)
								
								RoundedRectangle(cornerRadius: 20)
									.fill(white)
									.frame(width: 279, height: 200)
//									.position(x: 110,y: 100)
									.opacity(tog4 ? 0 : 1)
									.overlay(
										VStack {
											Text("Worst Performing Investment")
												.font(.system(size: 25, weight: .semibold))
											
											RoundedRectangle(cornerRadius: 20)
												.fill(white2)
												.frame(width: 220, height: 80)
												.overlay(
													HStack {
														Text("\(sortedByPerfMIN[1].0)")
															.font(.system(size: 25, weight: .semibold))
															.frame(idealWidth: 100)
														
														Divider().frame(width: 1, height: 40).background(Color.gray)
														
														Text(sortedByPerfMIN[1].3 > 0 ? "+\(sortedByPerfMIN[1].3)%" : "\(sortedByPerfMIN[1].3)%")
															.font(.system(size: 25, weight: .semibold))
															.frame(width: 70)
														
													}
												)
											
										}
											.opacity(tog4 ? 0 : 1)
											.position(x: 140,y: 100)
									)
							}
					}
				}
			}
		}
	}
	
	var stocks_perf_view: some View {
		ScrollView (.horizontal) {
			LazyHStack {
				ForEach(stocks_list, id: \.self) { item in
					
					let formated_perf = String(format: "%.1f", item.perf)
					
					let formated_risk = String(format: "%.2f", item.risk)
					
					let maxCloseP = item.data.max(by: { $0.Close < $1.Close })?.Close ?? 0
					
					RoundedRectangle(cornerRadius: 20)
						.fill(white)
						.frame(width: tog4 ? 1100 : 500 , height: tog4 ? 660 : 130)
//						.position(
//							x: tog4 ?  UIScreen.main.bounds.width / 2 - 100 : 250,
//							y: tog4 ? UIScreen.main.bounds.height / 2 - 500 : 75
//						)
//						.zIndex(1)
						.overlay(
							HStack {
								VStack (alignment: .leading) {
									
									Text("\(item.ticker) (last 3 months of 2024)")
									Chart() {
										let topXvalues = Array(item.data.prefix(90))
										
										ForEach(topXvalues, id: \.self) {item in
											
											
											let condition: Bool = item.isLarger == "0"
											
											LineMark(
												x: .value("Date", item.Date),
												y: .value("Close Price", item.Close)
											)
											.foregroundStyle(condition ? red : green)
											.interpolationMethod(.cardinal)
											
										}
										
									}.frame(width: 230, height: 70)
										.chartYScale(domain: [maxCloseP - 100, maxCloseP + 100]) /// automate the max value
										.padding(.bottom, 10)
										.chartXAxis(.hidden)
								}
								.frame(width: 230)
								
								Divider().frame(width: 1, height: 90).background(Color.gray)
									.padding(.horizontal, 20)
								
								VStack (alignment: .leading) {
									Text("Performance: \(formated_perf)%")
										.font(.system(size: 20, weight: .semibold))
										.padding(.bottom, 10)
									
									Text("Beta Risk: \(formated_risk)")
										.font(.system(size: 20, weight: .semibold))
								}
							}
//								.position(
//									x: tog4 ?  UIScreen.main.bounds.width / 2  : 250,
//									y: tog4 ? UIScreen.main.bounds.height / 2 - 500 : 75
//								)
						)
						.onTapGesture {
							withAnimation {
//								tog4.toggle()
								print(tog4)
							}
							print("QWERTYUIOPAGHJKL:ZXCVBNM")
						}
				}
			}
			.scrollTargetLayout()
		}
		.scrollTargetBehavior(.viewAligned)
		.safeAreaPadding(.horizontal, 25)
	}
	
}

@available(iOS 17.0, *)
#Preview {
	portfolioPage()
}
