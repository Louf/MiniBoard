import SwiftUI
import AppKit

struct ContentView: View {
    
    @State private var eventMonitor: Any?
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}
