//
//  SwiftUIView.swift
//  EEz
//
//  Created by Riboldi  on 02/02/25.
//

import SwiftUI

let len = bills.count

struct Add_bill: View {

	@State private var spent_ : String = ""
	@State private var date : String = ""
	@State private var place : String = ""
	@State private var category : String = ""
	
    var body: some View {
		VStack {
			RoundedRectangle(cornerRadius: 20)
				.fill(white)
				.frame(width: 500, height: 650)
				.overlay(
					VStack {
						VStack (alignment: .leading) {
							
							Text("Add Bill")
								.font(.system(size: 40, weight: .semibold))
							
							RoundedRectangle(cornerRadius: 40)
								.fill(white2)
								.frame(width: 400, height: 60)
								.overlay(
									HStack {
										
										Text("Spent ($)")
											.font(.system(size: 20, weight: .semibold))
											.padding(.leading, 20)
											.frame(width: 170)
										
										RoundedRectangle(cornerRadius: 40)
											.fill(white)
											.frame(width: 200, height: 40)
											.overlay(
												TextField("$...", text: $spent_)
													.padding(.leading, 10)
													.font(.system(size: 20))
											)
									}
								)
								.padding(.bottom, 20)
							
							
							RoundedRectangle(cornerRadius: 40)
								.fill(white2)
								.frame(width: 400, height: 60)
								.overlay(
									HStack {
										
										Text("Date")
											.font(.system(size: 20, weight: .semibold))
											.padding(.leading, 20)
											.frame(width: 170)
										
										RoundedRectangle(cornerRadius: 40)
											.fill(white)
											.frame(width: 200, height: 40)
											.overlay(
												TextField("DD/MM/YYYY", text: $date)
													.padding(.leading, 10)
													.font(.system(size: 20))
											)
									}
								)
								.padding(.bottom, 20)
							
							RoundedRectangle(cornerRadius: 40)
								.fill(white2)
								.frame(width: 400, height: 60)
								.overlay(
									HStack {
										
										Text("Place (Store) ")
											.font(.system(size: 20, weight: .semibold))
											.padding(.leading, 20)
											.frame(width: 170)
										
										RoundedRectangle(cornerRadius: 40)
											.fill(white)
											.frame(width: 200, height: 40)
											.overlay(
												TextField("Store Name", text: $place)
													.padding(.leading, 10)
													.font(.system(size: 20))
											)
									}
								)
								.padding(.bottom, 20)
							
							RoundedRectangle(cornerRadius: 40)
								.fill(white2)
								.frame(width: 400, height: 60)
								.overlay(
									HStack {
										
										Text("Category")
											.font(.system(size: 20, weight: .semibold))
											.padding(.leading, 20)
											.frame(width: 170)
										
										RoundedRectangle(cornerRadius: 40)
											.fill(white)
											.frame(width: 200, height: 40)
											.overlay(
												TextField("Ex. Super market", text: $category)
													.padding(.leading, 10)
													.font(.system(size: 20))
											)
									}
								)
								.padding(.bottom, 50)
					}
						
						VStack {
							Button(action: {
								
								addNewBill(spent: Double(spent_)!, date: date, place: place, category: category)
								
							}, label: {
								RoundedRectangle(cornerRadius: 20)
									.fill(white2)
									.frame(width: 250, height: 70)
									.overlay(
										Text("Enter Bill Data")
											.foregroundColor(black)
											.font(.system(size: 30, weight: .semibold))
									)
							})
						}
					}
			)
					
		}
    }
}

#Preview {
    Add_bill()
}
