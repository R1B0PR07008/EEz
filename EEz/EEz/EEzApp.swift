//
//  EEzApp.swift
//  EEz
//
//  Created by Riboldi  on 07/11/24.
//

import SwiftUI



// initial setup condition
@main
struct EEzApp: App {
    
    @AppStorage("first_open") var first_open : Bool = true
    
    var body: some Scene {
        WindowGroup {
            if first_open {
                welcomeView()
            } else if !first_open {
                ViewMain()
            }
        }
    }
}
