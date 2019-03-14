//
//  ConfigData.swift
//  Panel
//
//  Created by dr on 2019/3/14.
//  Copyright © 2019 dr. All rights reserved.
//

import Cocoa

class Command {
    let name:String
    let cmd:String
    var output:String = "/tmp/panel.logs"

    
    init (name:String, cmd:String, output:String){
        self.name = name
        self.cmd = cmd
        self.output = output
        
    }
    
    init (name:String, cmd:String){
        self.name = name
        self.cmd = cmd
        self.output = "/tmp/PanelLogs-\(name).log"
        
    }
    
    class func fromJsonFile(path:String) -> [Command]{
        var commands = [Command]()
        print("to finding: \(path)")
        if let path = Bundle.main.path(forResource: path, ofType: "json") {
            print("find file parsing")
            do {
                let fileUrl = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: fileUrl, options: .mappedIfSafe)
//                let data = try? JSONSerialization.jsonObject(with: ddata)
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                print("to \(data)")
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let commandjsons = jsonResult as? Dictionary<String, AnyObject> {
                    // do stuff
                    for (comName,subJson) in commandjsons {
                        // Do something you want
                        print("find \(comName)")
                        if let cmdStr = subJson["cmd"] {
                            let cmdIn =  Command(name: comName, cmd:cmdStr as! String)
                        
                    
                            if let val = subJson["output"] {
                                cmdIn.output = val as! String
                            }
                            
                            commands.append(cmdIn)
                        }
                    }
                }
            } catch let error {
                // handle error
                print(error.localizedDescription)
            }
        }
        
        return commands
    }
}
