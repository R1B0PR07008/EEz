import SwiftUI

@main
struct MyApp: App {
	
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
