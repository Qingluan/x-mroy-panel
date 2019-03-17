//
//  TestCmdController.swift
//  Panel
//
//  Created by dark.h on 2019/3/17.
//  Copyright © 2019 dr. All rights reserved.
//

import Cocoa

class TestCmdController: NSViewController,NSTextFieldDelegate {

    @IBOutlet var testCmdText: NSTextField!
    var showVc:ShowViewController? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        testCmdText.delegate = self
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            // Do something against ENTER key
            let s:String = testCmdText.stringValue
            if s.count > 1{
                showVc?.showcmd.stringValue = s
            }
            return true
        }
        return false
    }
}
