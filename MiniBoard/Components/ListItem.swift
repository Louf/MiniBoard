//
//  ListItem.swift
//  MiniBoard
//
//  Created by Louis Farmer on 1/25/24.
//

import SwiftUI

struct ListItem: View {
    let item: ClipboardItem
    let identifier = TextTypeIdentifier()
    @State private var isHovered = false
    @State private var xmarkHovered = false
    
    var onDelete: () -> Void
    
    var body: some View {
        HStack {
            identifier.getIcon(for: item.text)
                .resizable() // Make the icon resizable if needed
                .scaledToFit() // Fit the icon within the given dimensions
                .frame(width: 18, height: 18) // Specify the size of the icon
            Text(item.text.trimmingCharacters(in: .whitespacesAndNewlines))
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            if isHovered {
                Image(systemName: xmarkHovered ? "xmark.circle.fill" : "xmark.circle")
                    .onHover { hover in
                        xmarkHovered = hover
                    }
                    .onTapGesture {
                        onDelete() // Call the delete closure when the "x" is clicked
                    }
            }
        }
        .padding(6)
        .background(isHovered ? Color.gray.opacity(0.2) : Color.clear, in: RoundedRectangle(cornerRadius: 12)) // Change the color as needed
        .onHover { hover in
            isHovered = hover
        }
        
    }
}
