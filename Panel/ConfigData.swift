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
    func toDictionary() -> NSDictionary {
        let dictionary: NSDictionary = [
            "cmd" : self.cmd,
            "output" : self.output
        ]
        return dictionary
    }
    
    func save() {
        let defaults = UserDefaults.standard
        var new_cmds = [String]()
        if let cmds:[String] = defaults.stringArray(forKey: "all_cmds"){
            if cmds.contains(self.name){
                new_cmds.append(contentsOf: cmds)
            }else{
                new_cmds.append(self.name)
            }
        }else{
            new_cmds.append(self.name)
        }
        
        defaults.set(new_cmds, forKey:"all_cmds")
        defaults.set( self.toDictionary(), forKey: self.name)
    }
    
    class func containCmd(name:String) -> Bool{
        let defaults = UserDefaults.standard
        
        if let cmds = defaults.stringArray(forKey: "all_cmds"){
            if (cmds.contains(name)){
                return true
            }
        }
        
        return false
    }
    
    class func loadBy(name:String) -> Command? {
        
        let defaults = UserDefaults.standard
        if Command.containCmd(name: name){
            let d:Dictionary<String, String> = defaults.dictionary(forKey: name) as! Dictionary<String, String>
            return Command(name:name, cmd:d["cmd"]!, output:d["output"]!)
        }else{
            return nil
        }
    }
    
    class func load() -> [Command] {
        var cmds = [Command]()
        let defaults = UserDefaults.standard
        let all_cmds:[String] = defaults.stringArray(forKey: "all_cmds")!
        for key in all_cmds{
            let d:Dictionary<String, String> = defaults.dictionary(forKey: key) as! Dictionary<String, String>
            cmds.append(Command(name:key, cmd:d["cmd"]!, output:d["output"]!))
        }
        return cmds
        
    }
    
    class func fromJsonFile(path:String) -> [Command]{
        var commands = [Command]()
        do {
            
            let file = URL(fileURLWithPath: "panel.json")
//                let file = Bundle.main.url(forResource: "panel",  withExtension: "json")
                let data = try Data(contentsOf: file)
//                let data = try Data(contentsOf: URL(fileURLWithPath: file), type
            
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Dictionary<String, Any>] {
                    // json is a dictionary
                    for (cmdName,subJson) in object{
                        print("find \(cmdName)")
                        if let cmdStr = subJson["cmd"] {
                            let cmdIn =  Command(name: cmdName, cmd:cmdStr as! String)
                            
                            if let val = subJson["output"] {
                                cmdIn.output = val as! String
                            }
                            
                            commands.append(cmdIn)
                        }
                        
                    }
                
                } else {
                    print("JSON is invalid")
                }
//            } else {
//                print("no file \(path)")
//            }
        } catch {
            print(error.localizedDescription)
        }
        
        return commands
    }
}
