//
//  tezt.swift
//  EEz
//
//  Created by Riboldi  on 09/01/26.
//

import SwiftUI

struct CreditScoreEducationView: View {
	
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		HStack(spacing: 15) {
			
			// Left Column
			VStack(spacing: 15) {
				
				// What is a Credit Score?
				RoundedRectangle(cornerRadius: 20)
					.tintedGlassShape(color: white)
					.frame(width: 360, height: 195)
					.overlay(
						VStack(alignment: .leading, spacing: 8) {
							HStack {
								Image(systemName: "questionmark.circle.fill")
									.font(.system(size: 24))
									.foregroundColor(green)
								
								Text("What is a Credit Score?")
									.font(.system(size: 22, weight: .bold))
							}
							
							Text("A three-digit number (300-850) that represents your creditworthiness - how likely you are to repay borrowed money.")
								.font(.system(size: 14))
								.foregroundColor(black)
							
							Text("Lenders, landlords, and employers use it to evaluate your financial responsibility.")
								.font(.system(size: 14))
								.foregroundColor(black)
						}
						.padding(20)
					)
				
				// Credit Score Ranges
				RoundedRectangle(cornerRadius: 20)
					.tintedGlassShape(color: white2)
					.frame(width: 360, height: 215)
					.overlay(
						VStack(alignment: .leading, spacing: 10) {
							HStack {
								Image(systemName: "chart.bar.fill")
									.font(.system(size: 24))
									.foregroundColor(green)
								
								Text("Score Ranges")
									.font(.system(size: 22, weight: .bold))
							}
							
							VStack(spacing: 6) {
								CreditScoreRangeRowCompact(range: "800-850", label: "Exceptional", color: green)
								CreditScoreRangeRowCompact(range: "740-799", label: "Very Good", color: green.opacity(0.7))
								CreditScoreRangeRowCompact(range: "670-739", label: "Good", color: orange.opacity(0.7))
								CreditScoreRangeRowCompact(range: "580-669", label: "Fair", color: orange)
								CreditScoreRangeRowCompact(range: "300-579", label: "Poor", color: red)
							}
						}
						.padding(20)
					)
				
				// Why It Matters
				RoundedRectangle(cornerRadius: 20)
					.tintedGlassShape(color: white)
					.frame(width: 360, height: 210)
					.overlay(
						VStack(alignment: .leading, spacing: 8) {
							HStack {
								Image(systemName: "star.fill")
									.font(.system(size: 24))
									.foregroundColor(green)
								
								Text("Why It Matters")
									.font(.system(size: 22, weight: .bold))
							}
							
							VStack(spacing: 6) {
								WhyItMattersRowCompact(icon: "house.fill", title: "Rent Apartments")
								WhyItMattersRowCompact(icon: "car.fill", title: "Buy Cars (Better Rates)")
								WhyItMattersRowCompact(icon: "creditcard.fill", title: "Premium Credit Cards")
								WhyItMattersRowCompact(icon: "banknote.fill", title: "Lower Interest Rates")
							}
						}
						.padding(20)
					)
			}
			
			// Middle Column
			VStack(spacing: 15) {
				
				// How It's Calculated
				RoundedRectangle(cornerRadius: 20)
					.tintedGlassShape(color: white2)
					.frame(width: 360, height: 310)
					.overlay(
						VStack(alignment: .leading, spacing: 10) {
							HStack {
								Image(systemName: "percent")
									.font(.system(size: 24))
									.foregroundColor(green)
								
								Text("How It's Calculated")
									.font(.system(size: 22, weight: .bold))
							}
							
							Text("Your FICO score factors:")
								.font(.system(size: 14, weight: .semibold))
								.foregroundColor(black)
							
							VStack(spacing: 8) {
								CreditFactorRowCompact(percentage: "35%", title: "Payment History")
								CreditFactorRowCompact(percentage: "30%", title: "Credit Utilization")
								CreditFactorRowCompact(percentage: "15%", title: "Length of History")
								CreditFactorRowCompact(percentage: "10%", title: "Credit Mix")
								CreditFactorRowCompact(percentage: "10%", title: "New Credit")
							}
						}
						.padding(20)
					)
				
				// Common Myths
				RoundedRectangle(cornerRadius: 20)
					.tintedGlassShape(color: white)
					.frame(width: 360, height: 310)
					.overlay(
						VStack(alignment: .leading, spacing: 10) {
							HStack {
								Image(systemName: "exclamationmark.triangle.fill")
									.font(.system(size: 24))
									.foregroundColor(orange)
								
								Text("Common Myths")
									.font(.system(size: 22, weight: .bold))
							}
							
							VStack(alignment: .leading, spacing: 12) {
								VStack(alignment: .leading, spacing: 4) {
									Text("❌ Checking your score hurts it")
										.font(.system(size: 15, weight: .semibold))
										.foregroundColor(black)
									
									Text("Only hard inquiries affect scores. Checking your own is safe.")
										.font(.system(size: 13))
										.foregroundColor(black.opacity(0.8))
								}
								
								VStack(alignment: .leading, spacing: 4) {
									Text("❌ Closing cards improves credit")
										.font(.system(size: 15, weight: .semibold))
										.foregroundColor(black)
									
									Text("Actually hurts your utilization ratio and credit history length.")
										.font(.system(size: 13))
										.foregroundColor(black.opacity(0.8))
								}
								
								VStack(alignment: .leading, spacing: 4) {
									Text("❌ Income affects your score")
										.font(.system(size: 15, weight: .semibold))
										.foregroundColor(black)
									
									Text("Your income isn't included in credit score calculations.")
										.font(.system(size: 13))
										.foregroundColor(black.opacity(0.8))
								}
							}
						}
						.padding(20)
					)
			}
			
			// Right Column
			VStack(spacing: 15) {
				
				// How to Build Credit
				RoundedRectangle(cornerRadius: 20)
					.tintedGlassShape(color: white)
					.frame(width: 360, height: 620)
					.overlay(
						VStack(alignment: .leading, spacing: 10) {
							HStack {
								Image(systemName: "arrow.up.circle.fill")
									.font(.system(size: 24))
									.foregroundColor(green)
								
								Text("How to Build Credit")
									.font(.system(size: 22, weight: .bold))
							}
							
							VStack(spacing: 12) {
								BuildCreditTipCompact(
									number: "1",
									title: "Get a Credit Card",
									description: "Start with a secured or student card."
								)
								
								BuildCreditTipCompact(
									number: "2",
									title: "Pay On Time, Always",
									description: "Set up automatic payments."
								)
								
								BuildCreditTipCompact(
									number: "3",
									title: "Keep Balances Low",
									description: "Use less than 30% of credit limit."
								)
								
								BuildCreditTipCompact(
									number: "4",
									title: "Don't Close Old Cards",
									description: "Length of history matters."
								)
								
								BuildCreditTipCompact(
									number: "5",
									title: "Limit New Applications",
									description: "Too many inquiries hurt scores."
								)
								
								BuildCreditTipCompact(
									number: "6",
									title: "Monitor Your Credit",
									description: "Check for errors regularly."
								)
								
								BuildCreditTipCompact(
									number: "7",
									title: "Diversify Credit Types",
									description: "Mix of cards, loans helps."
								)
							}
						}
						.padding(20)
					)
			}
		}
		.frame(width: 1100, height: 650)
	}
}

