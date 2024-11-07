//  ContentView.swift
//  EEz
//  Created by Matias Riboldi on 27/10/2024.

import SwiftUI

// My Green = (red: 0.34901, green: 0.7803921, blue: 0.635294)
// My White = red: 238/255, green: 240/255, blue: 251/255
// My Black = red: 46/255, green: 40/255, blue: 42/255

// Demo chart/table data

var budget_monthly = 8300
var spent = 4000
var left = budget_monthly-spent

var bills = [
    (100.0, "12-3-2024", "McDonalds"),
    (130, "12-5-2024", "Gas"),
    (150, "12-6-2024", "Walmart")
]

var hi = bills[0]

// Chart Data:

struct viu: View {
    let Data = [
        (Double(left), Color(red: 0.34901, green: 0.7803921, blue: 0.635294)), // issue turned out to be that the number needed to be a double
        (Double(spent), Color(red: 98/255, green: 144/255, blue: 200/255))
    ]
            
    var body: some View {
        Pie(slices: Data)
    }
}

struct ContentView: View {
    var body: some View {
        
        NavigationView() {
            VStack() {
                
                Spacer()
                
                viu().padding([Edge.Set.top], -250) // this looks like shit (Need to replace it with the IOS 17 version)
                
                NavigationLink(destination: monthlyDash()) {
                    
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color(red: 0.34901, green: 0.7803921, blue: 0.635294))
                        .frame(width: 370, height: 220)
                        .overlay (
                            
                            HStack(spacing: 10) {
                                
                                VStack {
                                    Text("Spent this month")
                                        .font(.system(size: 20))
                                    
                                }
                                
                                
                                Divider().frame(width: 1).overlay(Color(red: 111/255, green: 209/255, blue: 176/255))
                                
                                
                                VStack {
                                    Text("Spent Last month")
                                        .font(.system(size: 20))
                                    
                                }
                            }
                                .padding()
                                .foregroundColor(Color(red: 46/255, green: 40/255, blue: 42/255))
                        )
                }
                
                NavigationLink(destination: billChart()) {
                    
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color(red: 0.34901, green: 0.7803921, blue: 0.635294))
                        .frame(width: 370, height: 220)
                        .overlay (
                            
                            HStack(spacing: 35) {
                                
                                
                                VStack {
                                    Text("Spent")
                                        .foregroundColor(Color(red: 46/255, green: 40/255, blue: 42/255))
                                        .font(.system(size: 20))
                                    
                                    var b=0
                                    for b in bills  {
                                        b = b+1
                                        Text(String(bills[b].0))
                                    }
                                }
                                
                                
                                Divider().frame(width: 1).overlay(Color(red: 89/255, green: 209/255, blue: 169/255))
                                
                                
                                VStack {
                                    Text("Date")
                                        .foregroundColor(Color(red: 46/255, green: 40/255, blue: 42/255))
                                        .font(.system(size: 20))
                                }
                                
                                
                                Divider().frame(width: 1).overlay(Color(red: 89/255, green: 209/255, blue: 169/255))
                               
                                
                                VStack {
                                    Text("Place")
                                        .foregroundColor(Color(red: 46/255, green: 40/255, blue: 42/255))
                                        .font(.system(size: 20))
                                }
                                
                                
                            }.padding()
                        )
                }
            }.frame(maxHeight: .infinity)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
