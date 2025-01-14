//
//  bills_inDepth.swift
//  EEz
//
//  Created by Riboldi  on 14/01/25.
//

import SwiftUI

struct bills_inDepth: View {
    var body: some View {
		VStack {
			RoundedRectangle(cornerRadius: 20)
				.fill(white)
				.frame(width: 370, height: 200)
				.overlay(
					HStack {
						VStack {
							Text("Spent this month")
								.font(.system(size: 20, weight: .semibold))
						}
						
						Divider().frame(width: 1, height: 160).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
						
						

					}
				)
		}
    }
}

#Preview {
    bills_inDepth()
}