// MARK: - Compact Helper Components

struct CreditScoreRangeRowCompact: View {
	let range: String
	let label: String
	let color: Color
	
	var body: some View {
		HStack {
			RoundedRectangle(cornerRadius: 8)
				.fill(color)
				.frame(width: 75, height: 28)
				.overlay(
					Text(range)
						.font(.system(size: 13, weight: .bold))
						.foregroundColor(.white)
				)
			
			Text(label)
				.font(.system(size: 15, weight: .semibold))
				.foregroundColor(black)
			
			Spacer()
		}
	}
}

struct CreditFactorRowCompact: View {
	let percentage: String
	let title: String
	
	var body: some View {
		HStack(spacing: 10) {
			Text(percentage)
				.font(.system(size: 18, weight: .bold))
				.foregroundColor(green)
				.frame(width: 45, alignment: .leading)
			
			Text(title)
				.font(.system(size: 15, weight: .semibold))
				.foregroundColor(black)
			
			Spacer()
		}
	}
}

struct BuildCreditTipCompact: View {
	let number: String
	let title: String
	let description: String
	
	var body: some View {
		HStack(alignment: .top, spacing: 12) {
			ZStack {
				Circle()
					.fill(green)
					.frame(width: 28, height: 28)
				
				Text(number)
					.font(.system(size: 15, weight: .bold))
					.foregroundColor(.white)
			}
			
			VStack(alignment: .leading, spacing: 2) {
				Text(title)
					.font(.system(size: 15, weight: .semibold))
					.foregroundColor(black)
				
				Text(description)
					.font(.system(size: 13))
					.foregroundColor(black.opacity(0.7))
			}
		}
	}
}

struct WhyItMattersRowCompact: View {
	let icon: String
	let title: String
	
	var body: some View {
		HStack(spacing: 10) {
			Image(systemName: icon)
				.font(.system(size: 18))
				.foregroundColor(green)
				.frame(width: 25)
			
			Text(title)
				.font(.system(size: 15, weight: .medium))
				.foregroundColor(black)
			
			Spacer()
		}
	}
}

#Preview(traits: .landscapeLeft) {
	ZStack {
		LinearGradient(
			colors: [
				green.opacity(0.4),
				green2.opacity(0.2),
				Color.white,
				green.opacity(0.5),
				green2.opacity(0.5)
			],
			startPoint: .topLeading,
			endPoint: .bottomTrailing
		)
		.edgesIgnoringSafeArea(.all)
		
		RoundedRectangle(cornerRadius: 20)
			.tintedGlassShape(color: white2)
			.frame(width: 1100, height: 650)
			.overlay(
				CreditScoreEducationView()
			)
	}
}
