//
//  RunCommand.swift
//  Panel
//
//  Created by dark.h on 2019/3/17.
//  Copyright © 2019 dr. All rights reserved.
//

import Cocoa
import Foundation

protocol CommandExecuting {
    func execute(commandName: String) -> String?
//    func executePip(commandName: String) -> Pipe?
    func executePip(command: String, arguments: [String])  -> Pipe?
    func execute(commandName: String, arguments: [String]) -> String?
    func chains(from:Pipe, cmd:String) -> String?
    func  ChainsPip(from:Pipe, cmd:String) -> Pipe?
}

final class Bash: CommandExecuting {
    
    // MARK: - CommandExecuting
    var HOME = FileManager.default.homeDirectoryForCurrentUser
    let base_command:String
    
    init() {
        base_command = "/bin/bash"
    }
    init(zsh: Bool) {
        if zsh {
            base_command = "/bin/zsh"
        }else{
            base_command = "/bin/bash"
        }
    }
    
    func execute(commandName: String) -> String? {
        return execute(commandName: commandName, arguments: [])
    }
    
    func execute(commandName: String, arguments: [String]) -> String? {
        guard var bashCommand = execute(command: base_command , arguments: ["-l", "-c", "which \(commandName)"]) else{
            return "\(commandName) not found"
        }
        
        bashCommand = bashCommand.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        return execute(command: bashCommand, arguments: arguments)
    }
    
    // MARK: Private
    
    private func execute(command: String, arguments: [String] = [])  -> String? {
        let process = Process()
        process.launchPath = command
        
        process.arguments = arguments
        process.environment = ProcessInfo.processInfo.environment
        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: String.Encoding.utf8)
        return output
    }
    
    func executePip(command: String, arguments: [String] = [])  -> Pipe? {
        guard var bashCommand = execute(command: base_command , arguments: ["-l", "-c", "which \(command)"])else {
            return nil
        }
        bashCommand = bashCommand.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        let process = Process()
        process.launchPath = bashCommand
        
        process.arguments = arguments
        process.environment = ProcessInfo.processInfo.environment
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()
        
        return pipe
        
        
    }
    
    func dealWithParameter(single:String) -> String{
        var HOME = FileManager.default.homeDirectoryForCurrentUser
        if single.starts(with: "~/"){
            let f = String.Index.init(encodedOffset: 2)
            let fs = String(single[f..<single.endIndex])
            HOME.appendPathComponent(fs)
            return HOME.path
        }
        return String(single)
    }
    
    func  ChainsPip(from:Pipe, cmd:String) -> Pipe? {
        let process = Process()
        var cmds = [String]()
        var tmp_string = ""
        var con_mode = false
        for _i in  cmd.split(separator: " "){
            tmp_string += self.dealWithParameter(single: String(_i))
            if _i.starts(with: "'"){
                con_mode = true
            }else if  _i.last == "'"{
                con_mode = false
            }
            
            if _i.starts(with: "{"){
                con_mode = true
            }else if _i.last == "}"{
                con_mode = false
            }
            
            if con_mode{
                tmp_string += " "
                continue
            }
            
            cmds.append(String(tmp_string))
            tmp_string = ""
            
        }
        
        guard var bashCommand = execute(command: base_command , arguments: ["-l", "-c", "which \(cmds[0])"])
            else{
                return nil
        }
        bashCommand = bashCommand.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        let lauch = bashCommand
        let argss = Array(cmds[1..<cmds.count])
        var args = [String]()
        for a in argss{
            args.append(String(a))
        }
        
        print("cmd: \(bashCommand)  \(args.joined(separator: " "))")
        process.launchPath = String(lauch)
        process.environment = ProcessInfo.processInfo.environment
        process.arguments = args
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardInput = from
        process.launch()
        return pipe
    }
    
    func  chains(from:Pipe, cmd:String) -> String?{
//        let pipe = chains(from: from, cmd: cmd)
        if let pipe = self.ChainsPip(from: from, cmd: cmd){
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: String.Encoding.utf8)
            return output
        }
        return nil
        
        
    }
}


class RunCommand {
    let cmd:String
    
    let output_path:String
    
    init(cmd:String) {
        self.cmd = cmd
//        let names = cmd.split(separator: "/")
//        if names.count > 0{
//            self.output_path = "/tmp/\(names[-1]).logs"
//        }else{
            self.output_path = "/tmp/unknow.logs"
//        }
        
    }
    
    init(cmd:String , output_path:String) {
        self.cmd = cmd
        self.output_path = output_path
    }
    
    func run() -> String? {
        let bash: CommandExecuting = Bash()
        var grepPip = Pipe()
        
        for cmd in self.cmd.split(separator: "|"){
            if let _gpip = bash.ChainsPip(from: grepPip, cmd: String(cmd)) {
                grepPip = _gpip
            }else{
                return nil
            }
        }
        
        if let out = String(data: grepPip.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8){
            print("running : \(out)")
            return out
        }
    
        return nil
   
    }
    
    
    func startOrStop() -> Bool{
//        var cmds = [String]()
        let bash: CommandExecuting = Bash()
        var grepPip = Pipe()
        if self.if_running(kill:true){
            return false
        }else{
            for cmd in self.cmd.split(separator: "|"){
                if let _gpip = bash.ChainsPip(from: grepPip, cmd: String(cmd)) {
                    grepPip = _gpip
                }else{
                    return false
                }
            }
            
            if let out = String(data: grepPip.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8){
                print("running : \(out)")
                return true
            }
        }
        
        return false
    }
    
    func if_running (kill:Bool = false) -> Bool{
        let bash: CommandExecuting = Bash()
        let a = ["aux"]
//        var s = [String]()
        if let pipe = bash.executePip(command: "ps", arguments:a){
            
            let cmdargs = self.cmd.split(separator: " ")
            var grepPip = pipe
            for c in cmdargs{
                if c.starts(with: "-"){
                    continue
                }
                if let _gpip = bash.ChainsPip(from: grepPip, cmd: "grep \(String(c))") {
                    grepPip = _gpip
                }else{
                    return false
                }
            }
            if kill{
                if let _g = bash.ChainsPip(from: grepPip, cmd: "awk {print $2} "){
                    if let __g = bash.ChainsPip(from: _g, cmd: "xargs kill -9 "){
                        if let outt = String(data: __g.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8){
                            print("test: \(outt)")
                            return true
                        }
//                        showPipe(from: __g, pre: "[kill]")
                        
                    }
                }
                
            }else{
                if let outt = String(data: grepPip.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8){
    //                showPipe(from: _gpip, pre: "[grep]")
                    
                    return true
                }
            }
        }
        return false
    }
    
    func showPipe(from:Pipe, pre:String){
        let ss = String(data: from.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8)
        print("\(pre):\(ss)")
    }
}
