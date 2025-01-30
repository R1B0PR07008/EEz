import SwiftUI

@available(iOS 17.0, *)
@main
struct MyApp: App {
	
	@AppStorage("first_open") var first_open : Bool = true
	
    var body: some Scene {
        WindowGroup {
            if !first_open {
				withAnimation {
					tabView()
				}
			}
			else if first_open {
				withAnimation {
					IniView()
				}
			}
        }
    }
}
