//
//  Stocks.swift
//  EEz
//
//  Created by Riboldi  on 27/11/24.
//

/// WORK ON THIS LATER (IT'LL HAVE TO BE PAID)

import SwiftUI
import Charts
import Foundation
import CSV

/// Import data from CSV for demo

struct dat : Identifiable, Decodable {
    let id: UUID?
    let Date: String
    let Open: Double
    let High: Double
    let Low: Double
    let Close: Double
    let Volume: Double
}

/// var for func
///
nonisolated(unsafe) var stream : InputStream!

func getCSVData() -> Array<dat> {
    var records = [dat] ()
	

		stream = InputStream(url: URL(fileURLWithPath: "/Users/riboldi_jr/Documents/GitHub/EEz/EEz.swiftpm/Resources/APPLE.csv")) /// Fix this
		do {
			let reader = try CSVReader(stream: stream, hasHeaderRow: true)
			let decoder = CSVRowDecoder()
			
			while reader.next() != nil {
				let row = try decoder.decode(dat.self, from: reader)
				records.append(row)
			}
		}
		catch {
			print("Error reading CSV file: \(error)")
		}
		
		return records
}


/// VIEW

struct Stocks: View {
	
	var stock_perf : Double = 10
	
	@AppStorage("cookie") var cookie: String = "Gas"
    
    @State private var searchText: String = ""
    
    @Environment(\.refresh) private var refresh
    
    @AppStorage("Pref_stock") var Pref_stock : String = "APPL"
    
    @State var stocks: [dat] = getCSVData()
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 40)
                .fill(white)
                .frame(width: 370, height: 40)
                .overlay(content: {
                    HStack {
                        TextField("Stock ticket", text: $searchText)
                            .padding()
                            .frame(width:300, height: 40)
                        
                        
                        Button(action: {
                            
                            /// Will refresh data on final app
                            
                        },
                        label: {
                            Image(systemName: "magnifyingglass")
                        })
                        .foregroundStyle(black)
                    }
                })
                
            VStack {
                HStack (alignment: .center) {
                    Text("\(Pref_stock)")
                        .font(.system(size: 20, weight: .semibold))
                        .padding()
                    
                    Spacer()
                    
                    Text("Refresh Data:")
                        .padding(.horizontal, -15)
                    
                    Button(action: {

                        /// Will find new stocks data on final app
                        
                    },
                    label: {
                        Image(systemName: "arrow.clockwise")
                    })
                        .padding()
                        .foregroundStyle(black)
                    // Display the fetched data (for demonstration purposes)
                }
                
                HStack {
                    Text("For the year 2023")
                        .padding(.horizontal, 15)
                    
                    Spacer()
                }
            }
            
            
            
            Chart(stocks) { item in
                LineMark(
                    x: .value("Date", item.Date),
                    y: .value("Close Price", item.Close)
                )
                .foregroundStyle(green)
                
                AreaMark(
                    x: .value("Date", item.Date),
                    y: .value("Close Price", item.Close)
                    )
                .foregroundStyle(
                    LinearGradient (
                        gradient: Gradient(colors: [green.opacity(0.8),green.opacity(0.1)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }.frame(width: 370, height: 200)
//                .chartYScale(domain: [0,250]) /// automate the max value
                .padding(.bottom, 10)
                .chartXAxis(.hidden)
                
			RoundedRectangle(cornerRadius: 20)
				.fill(white)
				.frame(width: 370, height: 90)
				.overlay(content: {
					HStack (spacing: 15) {
						Text("Current Stock \nPerformance")
							.font(.system(size: 20, weight: .semibold))
						
						Divider().frame(width: 1, height: 70).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
						
						RoundedRectangle(cornerRadius: 20)
							.fill(white2)
							.frame(width: 130, height: 50)
							.overlay(content: {
								if (stock_perf > 0) {
									Text("+\(stock_perf)")
										.foregroundStyle(green2)
										.font(.system(size: 20, weight: .semibold))
								}
								else if (stock_perf == 0) {
									Text("\(stock_perf)")
										.font(.system(size: 20, weight: .semibold))
								}
								else {
									Text("-\(stock_perf)")
										.foregroundStyle(red)
										.font(.system(size: 20, weight: .semibold))
								}
							})
					}
				})
                
            RoundedRectangle(cornerRadius: 20)
                .fill(white)
                .frame(width: 370, height: 190)

                .overlay(
                    
                    VStack {
                        HStack() {
                            
                            
                            VStack {
                                Text("Close Price")
                                    .foregroundColor(black)
                                    .font(.system(size: 20, weight: .semibold))
                                    .frame(width: 150)
                            }
                            
                            
                            Divider().frame(width: 1).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
                            
                            
                            VStack {
                                Text("Date")
                                    .foregroundColor(black)
                                    .font(.system(size: 20, weight: .semibold))
                                    .frame(width: 150)
                            }
                            
                        }
                        .padding()
                        .padding(.bottom, -10)
                        .frame(width: 350, height: 40)
                        
                        ScrollView {
                            VStack {
                                
                                ForEach(stocks, id: \.id) {item in
                                    RoundedRectangle(cornerRadius: 40)
                                        .fill(white2)
                                        .frame(width: 350, height: 35)
                                        .padding(.top, 0)
                                        .overlay(content: {
                                            
                                            HStack {
                                                
                                                let date = item.Date
                                                Text("\(date)")
                                                    .foregroundColor(black)
                                                    .frame(width: 150)
                                                
                                                
                                                Divider().frame(width: 1, height: 25).overlay(Color(red: 176/255, green: 165/255, blue: 173/255))
                                                
                                                let close = item.Close
                                                Text("\(close)")
                                                    .foregroundColor(black)
                                                    .frame(width: 150)
                                                
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
    Stocks()
}
