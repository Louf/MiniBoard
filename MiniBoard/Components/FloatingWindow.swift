//
//  FloatingWindow.swift
//  MiniBoard
//
//  Created by Louis Farmer on 1/27/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    func floatingWindow<Content: View>(position: CGPoint, show: Binding<Bool>, @ViewBuilder content: @escaping ()->Content)->some View{
        self.modifier(FloatingWindowModifier(windowView: content(), position: position, show: show))
    }
}

fileprivate struct FloatingWindowModifier<WindowView: View>: ViewModifier {
    var windowView: WindowView
    var position: CGPoint
    @Binding var show: Bool
    @State private var panel: FloatingPanelHelper<WindowView>?
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                //Creating and storing panel for future view updates
                panel = FloatingPanelHelper(position: position, show: $show, content: {
                    windowView
                })
            }
            .onChange(of: show) { oldValue, newValue in
                //Whenever show is toggled, present the floating panel
                if newValue {
                    panel?.orderFront(nil)
                    panel?.makeKey()
                } else {
                    panel?.close()
                }
            }
    }
}

class FloatingPanelHelper<Content: View>: NSPanel {
    @Binding private var show: Bool
    
    init(position: CGPoint, show: Binding<Bool>, @ViewBuilder content: @escaping ()->Content) {
        self._show = show
        super.init(contentRect: NSRect(x: position.x, y: position.y, width: 300, height: 400), styleMask: [.closable, .fullSizeContentView, .nonactivatingPanel], backing: .buffered, defer: false)
        
        isFloatingPanel = true
        level = .floating
        titleVisibility = .hidden
        titlebarAppearsTransparent = true
        
        backgroundColor = .clear
        
        //Set this to false for now, check behaviour and maybe change after
        isMovableByWindowBackground = false
        
        level = .floating //Bring it to the foreground
        
        //Removing traffic buttons
        standardWindowButton(.closeButton)?.isHidden = true
        standardWindowButton(.miniaturizeButton)?.isHidden = true
        standardWindowButton(.zoomButton)?.isHidden = true
        
        contentView = NSHostingView(rootView: content())
    }
}
