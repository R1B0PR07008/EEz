//
//  billChart.swift
//  EEz
//
//  Created by Riboldi  on 07/11/24.
//

import SwiftUI
import Charts
import Alamofire

/// API vars
let header : HTTPHeaders = [
	"Authorization": "Bearer brand__3ZaBa85tGcY9wxJuj5m5FXU6"
]

struct graph: View {
    
    let monthly_data = [
            ("1", 12343, 23353),
            ("2", 12332, 23343),
            ("3", 23324, 34334),
            ("4", 23455, 34465),
            ("5", 45675, 55685),
            ("6", 13456, 24466),
        ]
    
    var body: some View {
		VStack {
			Chart {
				ForEach(monthly_data, id: \.0) { month, value, budget in
					AreaMark(
							x: .value("Month", month),
							y: .value("Spent", budget)
						)
					.foregroundStyle(
						LinearGradient (
							gradient: Gradient(colors: [green,green.opacity(0.1)]),
							startPoint: .top,
							endPoint: .bottom
						))
					
					LineMark(
						x: .value("Month", month),
						y: .value("Sales", value)
					)
					.foregroundStyle(red)
					
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
}

struct billChart: View {
	
	/// API Stuff

	let responce = AF.request("https://api.brand.dev/v1/brand/retrieve?domain=apple.com", headers: header).responseJSON { response in
		switch response.result {
	 case .success(let value):
		 print("Response JSON: \(value)")
	 case .failure(let error):
		 print("Error: \(error.localizedDescription)")
	 }
	}
    
    var body: some View {
		Text("Bills Sorted By Category")
			.font(.system(size: 20, weight: .semibold))
			.padding(.bottom, 15)
		
        ScrollView(Axis.Set.vertical) {
            VStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(white)
                    .frame(width: 370,height: 200)
                    .overlay(
                        HStack(alignment: .center) {
                            VStack {
                                Text("Gas")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(white2)
                                    .frame(width: 100,height: 50)
                                    .overlay(
                                        Text("$1,923")
                                            .font(.system(size: 20, weight: .semibold))
                                    )
                            }.frame(width: 120)
                            
                            Divider().frame(width: 1, height: 160).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
                            
                            graph()
                            
                            
                            
                        }
                    )
                
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(white)
                    .frame(width: 370,height: 200)
                    .overlay(
                        HStack(alignment: .center) {
                            VStack {
                                Text("Super Market")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(white2)
                                    .frame(width: 100,height: 50)
                                    .overlay(
                                        Text("$1,923")
                                            .font(.system(size: 20, weight: .semibold))
                                    )
                            }.frame(width: 120)
                            
                            Divider().frame(width: 1, height: 160).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
                            
                            graph()
                            
                        }
                    
                    )
                
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(white)
                    .frame(width: 370,height: 200)
                    .overlay(
                        HStack(alignment: .center) {
                            VStack {
                                Text("Fast Food")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(white2)
                                    .frame(width: 100,height: 50)
                                    .overlay(
                                        Text("$1,923")
                                            .font(.system(size: 20, weight: .semibold))
                                    )
                            }.frame(width: 120)
                            
                            Divider().frame(width: 1, height: 160).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
                            
                            graph()
                            
                        }
                    )
                
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(white)
                    .frame(width: 370,height: 200)
                    .overlay(
                        HStack(alignment: .center) {
                            VStack {
                                Text("Insurance")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(white2)
                                    .frame(width: 100,height: 50)
                                    .overlay(
                                        Text("$1,923")
                                            .font(.system(size: 20, weight: .semibold))
                                    )
                            }.frame(width: 120)
                            
                            Divider().frame(width: 1, height: 160).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
                            
                            graph()
                            
                        }
                    )
                
                
                RoundedRectangle(cornerRadius: 25)
                    .fill(white)
                    .frame(width: 370,height: 200)
                    .overlay(
                        HStack(alignment: .center) {
                            VStack {
                                Text("IDK")
                                    .font(.system(size: 20, weight: .semibold))
                                
                                RoundedRectangle(cornerRadius: 30)
                                    .fill(white2)
                                    .frame(width: 100,height: 50)
                                    .overlay(
                                        Text("$1,923")
                                            .font(.system(size: 20, weight: .semibold))
                                    )
                            }.frame(width: 120)
                            
                            Divider().frame(width: 1, height: 160).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
                            
                            graph()
                            
                        }
                    )
            }
        }
    }
}

#Preview {
    billChart()
}
