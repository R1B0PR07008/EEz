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
							.frame(width: 500, height: 450)
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
						.frame(width: 500, height: 665)
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
									
									Spacer()
									
								}
								.padding(.horizontal, 20)
								
								Spacer()
							}
						)
					
					
				}
				
				Spacer()
			}
		}
	}
}

#Preview {
	Account()
}
