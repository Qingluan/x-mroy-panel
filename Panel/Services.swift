//
//  Services.swift
//  Panel
//
//  Created by dr on 2019/3/19.
//  Copyright © 2019 dr. All rights reserved.
//

import Cocoa

class Services {
    
    let activity:NSBackgroundActivityScheduler
    init(schedulerName:String, reapeat:Int = 10) {
        activity = NSBackgroundActivityScheduler(identifier: "com.personal.Panel.\(schedulerName)")
        activity.repeats = true
        activity.interval = TimeInterval(reapeat)
    }
    
    init(schedulerName:String, after:Int = 10) {
        activity = NSBackgroundActivityScheduler(identifier: "com.personal.Panel.\(schedulerName)")
        activity.repeats = false
        activity.tolerance = TimeInterval(after)

    }
    
    func run(handle:@escaping () -> () ){
        activity.schedule() { (completion: NSBackgroundActivityScheduler.CompletionHandler) in
            // Perform the activity
            handle()
            completion(NSBackgroundActivityScheduler.Result.finished)
        }

    }
    
    class func runAsyn(handle:@escaping ()->()) {
//        let helper = DispatchQueue(label:label)
//
        DispatchQueue.global().async {
            handle()
        }
    }
    func stop(){
        return activity.invalidate()
    }

}
