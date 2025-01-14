//
//  billChart.swift
//  EEz
//
//  Created by Riboldi  on 07/11/24.
//

import SwiftUI
import Charts
import Alamofire

/// API vars
let header : HTTPHeaders = [
	"Authorization": "Bearer brand__3ZaBa85tGcY9wxJuj5m5FXU6"
]

/// "cookie" vars

var cookie : String!

/// data strcture

struct bills_data : Identifiable {
	let id: UUID
	let category: String
	struct data : Identifiable {
		let id: UUID
		let month: String
		let value: Double
		let budget: Double
	}
}

struct graph: View {
    
    let monthly_data = [
            ("1", 12343, 23353),
            ("2", 12332, 23343),
            ("3", 23324, 34334),
            ("4", 23455, 34465),
            ("5", 45675, 55685),
            ("6", 13456, 24466),
        ]
    
    var body: some View {
		VStack {
			Chart {
				ForEach(monthly_data, id: \.0) { month, value, budget in
					AreaMark(
							x: .value("Month", month),
							y: .value("Spent", budget)
						)
					.foregroundStyle(
						LinearGradient (
							gradient: Gradient(colors: [green,green.opacity(0.1)]),
							startPoint: .top,
							endPoint: .bottom
						))
					
					LineMark(
						x: .value("Month", month),
						y: .value("Sales", value)
					)
					.foregroundStyle(red)
					
				}
			}.frame(width:180, height: 150)
			
			// X-Axis Stuff
			.chartXAxis {
				AxisMarks(values: .automatic) { _ in
				AxisGridLine()
				AxisTick()
				AxisValueLabel()
						.font(.system(size: 6, weight: .medium, design: .rounded)) // X-axis label font
				}
			}
			
			.chartXAxisLabel("Month")
			.chartYAxisLabel("$ (USD)")
			
			// Y-Axis Stuff
			.chartYAxis {
				AxisMarks(values: .automatic) { _ in
					AxisGridLine()
					AxisTick()
					AxisValueLabel()
						.font(.system(size: 7, weight: .medium, design: .rounded)) // Y-axis label font
				}
			}
			
			HStack(spacing: 6) {
				
				Circle()
					.fill(red)
					.frame(width: 8, height: 8)
				
				Text("Spent")
					.font(.system(size: 14))
				
				Circle()
					.fill(green)
					.frame(width: 8, height: 8)
				
				Text("Budget")
					.font(.system(size: 14))
				
			}
		}
    }
}

struct billChart: View {
	
	/// API Stuff

//	let responce = AF.request("https://api.brand.dev/v1/brand/retrieve?domain=apple.com", headers: header).responseJSON { response in
//		switch response.result {
//	 case .success(let value):
//		 print("Response JSON: \(value)")
//	 case .failure(let error):
//		 print("Error: \(error.localizedDescription)")
//	 }
//	}
	
