import SwiftUI
import SwiftData

struct ListView: View {
    
    @Environment(\.modelContext) private var context
//    @EnvironmentObject var windowInfo: WindowInfo
    
    @Query(sort: \ClipboardItem.date, order: .reverse, animation: .snappy) private var allItems: [ClipboardItem]
    
    let pub = NotificationCenter.default.publisher(for: NSNotification.Name("pasteboardDidChangeNotification"))
    
    @State private var showFloatingWindow: Bool = false

    @State private var width:   CGFloat = 180
    @State private var height:  CGFloat = 300
    
    @State private var searchText: String = ""
    
    @State private var isExpanded: Bool = false
    
    @State private var selectedItem: ClipboardItem = ClipboardItem(text: "", image: NSImage(), date: Date())
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Clipboard")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading) // Ensure the title is left-aligned
                
//                HStack {
//                    Image(systemName: "magnifyingglass")
//                    TextField("Search Clipboard", text: $searchText)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                }
//                .padding(.horizontal)
                

                ScrollView {
                    ForEach(filteredItems) { item in
                        ListItem(item: item){
                            deleteItem(item: item)
                        }
                        .padding(.bottom, 2)// Ensure each text item is left-aligned
                        .onTapGesture {
                            //Do this with nice animation at some point 
                            //Check whether it's already expanded and if it is, just change the text don't close it
                            if !isExpanded {
                                selectedItem = item
                                isExpanded.toggle()
                            } else {
                                if item == selectedItem {
                                    isExpanded.toggle()
                                } else {
                                    selectedItem = item
                                }
                            }
                        }
                        
                    }
                    
                    .onReceive(pub) { (output) in
                        //Now we are going to be able to check what we copied, image, file etc.
                        if let pb = output.object as? NSPasteboard {
                            if let str = pb.string(forType: .string) {
                                if let lastItem = allItems.first, lastItem.text == str {
                                    print("Duplicate text, not adding.")
                                } else {
                                    addItem(text: str)
                                }
                            } // Handle images
                            else if let image = pb.readObjects(forClasses: [NSImage.self], options: nil)?.first as? NSImage {
                                print("Image received")
                                addItem(text: "Image", image: image)
                                // Process the image here
                                // For example, you can add it to an array or display it in the UI
                            }
                            // Handle file URLs
                            else if let fileUrls = pb.readObjects(forClasses: [NSURL.self], options: nil) as? [URL], !fileUrls.isEmpty {
                                for url in fileUrls {
                                    // The `url` variable here is a `URL` object that represents the file URL.
                                    // To get the file path as a string, you can use the `path` property of the `URL` object.
                                    let filePath = url.path // This gives you the complete file path as a string.
                                    print("File URL: \(url)")
                                    print("File Path: \(filePath)")

                                    addItem(text: filePath)
                                }
                            }
                            else {
                                print("Missing or unsupported data type.")
                            }
                        }
                    }
                }
                .padding(.vertical)
                .background(Color.gray.opacity(0.1), in: RoundedRectangle(cornerRadius: 12))
                
                Button {
                    clearItems()
                } label: {
                    Text("Delete all")
                }
            }
            .frame(maxWidth: 180)
            
            if isExpanded {
                CopiedItemView(item: selectedItem)
                    .padding(.leading)
            }
        }
        .frame(width: isExpanded ? 500 : 180, height: height, alignment: .leading) // Set the frame for the entire VStack
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
//        .floatingWindow(position: CGPoint(x: Int(windowInfo.frame.maxX) + 220, y: Int(windowInfo.frame.maxY)), show: $showFloatingWindow) {
//            //This is the content of the floating window i.e. the copied text + line length etc
//            CopiedItemView()
//        }
    }
    
//        .clipShape(RoundedRectangle(cornerRadius: 12))
    
    var filteredItems: [ClipboardItem] {
        if searchText.isEmpty {
            return allItems
        } else {
            return allItems.filter { item in
                item.text.localizedCaseInsensitiveContains(searchText) ||
                (item.image != nil && searchText.localizedCaseInsensitiveContains("Image"))
            }
        }
    }
    
    func addItem(text: String, image: NSImage = NSImage()){
        let item = ClipboardItem(text: text, image: image, date: Date())
        context.insert(item)
    }
    
    func deleteItem(item: ClipboardItem) {
        context.delete(item)
    }

    func clearItems() {
        do {
           try context.delete(model: ClipboardItem.self)
        } catch {
            print("Couldn't delete")
        }
    }
}
