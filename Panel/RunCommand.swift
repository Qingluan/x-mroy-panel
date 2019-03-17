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
    func execute(commandName: String, arguments: [String]) -> String?
}

final class Bash: CommandExecuting {
    
    // MARK: - CommandExecuting
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
        guard var bashCommand = execute(command: base_command , arguments: ["-l", "-c", "which \(commandName)"]) else { return "\(commandName) not found" }
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
}


class RunCommand {
    let cmd:String
    
    let output_path:String
    
    init(cmd:String) {
        self.cmd = cmd
        let name = cmd.split(separator: "/")[-1]
        self.output_path = "/tmp/\(name).logs"
    }
    
    init(cmd:String , output_path:String) {
        self.cmd = cmd
        self.output_path = output_path
    }
    
    func run(){
        let bash: CommandExecuting = Bash(zsh: true)
        if let lsOutput = bash.execute(commandName: self.cmd){
            print(lsOutput)
        }
//        let output_from_command = String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8)!
//
//        // remove the trailing new-line char
//        if output_from_command.characters.count > 0 {
//            let lastIndex = output_from_command.index(before: output_from_command.endIndex)
//            return output_from_command[output_from_command.startIndex ..< lastIndex]
//        }
//        return output_from_command
    }
    
    func if_running () -> Bool{
        let bash: CommandExecuting = Bash(zsh: true)
        if let out = bash.execute(commandName: "ps -aux | grep '\(self.cmd)'"){
            print("out: \(out)")
            return true
        }else{
            return false
        }
    }
}
