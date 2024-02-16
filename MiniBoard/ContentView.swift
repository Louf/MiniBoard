//
//  ContentView.swift
//  MiniBoard
//
//  Created by Louis Farmer on 1/24/24.
//

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
