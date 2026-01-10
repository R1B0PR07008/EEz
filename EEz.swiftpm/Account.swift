//
//  SwiftUIView.swift
//  EEz
//
//  Created by Riboldi  on 28/01/25.
//

import SwiftUI

struct Account: View {
	
	/// vars
	@AppStorage("weekly") var weekly: Bool = false
	@AppStorage("Notifications") var Notifications: Bool = false
	@AppStorage("Ai_tools") var Ai_tools: Bool = true
	
	@AppStorage("SavingGoal") var SavingGoal : String = ""
	
	@AppStorage("MonthlyBudget") var monthly_budget : String = "1500"
	
	@AppStorage("first_open") var first_open : Bool = true
	
	/// App tour vars
	
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
	
	
	@AppStorage("selectedTab") private var selectedTab: Int = 0
	
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
			
			VStack {
				HStack (spacing: 15) {
					VStack (alignment: .leading, spacing: 15) {
						RoundedRectangle(cornerRadius: 20)
							.tintedGlassShape(color: white)
							.frame(width: 500, height: 200)
							.overlay(
								HStack {
									VStack (alignment: .leading) {
										Text("Account")
											.font(.system(size: 40, weight: .semibold))
											.padding(.bottom, 20)
										
										Text("Name and Last Name")
											.font(.system(size: 30, weight: .semibold))
										Text("email@email.com")
											.font(.system(size: 20, weight: .semibold))
									}
									
									Spacer()
									
									Image(systemName: "person.circle")
										.resizable()
										.frame(width: 90, height: 90)
								}
									.padding(.horizontal, 30)
							)
						
						RoundedRectangle(cornerRadius: 20)
							.tintedGlassShape(color: white2)
							.frame(width: 500, height: 500)
							.overlay(
								VStack (alignment: .leading) {
									Text("Cards")
										.font(.system(size: 40, weight: .semibold))
										.padding(.top, 20)
									
									RoundedRectangle(cornerRadius: 20)
										.tintedGlassShape(color: white)
										.frame(width: 450, height: 200)
										.overlay(
											HStack {
												VStack (alignment: .leading) {
													Text("Master Card: **** 1234")
														.font(.system(size: 25, weight: .semibold))
														.padding(.bottom, 5)
													
													Text("Name and Last Name")
														.font(.system(size: 20, weight: .semibold))
														.padding(.bottom, 5)
													
													Text("Good Thru: 01/25")
														.font(.system(size: 20, weight: .semibold))
														.padding(.bottom, 5)
													
												}
												.padding(.horizontal, 20)
												
												Spacer()
												
											}
										)
									
									Spacer()
									
								}
							)
						
						
					}
					
					RoundedRectangle(cornerRadius: 20)
						.tintedGlassShape(color: white)
						.frame(width: 500, height: 715)
						.overlay(
							HStack {
								VStack (alignment: .leading) {
									Text("Settings")
										.font(.system(size: 40, weight: .semibold))
										.padding(.top, 30)
									
									VStack (alignment: .leading) {
										
											// Weekly or monthly
											Toggle(isOn: $weekly, label: { Text("Weekly") })
												
												.foregroundColor(black)
												.font(.system(size: 25, weight: .semibold))
											Text("Would you like to measure your expenses weekly or monthly?")
												.font(.system(size: 20))
												.fontWeight(.light)
												.padding(.horizontal, 20)
												.foregroundColor(black)
												.frame(width: 350)
												.padding(.bottom, 20)
											
											// notifications
											Toggle("Notifications", isOn: $Notifications)
												
												.foregroundColor(black)
												.font(.system(size: 25, weight: .semibold))
											Text("Would you like to get notifications from this app?")
												.font(.system(size: 20))
												.fontWeight(.light)
												.padding(.horizontal, 20)
												.foregroundColor(black)
												.frame(width: 350)
												.padding(.bottom, 20)
											
											// Ai tools
											Toggle("AI Tools", isOn: $Ai_tools)
												
												.foregroundColor(black)
												.font(.system(size: 25, weight: .semibold))
											Text("Would you like to use AI tools to help you manage your expenses?")
												.font(.system(size: 20))
												.fontWeight(.light)
												.padding(.horizontal, 20)
												.foregroundColor(black)
												.frame(width: 350)
												.padding(.bottom, 20)
									}
									.padding(.bottom, 20)
									
									RoundedRectangle(cornerRadius: 20)
										.tintedGlassShape(color: white2)
										.frame(width: 450, height:100)
										.overlay(content: {
											HStack {
												Text("Saving Goal: ($)")
													.foregroundColor(black)
													.font(.system(size: 25, weight: .semibold))
												
												RoundedRectangle(cornerRadius: 40)
													.tintedGlassShape(color: white)
													.frame(width: 190, height: 60)
													.overlay(content: {
														TextField("$1,234", text: $SavingGoal)
															.padding()
															.font(.system(size: 20, weight: .semibold))
															.padding(.leading, 10)
													})
												
											}
											.padding(.horizontal, 20)
										})
										.padding(.bottom, 10)
									
									RoundedRectangle(cornerRadius: 20)
										.tintedGlassShape(color: white2)
										.frame(width: 450, height:100)
										.overlay(content: {
											HStack {
												Text("Monthly Budget: ($)")
													.foregroundColor(black)
													.font(.system(size: 25, weight: .semibold))
												
												RoundedRectangle(cornerRadius: 40)
													.tintedGlassShape(color: white)
													.frame(width: 190, height: 60)
													.overlay(content: {
														TextField("$1,234", text: $monthly_budget)
															.padding()
															.font(.system(size: 20, weight: .semibold))
															.padding(.leading, 10)
													})
												
											}
											.padding(.horizontal, 20)
										})
										.padding(.bottom, 10)
									
										HStack {
											Button(
												action: {
													withAnimation{
														first_open = true
														
														withAnimation{
															appTour = true
															selectedTab = 0
														}
														
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
													}
												},
												label: {
													RoundedRectangle(cornerRadius: 20)
														.tintedGlassShape(color: white2)
														.frame(width: 220, height: 40)
														.overlay {
															Text("Reset Introduction Page")
																.foregroundStyle(black)
														}
												}
											)
											
											Button(
												action: {
													withAnimation{
														appTour = true
														selectedTab = 0
													}
													
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
													
													
													
												},
												label: {
													RoundedRectangle(cornerRadius: 20)
														.tintedGlassShape(color: white2)
														.frame(width: 220, height: 40)
														.overlay {
															Text("Reset App Tour")
																.foregroundStyle(black)
														}
												}
											)
											
										}
									
									Spacer()
									
								}
								.padding(.horizontal, 20)
								
								Spacer()
							}
						)
					
					
				}
				
				Spacer()
			}
			
