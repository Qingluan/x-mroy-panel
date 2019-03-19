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
    
    @IBAction func if_running(_ sender: Any) {
        let cmd = testCmdText.stringValue
//        if RunCommand(cmd: cmd).if_running(){
//
//        }
        if RunCommand.testCmd(cmd: cmd){
            
        }
    }
    
    func setShowString(text:String ){
        showVc?.showcmd.stringValue = text
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            // Do something against ENTER key
            
            let cmds = testCmdText.stringValue
            if cmds.count > 0{
//                print("-> \(cmds)")
                Services.runAsyn {[weak self] in
                    if let res = RunCommand(cmd: cmds).run(){
                        DispatchQueue.main.async {[weak self] in
                            self?.setShowString(text: res)
                        }
                    }
                }
                
                
            }
            return true
        }
        return false
    }
}
