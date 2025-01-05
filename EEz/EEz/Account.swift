//
//  Account.swift
//  EEz
//
//  Created by Riboldi  on 29/12/24.
//

import SwiftUI

struct Account: View {
    
    /// vars
    @AppStorage("weekly") var weekly: Bool = false
    @AppStorage("Notifications") var Notifications: Bool = false
    @AppStorage("Ai_tools") var Ai_tools: Bool = true
    
    @AppStorage("SavingGoal") var SavingGoal : String = ""
    @AppStorage("Pref_stock") var Pref_stock : String = ""
    
    /// Make stocks optional
    
    func OPT_Stocks() {
        if Pref_stock == "" {
            UserDefaults.standard.set(false, forKey: "Stocks_questionMark")
            UserDefaults.standard.set(false, forKey: "ModularSmallRectangle")
        }
        else {
            UserDefaults.standard.set(true, forKey: "Stocks_questionMark")
        }
    }
    
    var body: some View {
        Text("Account Settings")
            .font(.system(size: 25, weight: .semibold))
        
        RoundedRectangle(cornerRadius: 20)
            .fill(white)
            .frame(width: 370, height: 140)
            .overlay(
                HStack {
                    VStack (alignment: .leading) {
                        Text("Name and Last Name")
                            .font(.system(size: 20, weight: .semibold))
                        
                        Text("Email")
                            
                    }
                    Spacer()
                    
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 90, height: 90)
                }
                    .padding(.horizontal, 20)
            )
            .padding(.bottom, 10)
        
        VStack (alignment: .leading) {
            
                // Weekly or monthly
                Toggle(isOn: $weekly, label: { Text("Weekly") })
                    .padding(.horizontal, 30)
                    .foregroundColor(black)
                Text("Would you like to measure your expenses weekly or monthly?")
                    .font(.system(size: 14))
                    .fontWeight(.light)
                    .padding(.horizontal, 30)
                    .foregroundColor(black)
                    .frame(width: 350)
                
                // notifications
                Toggle("Notifications", isOn: $Notifications)
                    .padding(.horizontal, 30)
                    .foregroundColor(black)
                Text("Would you like to get notifications from this app?")
                    .font(.system(size: 14))
                    .fontWeight(.light)
                    .padding(.horizontal, 30)
                    .foregroundColor(black)
                    .frame(width: 350)
                
                // Ai tools
                Toggle("AI Tools", isOn: $Ai_tools)
                    .padding(.horizontal, 30)
                    .foregroundColor(black)
                Text("Would you like to use AI tools to help you manage your expenses?")
                    .font(.system(size: 14))
                    .fontWeight(.light)
                    .padding(.horizontal, 30)
                    .foregroundColor(black)
                    .frame(width: 350)
        }
        .padding(.bottom, 20)
        
        RoundedRectangle(cornerRadius: 20)
            .fill(white)
            .frame(width: 370, height:80)
            .overlay(content: {
                HStack {
                    Text("Saving/Spending Budget:")
                        .foregroundColor(black)
                    
                    RoundedRectangle(cornerRadius: 40)
                        .fill(white2)
                        .frame(width: 120, height: 40)
                        .overlay(content: {
                            TextField("$1,234", text: $SavingGoal)
                                .padding()
                        })
                    
                }
                .padding(.horizontal, 20)
            })
            .padding(.bottom, 10)
        
        RoundedRectangle(cornerRadius: 20)
            .fill(white)
            .frame(width: 370, height:80)
            .overlay(content: {
                HStack {
                    Text("Prefered Stock:")
                        .foregroundColor(black)
                    
                    RoundedRectangle(cornerRadius: 40)
                        .fill(white2)
                        .frame(width: 180, height: 40)
                        .overlay(content: {
                            TextField("Stock Ticket", text: $Pref_stock)
                                .padding()
                        })
                        .onSubmit {
                            OPT_Stocks()
                        }
                    
                }
                .padding(.horizontal, 20)
            })
    }
}

#Preview {
    Account()
}
