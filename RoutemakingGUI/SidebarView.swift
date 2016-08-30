//
//  SidebarView.swift
//  RoutemakingGUI
//
//  Created by Gabriel Uribe on 8/3/16.
//  Copyright © 2016 Gabriel Uribe. All rights reserved.
//

import Cocoa

class SidebarView: NSView {
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    wantsLayer = true
    layer?.backgroundColor = NSColor.grayColor().CGColor
  }

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
    }
}