	/* Responce:
	 
	 Response JSON: {
		 brand =     {
			 address =         {
				 city = Cupertino;
				 country = "UNITED STATES";
				 "country_code" = US;
				 "postal_code" = 95014;
				 "state_code" = CA;
				 "state_province" = California;
				 street = "1 Apple Park Way";
			 };
			 backdrops =         (
							 {
					 colors =                 (
											 {
							 hex = "#2f9ae9";
							 name = "Rockman Blue";
						 },
											 {
							 hex = "#1b0f22";
							 name = "Me\U0161ki Black";
						 },
											 {
							 hex = "#ce7395";
							 name = "Devilish Diva";
						 }
					 );
					 resolution =                 {
						 height = 500;
						 width = 1500;
					 };
					 url = "https://media.brand.dev/cf513e23-91e6-42b0-b393-3436ee1df1f1.jpg";
				 },
							 {
					 colors =                 (
											 {
							 hex = "#dbc095";
							 name = "Bananas Foster";
						 },
											 {
							 hex = "#71624e";
							 name = "Reed Mace Brown";
						 },
											 {
							 hex = "#d1d6de";
							 name = "Twinkle Blue";
						 }
					 );
					 resolution =                 {
						 height = 191;
						 width = 1128;
					 };
					 url = "https://media.brand.dev/d68e4528-f83f-4be8-856b-5c9ca33129e4.jpg";
				 }
			 );
			 colors =         (
							 {
					 hex = "#7c7c7c";
					 name = "Namara Grey";
				 },
							 {
					 hex = "#050505";
					 name = "Black Metal";
				 },
							 {
					 hex = "#cacaca";
					 name = Leadbelcher;
				 }
			 );
			 description = "Apple is a leading global corporation specializing in the design, manufacturing, and marketing of consumer electronics, personal computers, and software. With a diverse team of innovative thinkers and doers, Apple continually seeks to redefine possibilities, enabling users to engage with technology in transformative ways. The company's commitment to innovation is matched by its dedication to sustainability and making a positive impact on the world. Apple offers a wide range of products, including the iPhone, iPad, Apple Watch, Mac, and Apple TV, along with a variety of accessories and expert support. As an equal opportunity employer, Apple values inclusion and diversity within its workforce and encourages individuals to join them in their mission to enhance everyday life through technology.";
			 domain = "apple.com";
			 fonts =         (
							 {
					 name = "SF Pro TC";
					 usage = title;
				 },
							 {
					 name = "SF Pro TC";
					 usage = body;
				 },
							 {
					 name = "SF Pro TC";
					 usage = button;
				 }
			 );
			 logos =         (
							 {
					 colors =                 (
											 {
							 hex = "#7c7c7c";
							 name = "Namara Grey";
						 },
											 {
							 hex = "#050505";
							 name = "Black Metal";
						 },
											 {
							 hex = "#cacaca";
							 name = Leadbelcher;
						 }
					 );
					 group = 1;
					 mode = dark;
					 resolution =                 {
						 height = 48;
						 width = 48;
					 };
					 url = "https://media.brand.dev/280eaf8f-517f-4dfb-99c2-ef23e6c58a74.png";
				 },
							 {
					 colors =                 (
											 {
							 hex = "#848484";
							 name = "Dover Grey";
						 },
											 {
							 hex = "#0f0f0f";
							 name = "Chaos Black";
						 },
											 {
							 hex = "#cecece";
							 name = "American Silver";
						 }
					 );
					 group = 2;
					 mode = dark;
					 resolution =                 {
						 height = 720;
						 width = 720;
					 };
					 url = "https://media.brand.dev/08e2acb0-ff78-4ec1-949e-e01a011958d8.png";
				 },
							 {
					 colors =                 (
											 {
							 hex = "#6eb158";
							 name = "Techno Green";
						 },
											 {
							 hex = "#2e331c";
							 name = "Metal Construction Green";
						 }
					 );
					 group = 3;
					 mode = light;
					 resolution =                 {
						 height = 460;
						 width = 460;
					 };
					 url = "https://media.brand.dev/05b285b8-89e2-401c-8a07-19c1cfa9902f.png";
				 }
			 );
			 slogan = "Reimagining possibilities to help you do what you love.";
			 socials =         (
							 {
					 type = facebook;
					 url = "https://facebook.com/apple";
				 },
							 {
					 type = x;
					 url = "https://x.com/apple";
				 },
							 {
					 type = linkedin;
					 url = "https://linkedin.com/company/apple";
				 },
							 {
					 type = crunchbase;
					 url = "https://crunchbase.com/organization/apple";
				 }
			 );
			 stock =         {
				 exchange = NASDAQ;
				 ticker = AAPL;
			 };
			 title = Apple;
			 verified = 0;
		 };
		 code = 200;
		 status = ok;
	 }
	 Response JSON: {
		 brand =     {
			 address =         {
				 city = Cupertino;
				 country = "UNITED STATES";
				 "country_code" = US;
				 "postal_code" = 95014;
				 "state_code" = CA;
				 "state_province" = California;
				 street = "1 Apple Park Way";
			 };
			 backdrops =         (
							 {
					 colors =                 (
											 {
							 hex = "#2f9ae9";
							 name = "Rockman Blue";
						 },
											 {
							 hex = "#1b0f22";
							 name = "Me\U0161ki Black";
						 },
											 {
							 hex = "#ce7395";
							 name = "Devilish Diva";
						 }
					 );
					 resolution =                 {
						 height = 500;
						 width = 1500;
					 };
					 url = "https://media.brand.dev/cf513e23-91e6-42b0-b393-3436ee1df1f1.jpg";
				 },
							 {
					 colors =                 (
											 {
							 hex = "#dbc095";
							 name = "Bananas Foster";
						 },
											 {
							 hex = "#71624e";
							 name = "Reed Mace Brown";
						 },
											 {
							 hex = "#d1d6de";
							 name = "Twinkle Blue";
						 }
					 );
					 resolution =                 {
						 height = 191;
						 width = 1128;
					 };
					 url = "https://media.brand.dev/d68e4528-f83f-4be8-856b-5c9ca33129e4.jpg";
				 }
			 );
			 colors =         (
							 {
					 hex = "#7c7c7c";
					 name = "Namara Grey";
				 },
							 {
					 hex = "#050505";
					 name = "Black Metal";
				 },
							 {
					 hex = "#cacaca";
					 name = Leadbelcher;
				 }
			 );
			 description = "Apple is a leading global corporation specializing in the design, manufacturing, and marketing of consumer electronics, personal computers, and software. With a diverse team of innovative thinkers and doers, Apple continually seeks to redefine possibilities, enabling users to engage with technology in transformative ways. The company's commitment to innovation is matched by its dedication to sustainability and making a positive impact on the world. Apple offers a wide range of products, including the iPhone, iPad, Apple Watch, Mac, and Apple TV, along with a variety of accessories and expert support. As an equal opportunity employer, Apple values inclusion and diversity within its workforce and encourages individuals to join them in their mission to enhance everyday life through technology.";
			 domain = "apple.com";
			 fonts =         (
							 {
					 name = "SF Pro TC";
					 usage = title;
				 },
							 {
					 name = "SF Pro TC";
					 usage = body;
				 },
							 {
					 name = "SF Pro TC";
					 usage = button;
				 }
			 );
			 logos =         (
							 {
					 colors =                 (
											 {
							 hex = "#7c7c7c";
							 name = "Namara Grey";
						 },
											 {
							 hex = "#050505";
							 name = "Black Metal";
						 },
											 {
							 hex = "#cacaca";
							 name = Leadbelcher;
						 }
					 );
					 group = 1;
					 mode = dark;
					 resolution =                 {
						 height = 48;
						 width = 48;
					 };
					 url = "https://media.brand.dev/280eaf8f-517f-4dfb-99c2-ef23e6c58a74.png";
				 },
							 {
					 colors =                 (
											 {
							 hex = "#848484";
							 name = "Dover Grey";
						 },
											 {
							 hex = "#0f0f0f";
							 name = "Chaos Black";
						 },
											 {
							 hex = "#cecece";
							 name = "American Silver";
						 }
					 );
					 group = 2;
					 mode = dark;
					 resolution =                 {
						 height = 720;
						 width = 720;
					 };
					 url = "https://media.brand.dev/08e2acb0-ff78-4ec1-949e-e01a011958d8.png";
				 },
							 {
					 colors =                 (
											 {
							 hex = "#6eb158";
							 name = "Techno Green";
						 },
											 {
							 hex = "#2e331c";
							 name = "Metal Construction Green";
						 }
					 );
					 group = 3;
					 mode = light;
					 resolution =                 {
						 height = 460;
						 width = 460;
					 };
					 url = "https://media.brand.dev/05b285b8-89e2-401c-8a07-19c1cfa9902f.png";
				 }
			 );
			 slogan = "Reimagining possibilities to help you do what you love.";
			 socials =         (
							 {
					 type = facebook;
					 url = "https://facebook.com/apple";
				 },
							 {
					 type = x;
					 url = "https://x.com/apple";
				 },
							 {
					 type = linkedin;
					 url = "https://linkedin.com/company/apple";
				 },
							 {
					 type = crunchbase;
					 url = "https://crunchbase.com/organization/apple";
				 }
			 );
			 stock =         {
				 exchange = NASDAQ;
				 ticker = AAPL;
			 };
			 title = Apple;
			 verified = 0;
		 };
		 code = 200;
		 status = ok;
	 }
	 */
    
