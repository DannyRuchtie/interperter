import SwiftUI

struct ContentView: View {
    @State private var inputText = ""

    var body: some View {
        VStack {
            TextField("Enter text", text: $inputText)
                .padding()

            Button("Send") {
                sendInputToMac(inputText)
            }
            .padding()
        }
    }

    func sendInputToMac(_ text: String) {
        guard let url = URL(string: "http://127.0.0.1:10001") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: Any] = ["text": text] // Change 'input' to 'text'
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                // Handle the response from your Mac
                print(String(data: data, encoding: .utf8) ?? "")
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
            DispatchQueue.main.async {
                self.inputText = "" // Clear the input field
            }
        }.resume()

    }
}
