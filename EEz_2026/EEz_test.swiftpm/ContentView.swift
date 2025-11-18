import SwiftUI
import Vision

func red_text() {
	guard let cgImage = UIImage(named: "snapshot")?.cgImage else { return }
	
	let requestHandler = VNImageRequestHandler(cgImage: cgImage)
	
	let request = VNRecognizeTextRequest(completionHandler: recognizeTextHandler)
	
	do {
		// Perform the text-recognition request.
		try requestHandler.perform([request])
	} catch {
		print("Unable to perform the requests: \(error).")
	}
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("IMAGE TEXT RECOGTINTION TEST")
			
			
			
        }
    }
}
