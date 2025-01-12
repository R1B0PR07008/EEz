//
//  dashMonthly.swift
//  EEz
//
//  Created by Riboldi  on 07/11/24.
//

import SwiftUI
import Charts

struct dashMonthly: View {
    
    let percentDiffMonthly_spent = 23
    
    let monthly_data = [
            ("mon 1", 12343),
            ("mon 2", 12332),
            ("mon 3", 23324),
            ("mon 4", 23455),
            ("mon 5", 45675),
            ("mon 6", 13456),
            
        ]
    
    let bills: [[String: String]] = [
        ["id": "1", "Spent": "100", "date": "12-3-2024", "place": "McDonalds"],
        ["id": "2", "Spent": "130", "date":  "12-5-2024", "place":  "Gas"],
        ["id": "3", "Spent": "150", "date":  "12-6-2024", "place":  "Walmart"],
        ["id": "4", "Spent": "170", "date":  "12-7-2024", "place":  "Decathlon"]
    ]
    
    var body: some View {
        VStack {
            
            // manin chart
            
            Text("Monthly Spending")
                .font(.system(size: 20,weight: .bold))
            
            Chart {
                ForEach(monthly_data, id: \.0) { month, value in
                    LineMark(
                        x: .value("Month", month),
                        y: .value("Sales", value)
                    )
                    .foregroundStyle(green)  // Line color
                    
                    AreaMark(
                            x: .value("Month", month),
                            y: .value("Spent", value)
                        )
                    .foregroundStyle(
                        LinearGradient (
                            gradient: Gradient(colors: [green,green.opacity(0.1)]),
                            startPoint: .top,
                            endPoint: .bottom
                        ))
                    
                }
            }.frame(width: 340, height: 180)
                .padding(.bottom, 20)
            
            // Fisrt rectangle
            RoundedRectangle(cornerRadius: 20)
                .fill(white)
                .frame(width: 370, height: 220)
                .overlay (
                    
                    HStack {
                        
                        VStack {
                            Text("Spent \nthis month")
                                .font(.system(size: 22, weight: .semibold))
                            
                            RoundedRectangle(cornerRadius: 20)
                                .fill(white2)
                                .frame(width: 100, height: 60)
                                .overlay(
                                    Text("$122331")
                                        .font(.system(size: 20, weight: .semibold))
                                ).padding(.bottom, 10)
                            
                            Text("Up \(percentDiffMonthly_spent)% from last month")
                        }.padding(10)
                        
                        Divider().frame(width: 1, height: 180).overlay(Color(red: 176/255, green: 216/255, blue: 212/255))
                        
                        //CHART Stuff
                        
                        Chart {
                            ForEach(monthly_data, id: \.0) { month, value in
                                LineMark(
                                    x: .value("Month", month),
                                    y: .value("Sales", value)
                                )
                                .foregroundStyle(green)  // Line color
                                
                                AreaMark(
                                        x: .value("Month", month),
                                        y: .value("Spent", value)
                                    )
                                .foregroundStyle(
                                    LinearGradient (
                                        gradient: Gradient(colors: [green,green.opacity(0.1)]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    ))
                            }
                        }.frame(width:210, height: 180)
                        
                        // X-Axis Stuff
                        .chartXAxis {
                            AxisMarks(values: .automatic) { _ in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel()
                                    .font(.system(size: 6, weight: .medium, design: .rounded)) // X-axis label font
                            }
                        }
                        
                        // Y-Axis Stuff
                        .chartYAxis {
                            AxisMarks(values: .automatic) { _ in
                            AxisGridLine()
                            AxisTick()
                            AxisValueLabel()
                            .font(.system(size: 7, weight: .medium, design: .rounded)) // Y-axis label font
                            }
                        }
                    }
                    // END OF CHART
                )
            
            
            // Second rectangle
            RoundedRectangle(cornerRadius: 40) /// CHANGE THIS TO RENCENT BILLS TABLE
                .fill(white)
                .frame(width: 370, height: 180)
                .overlay(
                    
                    VStack {
                        HStack() {
                            
                            
                            VStack {
                                Text("Spent")
                                    .foregroundColor(black)
                                    .font(.system(size: 20))
                                    .frame(width: 100)
                            }
                            
                            
                            Divider().frame(width: 1).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
                            
                            
                            VStack {
                                Text("Date")
                                    .foregroundColor(black)
                                    .font(.system(size: 20))
                                    .frame(width: 100)
                            }
                            
                            
                            Divider().frame(width: 1).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
                            
                            
                            VStack {
                                Text("Place")
                                    .foregroundColor(black)
                                    .font(.system(size: 20))
                                    .frame(width: 100)
                            }
                            
                            
                        }
                        .padding()
                        .padding(.bottom, 0)
                        .frame(width: 350, height: 60)
                        
                        ScrollView {
                            VStack {
                                
                                ForEach(bills, id: \.self) {bills in
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(white2)
                                        .frame(width: 350, height: 40)
                                        .padding(.top, 0)
                                        .overlay(content: {
                                            
                                            HStack {
                                                
                                                if let spnt = bills["Spent"] {
                                                    Text("\(spnt)")
                                                        .foregroundColor(black)
                                                        .frame(width: 106)
                                                }
                                                
                                                
                                                Divider().frame(width: 1, height: 25).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
                                                    
                                                
                                                
                                                if let spnt = bills["date"] {
                                                    Text("\(spnt)")
                                                        .foregroundColor(black)
                                                        .frame(width: 106)
                                                }
                                                
                                                
                                                Divider().frame(width: 1, height: 25).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
                                                    
                                                
                                                
                                                if let spnt = bills["place"] {
                                                    Text("\(spnt)")
                                                        .foregroundColor(black)
                                                        .frame(width: 106)
                                                }
                                            }
                                        })
                                }
                            }
                        }.padding(.bottom, 20)
                    }
                    
                )
        }
    }
}

#Preview {
    dashMonthly()
}
