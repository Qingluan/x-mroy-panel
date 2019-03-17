//
//  CommandViewController.swift
//  Panel
//
//  Created by dark.h on 2019/3/17.
//  Copyright © 2019 dr. All rights reserved.
//

import Cocoa

class CommandViewController: NSSplitViewController {
    @IBOutlet weak var showView: NSSplitViewItem!
    @IBOutlet weak var cmdView: NSSplitViewItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        if let showVc = showView.viewController as? ShowViewController
        {
            if let cmdVc = cmdView.viewController as? TestCmdController
            {
                cmdVc.showVc = showVc
            }
        }
    }
    
}
