//
//  ContentView.swift
//  EEz
//
//  Created by Matias Riboldi on 27/10/2024.
//

import SwiftUI

// My Green = (red: 0.34901, green: 0.7803921, blue: 0.635294)
// My White = red: 238/255, green: 240/255, blue: 251/255
// My Black = red: 46/255, green: 40/255, blue: 42/255

// Demo Table data

struct ContentView: View {
    var body: some View {

        
        NavigationView() {
            VStack() {
                NavigationLink(destination: monthlyDash()) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.34901, green: 0.7803921, blue: 0.635294))
                        .frame(width: 370, height: 250)
                        .overlay (
                            HStack {
                                Text("Hi")
                                Divider().frame(width: 1)
                                Text("hi")
                            }
                                .padding()
                                .foregroundColor(Color(red: 46/255, green: 40/255, blue: 42/255))
                        )
                }
                
                NavigationLink(destination: billChart()) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(red: 0.34901, green: 0.7803921, blue: 0.635294))
                        .frame(width: 370, height: 250)
                        .overlay (
                            HStack {
                                Text("hello")
                                    .foregroundColor(Color(red: 46/255, green: 40/255, blue: 42/255))
                                    .font(.system(size: 40))
                                
                                Divider().frame(width: 1)
                                
                                Text("hello")
                                    .foregroundColor(Color(red: 46/255, green: 40/255, blue: 42/255))
                                    .font(.system(size: 40))
                            }.padding()
                            
                        )
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
