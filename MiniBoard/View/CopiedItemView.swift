//
//  CopiedItemView.swift
//  MiniBoard
//
//  Created by Louis Farmer on 1/27/24.
//

import Foundation
import SwiftUI

struct CopiedItemView: View {
    
    let item: ClipboardItem
    
    let pasteboard: NSPasteboard = .general
    
    var isImage: Bool {
        return !(item.image == nil)
    }
    
    @State private var textLines: Int = 1
    
    var body: some View {
        VStack(alignment: .leading) {
            if isImage {
                if let img = item.image, let imageData = item.imageData  {
                    Image(nsImage: img)
                        .resizable()                    // Make the image resizable
                        .aspectRatio(contentMode: .fit) // Preserve aspect ratio and fit within the frame
                    
                    Spacer()
                    
                    HStack {
                        Text("\(Int(img.size.width)) x \(Int(img.size.height))")
                        
                        Spacer()
                        
                        Button {
                            pasteboard.clearContents()
                            pasteboard.setData(img.tiffRepresentation, forType: .tiff)
                        } label: {
                            Text("Copy")
                        }
                        
                        Spacer()
                        
                        Text("\(formatBytes(imageData.count))")
                    }
                }
                
                //MAKE IT SO THAT IT SHOWS THE SIZE OF THE IMAGE (e.g. 600x400) AND THE FILE SIZE OF THE IMAGE
            } else {
                ScrollView {
                    Text(item.text)
                        .textSelection(.enabled)
                }
                
                Spacer()
                
                HStack {
                    if textLines > 1 {
                        Text("\(textLines) lines")
                    } else {
                        Text("\(textLines) line")
                    }
                    
                    Spacer()
                    
                    Button {
                        pasteboard.clearContents()
                        pasteboard.setString(item.text, forType: .string)
                    } label: {
                        Text("Copy")
                    }
                    
                    Spacer()
                    
                    Text("\(item.text.count) characters")
                }
                
                Text("Copied \(timeSince(item.date))")
                    .padding(.top, 6)
            }
            
        }
        .onAppear {
            textLines = numLines(text: item.text)
        }
        .onChange(of: item) { oldValue, newValue in
            textLines = numLines(text: newValue.text)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .background(.ultraThinMaterial)
    }
    
    func numLines(text: String) -> Int {
        let ns = text as NSString
        var count = 0
        ns.enumerateLines { (str, _) in
            count += 1
        }
        return count
    }
    
    func formatBytes(_ bytes: Int) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useKB, .useMB, .useGB] // Allow KB, MB, and GB
        formatter.countStyle = .file                     // Use file size formatting
        return formatter.string(fromByteCount: Int64(bytes))
    }
    
    func timeSince(_ date: Date) -> String {
        let now = Date()
        let interval = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date, to: now)
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year) year ago" : "\(year) years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month) month ago" : "\(month) months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day) day ago" : "\(day) days ago"
        } else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour) hour ago" : "\(hour) hours ago"
        } else if let minute = interval.minute, minute > 0 {
            return minute == 1 ? "\(minute) minute ago" : "\(minute) minutes ago"
        } else if let second = interval.second, second > 0 {
            return second == 1 ? "just now" : "\(second) seconds ago"
        } else {
            return "just now"
        }
    }
}
