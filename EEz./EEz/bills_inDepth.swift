//
//  bills_inDepth.swift
//  EEz
//
//  Created by Riboldi  on 14/01/25.
//

import SwiftUI

/// sorted bills data

let vills_data_ : [RecentBillsData] = bills.filter {$0.category == cookie}
let totalSpent = vills_data_.compactMap { $0.Spent }.compactMap { Double($0) }.reduce(0, +)

struct bills_inDepth: View {
	
	@State private var vills_data : [RecentBillsData] = bills.filter {$0.category == cookie}
	@State private var formattedTotalSpent = String(format: "%.2f", totalSpent)
	
	var scrollviewthingy : some View {
		ScrollView {
			VStack {
				ForEach(vills_data, id: \.self) {bills in
					RoundedRectangle(cornerRadius: 40)
						.fill(white2)
						.frame(width: 350, height: 40)
						.padding(.top, 0)
						.overlay(content: {
							
							HStack {
								
								
								Text("\(bills.Spent)")
										.foregroundColor(black)
										.frame(width: 106)
								
								
								Divider().frame(width: 1, height: 25).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
									
								
								
								 
									Text("\(bills.Date)")
										.foregroundColor(black)
										.frame(width: 106)
								
								
								
								Divider().frame(width: 1, height: 25).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
									
								
								
								
									Text("\(bills.Place)")
										.foregroundColor(black)
										.frame(width: 106)
								
							}
						})
				}
				
				RoundedRectangle(cornerRadius: 40)
					.fill(white2)
					.frame(width: 350, height: 40)
					.overlay(
						Text("Looks like you ran out of bills")
					)
			}
		}
	}
	
	var body: some View {
		VStack {
			
			RoundedRectangle(cornerRadius: 20)
				.fill(white)
				.frame(width: 370, height: 200)
				.overlay(
					HStack {
						VStack {
							Text("Spent this \nmonth on \n\(cookie)")
								.font(.system(size: 22, weight: .semibold))
							
							/// add sum of spent here
							
							RoundedRectangle(cornerRadius: 20)
								.fill(white2)
								.frame(width: 130, height: 60)
								.overlay(
									Text("$\(formattedTotalSpent)")
										.font(.system(size: 22, weight: .semibold))
								)
								.padding(.top, 5)
							
						}
						
						Divider().frame(width: 1, height: 160).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
						
						graph_line(category: cookie)
						

					}
				)
			
			RoundedRectangle(cornerRadius: 20)
				.fill(white)
				.frame(width: 370, height: 400)
				.overlay(
					VStack {
						Text("Recent Bills")
							.font(.system(size: 20, weight: .semibold))
							.padding(.top, 20)
						
						RoundedRectangle(cornerRadius: 20)
							.fill(white2)
							.frame(width: 350, height: 40)
							.overlay(
								VStack {
									HStack() {
										VStack {
											Text("Spent")
												.foregroundColor(black)
												.font(.system(size: 20))
												.frame(width: 106)
										}
										
										
										Divider().frame(width: 1).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
										
										
										VStack {
											Text("Date")
												.foregroundColor(black)
												.font(.system(size: 20))
												.frame(width: 106)
										}
										
										
										Divider().frame(width: 1).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
										
										
										VStack {
											Text("Place")
												.foregroundColor(black)
												.font(.system(size: 20))
												.frame(width: 106)
										}
									}
									.padding()
									.padding(.bottom, 0)
									.frame(width: 350, height: 60)
								}
								
							)
						
						scrollviewthingy
						
					}
				)
		}
	}
}

#Preview {
	bills_inDepth()
}
