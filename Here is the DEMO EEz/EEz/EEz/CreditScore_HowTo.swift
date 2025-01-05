//
//  CreditScore_HowTo.swift
//  EEz
//
//  Created by Riboldi  on 20/12/24.
//

import SwiftUI

struct CreditScore_HowTo: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(white)
                    .frame(width: 370, height: 250)
                    .overlay(
                        Text("How To Improve Your Credit Score")
                            .font(.system(size: 22, weight: .semibold))
                        
                        
                    )
                
                RoundedRectangle(cornerRadius: 20)
                    .fill(white)
                    .frame(width: 370, height: 250)
                    .overlay(
                        Text("What Is a Credit Score?")
                            .font(.system(size: 22, weight: .semibold))
                        
                        
                    )
            }
        }
    }
}

#Preview {
    CreditScore_HowTo()
}
