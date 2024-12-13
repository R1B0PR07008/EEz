//
//  Ini_Setup.swift
//  EEz
//
//  Created by Riboldi  on 08/11/24.
//

import SwiftUI

struct Ini_Setup: View {

    @AppStorage("weekly") var weekly: Bool = false
    @AppStorage("Notifications") var Notifications: Bool = false
    @AppStorage("Ai_tools") var Ai_tools: Bool = true /// Change this to user default to see if it now miraculosly wants to FUCKING WORk. I FUCKING HATE APPLE.
    @AppStorage("SavingGoal") var SavingGoal : String = ""
    @AppStorage("first_open") var first_open : Bool = true
    @AppStorage("Pref_stock") var Pref_stock : String = ""
    
    var body: some View {
        Text("Initial Setup")
            .font(.system(size: 20))
            .fontWeight(.bold)
            .foregroundColor(black)
        
        // toggles
        
        RoundedRectangle(cornerRadius: 30)
            .fill(white)
            .frame(width: 370, height: 300)
            .overlay(content: {
                VStack {
                    // Weekly or monthly
                    Toggle(isOn: $weekly, label: { Text("Weekly") })
                        .padding(40)
                        .padding([.top, .bottom], -35)
                        .foregroundColor(black)
                    Text("Would you like to measure your expenses weekly or monthly?")
                        .font(.system(size: 14))
                        .fontWeight(.light)
                        .padding(.horizontal, 30)
                        .foregroundColor(black)
                        .frame(width: 350)
                    
                    // notifications
                    Toggle("Notifications", isOn: $Notifications)
                        .padding(40)
                        .padding([.top, .bottom], -35)
                        .foregroundColor(black)
                    Text("Would you like to get notifications from this app?")
                        .font(.system(size: 14))
                        .fontWeight(.light)
                        .padding(.horizontal, 30)
                        .foregroundColor(black)
                        .frame(width: 350)
                    
                    // Ai tools
                    Toggle("AI Tools", isOn: $Ai_tools)
                        .padding(40)
                        .padding([.top, .bottom], -35)
                        .foregroundColor(black)
                    Text("Would you like to use AI tools to help you manage your expenses?")
                        .font(.system(size: 14))
                        .fontWeight(.light)
                        .padding(.horizontal, 30)
                        .foregroundColor(black)
                        .frame(width: 350)
                }
            })
        
        // non toggles
        RoundedRectangle(cornerRadius: 30)
            .fill(white)
            .frame(width: 370, height: 120)
            .overlay(content: {
                VStack {
                    Text("Any Spending/Svaing goals? ")
                    
                    RoundedRectangle(cornerRadius: 40)
                        .fill(white2)
                        .frame(width: 320, height: 40)
                        .overlay(content: {
                            TextField("Speding/Saving Budget", text: $SavingGoal)
                                .padding()
                        })
                }
                    
            })
        
        RoundedRectangle(cornerRadius: 30)
            .fill(white)
            .frame(width: 370, height: 120)
            .overlay(content: {
                VStack {
                    Text("Any prefered stocks? ")
                    
                    RoundedRectangle(cornerRadius: 40)
                        .fill(white2)
                        .frame(width: 320, height: 40)
                        .overlay(content: {
                            TextField("Stock ticket", text: $Pref_stock)
                                .padding()
                        })
                }
                    
            })
            
        
        Button(action: {
            first_open.toggle()
        }, label: {
            Text("Continue to Home")
        })
        .frame(width: 170, height: 50)
        .background(white)
        .foregroundColor(black)
        .cornerRadius(40)
    }
}


#Preview {
    Ini_Setup()
}
