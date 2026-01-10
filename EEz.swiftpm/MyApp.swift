import SwiftUI
import CryptoKit

@available(iOS 17.0, *)
@main
struct MyApp: App {
	
	@AppStorage("first_open") var first_open : Bool = true
	
	var body: some Scene {
		WindowGroup {
			if !first_open {
				tabView()  // Make sure this goes directly to tabView
					.previewInterfaceOrientation(.landscapeLeft)
			}
			else if first_open {
				IniView()
					.previewInterfaceOrientation(.landscapeLeft)
			}
		}
	}
}
