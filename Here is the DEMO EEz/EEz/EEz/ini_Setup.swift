//
//  Ini_Setup.swift
//  EEz
//
//  Created by Riboldi  on 08/11/24.
//

import SwiftUI
import UIKit

struct Ini_Setup: View {

    @AppStorage("weekly") var weekly: Bool = false
    @AppStorage("Notifications") var Notifications: Bool = false
    @AppStorage("Ai_tools") var Ai_tools: Bool = true /// Change this to user default to see if it now miraculosly wants to FUCKING WORk. I FUCKING HATE APPLE. (reading this later = lol)
    @AppStorage("SavingGoal") var SavingGoal : String = ""
    @AppStorage("first_open") var first_open : Bool = true
    @AppStorage("Pref_stock") var Pref_stock : String = "APPL"
    @AppStorage("Stocks_questionMark") var Stocks_questionMark : Bool = true
    
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
        Text("First, we need some info: ")
            .font(.system(size: 25))
            .fontWeight(.bold)
            .foregroundColor(black)
        
        // toggles
        
        RoundedRectangle(cornerRadius: 30)
            .fill(white)
            .frame(width: 370, height: 300)
            .overlay(content: {
                VStack (alignment: .leading) {
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
                    Text("Do You Have Any Spending/Svaing goals?")
                        .padding(.horizontal, 20)
                    
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
            .frame(width: 370, height: 160)
            .overlay(content: {
                VStack {
                    Text("Would you like to follow any specific stock? ")
                        .padding(.horizontal, 20)
                    
                    RoundedRectangle(cornerRadius: 40)
                        .fill(white2)
                        .frame(width: 320, height: 40)
                        .overlay(content: {
                            TextField("Stock ticket", text: $Pref_stock)
                                .padding()
                        }).onSubmit {
                            OPT_Stocks()
                        }
                    HStack {
                        Text("If you don't just leave the text box empty. \nYou can add more later too.")
                            .font(.system(size: 14))
                            .fontWeight(.light)
                            .padding(.horizontal, 30)
                            .foregroundColor(black)
                        
                        Spacer()
                    }
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

struct welcomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                        // Display the app icon
                if let appIcon = UIImage(named: "Logo") {
                    Image(uiImage: appIcon)
                        .resizable() // Allow resizing
                        .frame(width: 230, height: 230) // Set size
                        .clipShape(RoundedRectangle(cornerRadius: 16)) // Optional: Add styling
                        .padding(.top, 250)
                } else {
                    Text("App icon not found!")
                        .foregroundColor(.red)
                }
                
                Spacer()
                
                NavigationLink(destination: Ini_Setup()) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(white)
                        .frame(width: 200, height: 60)
                        .overlay(
                            Text("Welcome!")
                                .font(.system(size: 30, weight: .semibold))
                                .foregroundStyle(black)
                        )
                        
                        
                    
                }
                
            }
            .padding()
        }
    }
}


#Preview {
    welcomeView()
}
