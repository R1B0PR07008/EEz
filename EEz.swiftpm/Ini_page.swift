//
//  SwiftUIView.swift
//  EEz
//
//  Created by Riboldi  on 28/01/25.
//

import SwiftUI
import CryptoKit

@available(iOS 17.0, *)
struct IniView: View {
	
	@AppStorage("first_open") var first_open : Bool = true
	
	@AppStorage("weekly") var weekly: Bool = false
	@AppStorage("Notifications") var Notifications: Bool = false
	@AppStorage("Ai_tools") var Ai_tools: Bool = true
	@AppStorage("SavingGoal") var SavingGoal : String = ""
	@AppStorage("MonthlyBudget") var monthly_budget : String = "1500"
	
	@AppStorage("appTour") var appTour : Bool = true
	
	/// for light-dark mode detector
	
	@Environment(\.colorScheme) var colorScheme
	
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
					VStack {
						VStack {
								if let logo = UIImage(named: "Logo") {
									Image(uiImage: logo)
										.resizable() // Allow resizing
										.frame(width: 230, height: 230) // Set size
										.clipShape(RoundedRectangle(cornerRadius: 16)) // Optional: Add styling
										.padding(.top, 270)
								}
							
								Text("Scroll Down")
								.font(.system(size: 20))
								.padding(.top, 250)
							
							}
						.padding(.bottom, 300)
							
						VStack {
							Text("""
									Welcome to EEz - our personal finance companion
								""")
								.font(.system(size: 30))
								.frame(width: 700)
								.multilineTextAlignment(.center)
								.padding(.top, 170)
								.padding(.bottom, 20)

							Text("""
									This app started as a simple request from my uncle—an app to track expenses—became something much bigger. As I built it, I realized: I'm 17, about to be financially independent, and I don't actually understand credit scores, stock markets, or even basic budgeting principles. And neither do most of my peers.\n
									We're the first generation growing up entirely digital, yet financial literacy still isn't part of our education. EEz bridges that gap—combining practical expense tracking with the financial knowledge we should have learned in school but didn't.
								""")
								.font(.system(size: 25))
								.frame(width: 700)
								.multilineTextAlignment(.center)
								.padding(.bottom, 20)
							
							Text("Scroll down a bit to get started!")
								.font(.system(size: 30))
								.padding(.bottom, 300)
						}
						.frame(width: 1100)
							
					
						VStack {
							RoundedRectangle(cornerRadius: 20)
								.tintedGlassShape(color: white)
								.frame(width: 500, height: 670)
								.overlay(
									VStack {
												Text("First, we need some info: ")
													.font(.system(size: 35))
													.fontWeight(.bold)
													.foregroundColor(black)
													.padding(.top, 10)
												
												// toggles
												
												RoundedRectangle(cornerRadius: 30)
											.tintedGlassShape(color: white)
													.frame(width: 370, height: 300)
													.overlay(content: {
														VStack (alignment: .leading) {
															// Weekly or monthly
															Toggle(isOn: $weekly, label: { Text("Weekly") })
																.padding(40)
																.padding([.top, .bottom], -35)
																.foregroundColor(black)
																.font(.system(size: 25, weight: .semibold))
															Text("Would you like to measure your expenses weekly or monthly?")
																.font(.system(size: 18))
																.fontWeight(.light)
																.padding(.horizontal, 30)
																.foregroundColor(black)
																.frame(width: 350)
															
															// notifications
															Toggle("Notifications", isOn: $Notifications)
																.padding(40)
																.padding([.top, .bottom], -35)
																.foregroundColor(black)
																.font(.system(size: 25, weight: .semibold))
															Text("Would you like to get notifications from this app?")
																.font(.system(size: 18))
																.fontWeight(.light)
																.padding(.horizontal, 30)
																.foregroundColor(black)
																.frame(width: 350)
															
															// Ai tools
															Toggle("AI Tools", isOn: $Ai_tools)
																.padding(40)
																.padding([.top, .bottom], -35)
																.foregroundColor(black)
																.font(.system(size: 25, weight: .semibold))
															Text("Would you like to use AI tools to help you manage your expenses?")
																.font(.system(size: 18))
																.fontWeight(.light)
																.padding(.horizontal, 30)
																.foregroundColor(black)
																.frame(width: 350)
														}
													})
												
												// non toggles
												RoundedRectangle(cornerRadius: 30)
													.tintedGlassShape(color: white2)
													.frame(width: 370, height: 120)
													.overlay(content: {
														VStack {
															Text("Do You Have Any Svaing goals?")
																.padding(.horizontal, 20)
															
															RoundedRectangle(cornerRadius: 40)
																.tintedGlassShape(color: white)
																.frame(width: 320, height: 40)
																.overlay(content: {
																	TextField("Saving Goal", text: $SavingGoal)
																		.padding()
																})
														}
															
													})
										
												RoundedRectangle(cornerRadius: 30)
													.tintedGlassShape(color: white2)
													.frame(width: 370, height: 120)
													.overlay(content: {
														VStack {
															Text("Do You Have Any Monthyl Budget?")
																.padding(.horizontal, 20)
													
															RoundedRectangle(cornerRadius: 40)
																.tintedGlassShape(color: white)
																.frame(width: 320, height: 40)
																.overlay(content: {
																	TextField("Monthly Budget", text: $monthly_budget)
																		.padding()
														})
												}
													
											})
									}
								)
								
						
							RoundedRectangle(cornerRadius: 40)
								.tintedGlassShape(color: white)
								.frame(width: 250, height: 70)
								.overlay(
									Text("Welcome!")
										.font(.system(size: 40, weight: .semibold))
										.foregroundStyle(black)
											
									)
									.padding(.top, 10)
									.onTapGesture {
										
										if first_open {
											
											data_()
											
											let data = UserDefaults.standard.string(forKey: "bills_csv")!
											
											print(data)
											
											let key = SymmetricKey(size: .bits256)
											KeychainHelper.storeKey(key)
											
											print(UserDefaults.standard.string(forKey: "bills_csv") ?? "nil")
											
											UserDefaults.standard.set(CryptoHelper.encryptCSVToString(UserDefaults.standard.string(forKey: "bills_csv")!, key: KeychainHelper.retrieveKey()!), forKey: "bills_csv")
											
											appTour = true
										}
										
										withAnimation {
											first_open.toggle()
										}
									}
						}
					}
						.scrollTargetLayout()
				}
				.scrollTargetBehavior(.viewAligned)
				.frame(width: .infinity)
			}
	}
}


#Preview(traits: .landscapeLeft) {
	if #available(iOS 17.0, *) {
		IniView()
	} else {
		// Fallback on earlier versions
	}
}