    var body: some View {
		Text("Bills Sorted By Category")
			.font(.system(size: 20, weight: .semibold))
			.padding(.bottom, 15)
		
		NavigationView(content: {
			ScrollView(Axis.Set.vertical) {
				VStack(alignment: .leading) {
					
					NavigationLink(destination: bills_inDepth(), label: {
						RoundedRectangle(cornerRadius: 25)
							.fill(white)
							.frame(width: 370,height: 200)
							.overlay(
								HStack(alignment: .center) {
									VStack {
										Text("Gas")
											.font(.system(size: 20, weight: .semibold))
										
										RoundedRectangle(cornerRadius: 30)
											.fill(white2)
											.frame(width: 100,height: 50)
											.overlay(
												Text("$1,923")
													.font(.system(size: 20, weight: .semibold))
											)
									}.frame(width: 130)
									
									Divider().frame(width: 1, height: 160).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
									
									graph()
									
									
									
								}
							)
					})
					.foregroundStyle(black)
					.simultaneousGesture(TapGesture().onEnded({
						cookie = "gas"
					}))
					
					
					NavigationLink(destination: bills_inDepth(), label: {
						RoundedRectangle(cornerRadius: 25)
							.fill(white)
							.frame(width: 370,height: 200)
							.overlay(
								HStack(alignment: .center) {
									VStack {
										Text("Super Market")
											.font(.system(size: 20, weight: .semibold))
										
										RoundedRectangle(cornerRadius: 30)
											.fill(white2)
											.frame(width: 100,height: 50)
											.overlay(
												Text("$1,923")
													.font(.system(size: 20, weight: .semibold))
											)
									}.frame(width: 130)
									
									Divider().frame(width: 1, height: 160).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
									
									graph()
									
								}
							
							)
					})
					.foregroundStyle(black)
					.simultaneousGesture(TapGesture().onEnded({
						cookie = "super_market"
					}))
					
					
					NavigationLink(destination: bills_inDepth(), label: {
						RoundedRectangle(cornerRadius: 25)
							.fill(white)
							.frame(width: 370,height: 200)
							.overlay(
								HStack(alignment: .center) {
									VStack {
										Text("Fast Food")
											.font(.system(size: 20, weight: .semibold))
										
										RoundedRectangle(cornerRadius: 30)
											.fill(white2)
											.frame(width: 100,height: 50)
											.overlay(
												Text("$1,923")
													.font(.system(size: 20, weight: .semibold))
											)
									}.frame(width: 130)
									
									Divider().frame(width: 1, height: 160).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
									
									graph()
									
								}
							)
					})
					.foregroundStyle(black)
					.simultaneousGesture(TapGesture().onEnded({
						cookie = "fast_food"
					}))
					
					
					NavigationLink(destination: bills_inDepth(), label: {
						RoundedRectangle(cornerRadius: 25)
							.fill(white)
							.frame(width: 370,height: 200)
							.overlay(
								HStack(alignment: .center) {
									VStack {
										Text("Insurance")
											.font(.system(size: 20, weight: .semibold))
										
										RoundedRectangle(cornerRadius: 30)
											.fill(white2)
											.frame(width: 100,height: 50)
											.overlay(
												Text("$1,923")
													.font(.system(size: 20, weight: .semibold))
											)
									}.frame(width: 130)
									
									Divider().frame(width: 1, height: 160).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
									
									graph()
									
								}
							)
					})
					.foregroundStyle(black)
					.simultaneousGesture(TapGesture().onEnded({
						cookie = "insurance"
					}))

					
					NavigationLink(destination: bills_inDepth(), label: {
						RoundedRectangle(cornerRadius: 25)
							.fill(white)
							.frame(width: 370,height: 200)
							.overlay(
								HStack(alignment: .center) {
									VStack {
										Text("Subscriptions")
											.font(.system(size: 20, weight: .semibold))
										
										RoundedRectangle(cornerRadius: 30)
											.fill(white2)
											.frame(width: 100,height: 50)
											.overlay(
												Text("$1,923")
													.font(.system(size: 20, weight: .semibold))
											)
									}.frame(width: 130)
									
									Divider().frame(width: 1, height: 160).overlay(Color(red: 176/255, green: 216/255, blue: 212/255)) /// adjust this color!!!
									
									graph()
									
								}
							)
					})
					.foregroundStyle(black)
					.simultaneousGesture(TapGesture().onEnded({
						cookie = "subscriptions"
					}))
					
					
				}
			}
		})
    }
}

#Preview {
    billChart()
}
