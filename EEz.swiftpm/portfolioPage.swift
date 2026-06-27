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
				.tintedGlassShape(color: white2)
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
					.tintedGlassShape(color: white)
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

@available(iOS 17.0, *)
struct portfolioPage: View {
	
	@State private var tog4: Bool = false
	
	/// for light-dark mode detector
	
	@Environment(\.colorScheme) var colorScheme
	
	/// for app tour
	
	@AppStorage("st8") var st8 : Bool = false
	@AppStorage("st9") var st9 : Bool = false
	@AppStorage("st10") var st10 : Bool = false
	@AppStorage("st11") var st11 : Bool = false
	@AppStorage("st12") var st12 : Bool = false
	@AppStorage("st13") var st13 : Bool = false
	
	@AppStorage("appTour") var appTour : Bool = true
	
	@AppStorage("selectedTab") private var selectedTab: Int = 0
	
	
	var body: some View {
		ZStack {
			
			LinearGradient(
				colors: colorScheme == .dark ? [
						green2.opacity(0.4),      // Use your existing colors!
						Color.black,
						green.opacity(0.3),
						green2.opacity(0.2)
					] : [
						green.opacity(0.6),
						green2.opacity(0.2),
						Color.white,
						green.opacity(0.5),
						green2.opacity(0.6)
					],
							startPoint: .topLeading,
							endPoint: .bottomTrailing
						)
						.edgesIgnoringSafeArea(.all)
			
			ScrollView {
				VStack (spacing: 15) {
					HStack (spacing: 15) {
						RoundedRectangle(cornerRadius: 20)
							.tintedGlassShape(color: white)
							.frame(width: 600, height: 500)
							.overlay(
								graph_Pie_InP()
									.frame(width: 550, height: 450)
									.opacity(tog4 ? 0 : 1)
							)
							.opacity(tog4 ? 0 : 1)
						
						RoundedRectangle(cornerRadius: 20)
							.tintedGlassShape(color: white2)
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
												.init(color: white2.opacity(0.5), location: 1)  // Matches the rectangle fill color
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
							.tintedGlassShape(color: white2)
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
									.tintedGlassShape(color: white)
									.frame(width: 287.5, height: 200)
//									.position(x: 115, y: 100)
									.opacity(tog4 ? 0 : 1)
									
									.overlay(
										VStack {
											Text("Best Performing Investment")
												.font(.system(size: 25, weight: .semibold))
												.padding(.leading, -20)
											
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
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
									.tintedGlassShape(color: white)
									.frame(width: 279, height: 200)
//									.position(x: 110,y: 100)
									.opacity(tog4 ? 0 : 1)
									.overlay(
										VStack {
											Text("Worst Performing Investment")
												.font(.system(size: 25, weight: .semibold))
											
											RoundedRectangle(cornerRadius: 20)
												.tintedGlassShape(color: white2)
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
			
			if appTour == true {
				app_Tour2.opacity(1)
			}
			else if appTour == false {
				withAnimation {
					app_Tour2.opacity(0)
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
						.tintedGlassShape(color: white)
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
	
	var app_Tour2: some View {
		ZStack {
			ScrollView {
				VStack (spacing: 15) {
					HStack (spacing: 15) {
						RoundedRectangle(cornerRadius: 20)
							.fill(st9 ? Color.clear : (colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7)))
							.frame(width: 600, height: 500)
						
						RoundedRectangle(cornerRadius: 20)
							.fill(st10 ? Color.clear : (colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7)))
							.frame(width: 500, height: 500)
					}
					
					HStack (spacing: 15) {
						RoundedRectangle(cornerRadius: 20)
							.fill(st11 ? Color.clear : (colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7)))
							.frame(width: 520, height: 200)
						
						
						
						HStack (spacing: 15) {
							RoundedRectangle(cornerRadius: 20)
								.fill(st12 ? Color.clear : (colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7)))
								.frame(width: 287.5, height: 200)
							
							RoundedRectangle(cornerRadius: 20)
								.fill(st12 ? Color.clear : (colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7)))
								.frame(width: 279, height: 200)
								.opacity(tog4 ? 0 : 1)
						}
					}
				}
			}
			
			/// st9 explanation
			VStack {
				RoundedRectangle(cornerRadius: 20)
					.tintedGlassShape(color: white)
					.opacity(st9 ? 1 : 0)
					.frame(width: 350, height: 270)
					.overlay(
						VStack {
							Text("This pie graph allows you to see the distribution of your investments. This is important because if you invest all your money into one thing, you leave your self vulnerable to something happening to that thing and you loosing everything. Moral of the story, diversify your assets.")
							
							HStack {
								
								Button(action: {
									withAnimation{
										st8 = true
										st9 = false
										selectedTab = 0
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
										st9 = false
										st10 = true
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
							.opacity(st9 ? 1 : 0)
					)
					.padding(.bottom, 450)
					.padding(.leading, 500)
			}
			
			/// st10 explanation
			VStack {
				RoundedRectangle(cornerRadius: 20)
					.tintedGlassShape(color: white)
					.opacity(st10 ? 1 : 0)
					.frame(width: 350, height: 170)
					.overlay(
						VStack {
							Text("In this list you can see the different assets you own along with thier type, current value, and performance.")
							
							HStack {
								
								Button(action: {
									withAnimation{
										st9 = true
										st10 = false
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
										st10 = false
										st11 = true
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
							.opacity(st10 ? 1 : 0)
					)
					.padding(.bottom, 450)
					.padding(.leading, -280)
			}
			
			/// st11 explanation
			VStack {
				RoundedRectangle(cornerRadius: 20)
					.tintedGlassShape(color: white)
					.opacity(st11 ? 1 : 0)
					.frame(width: 350, height: 170)
					.overlay(
						VStack {
							Text("In this list you can see the different assets you own along with thier type, current value, and performance.")
							
							HStack {
								
								Button(action: {
									withAnimation{
										st10 = true
										st11 = false
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
										st11 = false
										st12 = true
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
							.opacity(st11 ? 1 : 0)
					)
					.padding(.bottom, -100)
					.padding(.leading, -400)
			}
			
			/// st12 explanation
			VStack {
				RoundedRectangle(cornerRadius: 20)
					.tintedGlassShape(color: white)
					.opacity(st12 ? 1 : 0)
					.frame(width: 350, height: 200)
					.overlay(
						VStack {
							Text("Here you can see your best and worst performing investments at a glance. Both of these update automatically as your assets' performance changes.")
							
							HStack {
								
								Button(action: {
									withAnimation{
										st11 = true
										st12 = false
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
										st13 = true
										st12 = false
										selectedTab = 2
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
							.opacity(st12 ? 1 : 0)
					)
					.padding(.bottom, -100)
					.padding(.leading, 500)
			}
			
		}
	}
	
}

@available(iOS 17.0, *)
#Preview(traits: .landscapeLeft) {
	portfolioPage()
}
