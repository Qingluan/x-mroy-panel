//
//  ViewController.swift
//  Panel
//
//  Created by dr on 2019/3/14.
//  Copyright © 2019 dr. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet var showLabel: NSTextField!
    @IBOutlet var cmdNameInput: NSTextField!
    @IBOutlet var cmdStringInput: NSTextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func saveOrUpdate(_ sender: Any) {
        if cmdNameInput.stringValue.count > 2{
            if cmdStringInput.stringValue.count > 8{
                let command = Command(name:cmdNameInput.stringValue, cmd: cmdStringInput.stringValue)
                command.save()

                showLabel.stringValue = "cmd save success"
            }else{
                showLabel.stringValue = "cmd input can not be empty at least > 8"
            }
        }else{
            showLabel.stringValue = "cmd name can not be empty, at least > 2"
        }
        
    }
    
    @IBAction func if_cmd_exist(_ sender: Any) {
        if cmdNameInput.stringValue.count > 2{
            if Command.containCmd(name: cmdNameInput.stringValue){
                if let cmdOne = Command.loadBy(name:cmdNameInput.stringValue){
                    showLabel.stringValue = "cmd exists"
                    cmdStringInput.stringValue = cmdOne.cmd
                }else{
                    showLabel.stringValue = "cmd do not exists"
                }
                
                
            }else{
                showLabel.stringValue = "empty user data "
            }
        }else{
            showLabel.stringValue = "some error"
        }
    }
}

