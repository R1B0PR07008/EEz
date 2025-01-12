//
//  CreditScore.swift
//  EEz
//
//  Created by Riboldi  on 14/12/24.
//

import SwiftUI
import Charts

/// vars

var total = 850
var current_Score = 600
var left_score = current_Score-total

struct creditScoreHIstory : Identifiable {
    let id = UUID()
    let date: String
    let score: Double
}

struct CreditScorePieGraph: View {
    
    /// pie chart data
    
    let Budget = [
        ("Left to Improve", Double(left_score), red),
        ("Current Credit Score", Double(current_Score), green)
        ]
    
    var body: some View {
        VStack {
            Chart {
                ForEach(Budget, id: \.0) { category, value, color in
                            SectorMark(
                                angle: .value("Value", value),
                                innerRadius: .ratio(0.6),
                                outerRadius: .ratio(1.0),
                                angularInset: 30
                            )
                            .foregroundStyle(color)
                            .cornerRadius(20)
                            .shadow(color: color.opacity(0.8),radius: 5)
                        }
            }
                .padding([Edge.Set.bottom], 20)
            
            HStack {
                ForEach(Budget, id: \.0) { category, _, color in
                    HStack {
                        Circle()
                            .fill(color)
                            .frame(width: 10, height: 10)
                        Text(category)
                            .font(.system(size: 16))
                            .foregroundColor(black)
                    }
                }
            }
        }
    }
}

struct CreditScore: View {
    
    let creditScoreHistory : [creditScoreHIstory] = [
        creditScoreHIstory(date: "2021-01-15", score: 700),
        creditScoreHIstory(date: "2021-02-15", score: 600),
        creditScoreHIstory(date: "2021-03-15", score: 650),
        creditScoreHIstory(date: "2021-04-15", score: 670),
        creditScoreHIstory(date: "2021-05-15", score: 690),
        creditScoreHIstory(date: "2021-06-15", score: 700),
        creditScoreHIstory(date: "2021-07-15", score: 730),
        creditScoreHIstory(date: "2021-08-15", score: 700)
    ]
    
    @State var foldDownHeight : Double = 60
    
    @State var foldDownHeight2 : Double = 200
    
    @State var foldDownHeight3 : Double = 90
    
    @State var foldDownHeight4 : Double = 250
    
    var body: some View {

        NavigationView {
            VStack(spacing: 15) {
                CreditScorePieGraph()
                    .frame(width: 360, height: 310)
                    .padding(5)
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(white)
                    .frame(width: 370, height: 200)
                    .overlay(
                        HStack {
                            Text("Your Current \nCredit Score \nHistory")
                                .font(.system(size: 20, weight: .semibold))
                            
                            Divider().frame(width: 1, height: 170).overlay(Color(red: 176/255, green: 216/255, blue: 212/255))
                                .padding(.horizontal, 10)
                            
                            Chart(creditScoreHistory) { item in
                                LineMark(
                                    x: .value("Date", item.date),
                                    y: .value("Score", item.score)
                                )
                                .foregroundStyle(green)
                                AreaMark(
                                    x: .value("Date", item.date),
                                    y: .value("Score", item.score)
                                ).foregroundStyle(
                                    LinearGradient(colors: [green.opacity(0.8), green.opacity(0.1)], startPoint: .top, endPoint: .bottom)
                                )
                            }
                            .frame(width: 170, height: 160)
                        }
                    )
                
                
                NavigationLink(destination: CreditScore_HowTo()
                    .navigationTitle("How To Improve Your Score"), label: {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(white)
                        .frame(width: 370, height: 90)
                        .overlay(
                            HStack {
                                Text("Click Here To: \nKnow how to improve your score")
                                    .font(.system(size: 20, weight: .semibold))
                                    .foregroundStyle(black)
                            }
                        )
                })
            }
        }
    }
}

#Preview {
    CreditScore()
}
