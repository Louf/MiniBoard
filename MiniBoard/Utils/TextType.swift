import Foundation
import SwiftUI

class TextTypeIdentifier {
    
    // Function to determine the type of the given text and return the corresponding icon
    func getIcon(for text: String) -> Image {
        if isURL(text) {
            return Image(systemName: "link") // Using a system icon as an example; replace with your actual icon for URLs
        } else if isFileDirectory(text) {
            return Image(systemName: "folder") // Using a system icon as an example; replace with your actual icon for directories
        } else if isImageFile(text) {
            return Image(systemName: "photo") // Using a system icon as an example; replace with your actual icon for images
        } else {
            return Image(systemName: "doc.plaintext") // Using a system icon as an example; replace with your actual icon for plain text
        }
    }
    
    // Function to check if the text is a URL

    func isURL(_ urlString: String) -> Bool {
        let pattern = #"^((http|https)://)?[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(\/\S*)?$"#
        let regex = try? NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: urlString.utf16.count)
        return regex?.firstMatch(in: urlString, options: [], range: range) != nil
    }
    
    // Function to check if the text is a file directory
    private func isFileDirectory(_ text: String) -> Bool {
        let fileManager = FileManager.default
        var isDir: ObjCBool = false
        if fileManager.fileExists(atPath: text, isDirectory: &isDir) {
            return isDir.boolValue
        }
        return false
    }
    // Function to check if the text is an image file
    private func isImageFile(_ text: String) -> Bool {
        return text == "Image"
    }
}
