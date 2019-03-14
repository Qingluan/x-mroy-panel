//
//  EventMonitor.swift
//  Panel
//
//  Created by dr on 2019/3/14.
//  Copyright © 2019 dr. All rights reserved.
//

import Cocoa

class EventMonitor: NSObject{
    
    private var monitor: AnyObject?
    private let mask: NSEvent.EventTypeMask
    private let handler: (NSEvent?) -> Void
    
    public init(mask: NSEvent.EventTypeMask, handler: @escaping (NSEvent?) -> ()) {
        self.mask = mask
        self.handler = handler
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        monitor = NSEvent.addGlobalMonitorForEvents(matching: mask, handler: handler) as AnyObject
    }
    
    public func stop() {
        if monitor != nil {
            NSEvent.removeMonitor(monitor!)
            monitor = nil
        }
    }
    
}
