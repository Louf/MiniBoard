//
//  MiniBoardApp.swift
//  MiniBoard
//
//  Created by Louis Farmer on 1/24/24.
//

import SwiftUI
import SwiftData

@main
struct MiniBoardApp: App {
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    let modelContainer: ModelContainer
        
    init() {
        do {
            modelContainer = try ModelContainer(for: ClipboardItem.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        
        MenuBarExtra("", systemImage: "clipboard") {
            ListView()
        }
        .menuBarExtraStyle(.window)
        .modelContainer(modelContainer)
        
    }
}

