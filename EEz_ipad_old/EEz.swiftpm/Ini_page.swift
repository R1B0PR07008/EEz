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
	
	var body: some View {
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
						Text("Hello, I'm Matias, a Costa Rican teenager living in Mexico. I'm a passionate software developer and I love to create things that help people. Here, I've made a personal finance app that aims to help you manage your money better, while also teaching you the basics of personal finance. Such as credit score, budgeting, saving, and more!")
							.font(.system(size: 25))
							.frame(width: 600)
							.multilineTextAlignment(.center)
							.padding(.bottom, 30)
							.padding(.top, 250)
						
						Text("Scroll down a bit to get started!")
							.font(.system(size: 30))
							.padding(.bottom, 300)
					}
						
				
					VStack {
						RoundedRectangle(cornerRadius: 20)
							.fill(white)
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
												.fill(white)
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
												.fill(white2)
												.frame(width: 370, height: 120)
												.overlay(content: {
													VStack {
														Text("Do You Have Any Svaing goals?")
															.padding(.horizontal, 20)
														
														RoundedRectangle(cornerRadius: 40)
															.fill(white)
															.frame(width: 320, height: 40)
															.overlay(content: {
																TextField("Saving Goal", text: $SavingGoal)
																	.padding()
															})
													}
														
												})
									
											RoundedRectangle(cornerRadius: 30)
												.fill(white2)
												.frame(width: 370, height: 120)
												.overlay(content: {
													VStack {
														Text("Do You Have Any Monthyl Budget?")
															.padding(.horizontal, 20)
												
														RoundedRectangle(cornerRadius: 40)
															.fill(white)
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
							.fill(white)
							.frame(width: 250, height: 100)
							.overlay(
								Text("Welcome!")
									.font(.system(size: 40, weight: .semibold))
									.foregroundStyle(black)
										
								)
								.padding(.top, 10)
								.onTapGesture {
									
									if first_open {
										let key = SymmetricKey(size: .bits256)
										KeychainHelper.storeKey(key)
										
										encryptOldData()
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
	}
}


#Preview {
	if #available(iOS 17.0, *) {
		IniView()
	} else {
		// Fallback on earlier versions
	}
}
