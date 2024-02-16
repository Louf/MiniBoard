//
//  ClipboardText.swift
//  MiniBoard
//
//  Created by Louis Farmer on 1/24/24.
//

import SwiftUI
import SwiftData

@Model
class ClipboardItem {
    var text: String
    let imageData: Data?
    var date: Date
    
    init(text: String, image: NSImage?, date: Date) {
        self.text = text
        self.imageData = image?.tiffRepresentation // Convert NSImage to Data
        self.date = date
    }

    var image: NSImage? {
        // Convert Data back to NSImage
        guard let imageData = imageData else { return nil }
        return NSImage(data: imageData)
    }
}