			if appTour == true {
				app_yout3.opacity(1)
			}
			else if appTour == false {
				withAnimation {
					app_yout3.opacity(0)
				}
			}
		}
	}
	
	var app_yout3: some View {
		
		ZStack {
			VStack {
				HStack (spacing: 15) {
					VStack (alignment: .leading, spacing: 15) {
						RoundedRectangle(cornerRadius: 20)
							.fill((colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7)))
							.frame(width: 500, height: 200)
						
						RoundedRectangle(cornerRadius: 20)
							.fill((colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7)))
							.frame(width: 500, height: 500)
						
						
					}
					
					RoundedRectangle(cornerRadius: 20)
						.fill((colorScheme == .dark ? Color.black.opacity(0.6) : Color.white.opacity(0.7)))
						.frame(width: 500, height: 715)
					
				}
				
				Spacer()
			}
			
			
			/// st13 explanation
			VStack {
				RoundedRectangle(cornerRadius: 20)
					.tintedGlassShape(color: white)
					.opacity(st13 ? 1 : 0)
					.frame(width: 350, height: 200)
					.overlay(
						VStack {
							Text("Last but not least, here you can see and edit your settings for the app. You can also reset the app tour and see the app intro again if you want.")
							
							HStack {
								
								Button(action: {
									withAnimation{
										st12 = true
										st13 = false
										selectedTab = 1
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
										st14 = true
										st12 = false
										selectedTab = 0
									}
								}, label: {
									RoundedRectangle(cornerRadius: 20)
										.tintedGlassShape(color: white2)
										.frame(width: 100, height: 40)
										.overlay(
											HStack {
												
												Text("Finish")
												Image(systemName: "arrow.forward")
											}
										)
								})
								.padding(10)
							}
							
						}
							.padding(10)
							.opacity(st13 ? 1 : 0)
					)
			}
		}
	}
	
}

#Preview(traits: .landscapeLeft) {
	Account()
}
