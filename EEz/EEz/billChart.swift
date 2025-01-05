//
//  billChart.swift
//  EEz
//
//  Created by Riboldi  on 29/12/24.
//

import SwiftUI
import Charts

struct dataResponse: Codable{ /// FIX THIS SHIT. THE TYPES DON'T MATCH FOR SOME SHITY ASS REASON.
    var id: String?
    var name: String?
    var domain: String?
    var claimed: Bool?
    var description: String?
    var longDescription: String?
    
    struct links: Codable {
        var name: String?
        var url: String?
    }
    
    struct logos: Codable {
        var theme: String?
        
        struct formats: Codable {
            var src: String?
            var format: String?
            var height: Int?
            var width: Int?
            var size: Int?
            var backgroud: String?

        }
        
        var tags: [String]?
        var type: String?
    }
    
    struct colors: Codable {
        var hex: String?
        var type: String?
        var brightness: Float?
    }
    
    struct fonts: Codable {
        var name: String?
        var type: String?
        var origin: String?
        var originId: String?
        var weights: [String]?
    }
    
    struct images: Codable {
        
        struct formats: Codable {
            var src: String?
            var format: String?
            var height: Int?
            var width: Int?
            var size: Int?
            var background: String?
        }
        
        var tags: [String]?
        var type: String?
    }

    var qualityScore: String?
    
    struct company: Codable {
        var employees: Int?
        var foundedYear: Int?
        
        struct industries: Codable {
            var id: String?
            var score: Float?
            var slug: String?
            var name: String?
            var emoji: String?

            struct parent: Codable {
                var id: String?
                var slug: String?
                var name: String?
                var emoji: String?
                
            }
            
            var kind: String?
           
            struct location: Codable {
                var city: String?
                var country: String?
                var countryCode: String?
                var region: String?
                var state: String?
                var subregion: String?
            }
        }
    }
    
    var isNsfw: Bool?
    var urn: String?
}

struct graph: View {
    
    let monthly_data = [
            ("1", 12343),
            ("2", 12332),
            ("3", 23324),
            ("4", 23455),
            ("5", 45675),
            ("6", 13456),
        ]
    
    var body: some View {
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
        .chartYAxisLabel("Month")
        
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
}

struct billChart: View {
    
    var body: some View {
        ScrollView(Axis.Set.vertical) {
            VStack(alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 40)
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
                
                
                RoundedRectangle(cornerRadius: 40)
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
                
                
                RoundedRectangle(cornerRadius: 40)
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
                
                
                RoundedRectangle(cornerRadius: 40)
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
                
                
                RoundedRectangle(cornerRadius: 40)
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
