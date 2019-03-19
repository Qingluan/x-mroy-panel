//
//  ShowCommandsViewController.swift
//  Panel
//
//  Created by dark.h on 2019/3/17.
//  Copyright © 2019 dr. All rights reserved.
//

import Cocoa

class ShowCommandsViewController: NSViewController {
    var ta_ = [Command]()
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    var updateService = Services(schedulerName: "updateCmds", reapeat: 10)
    @IBOutlet weak var tableView:NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.ta_ = Command.load()
        
        self.tableView.target = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.doubleAction  = #selector(tableViewDoubleAction)
        
        updateService.run {[weak self] in
            self?.ta_ = Command.load()
            print("repeat run tableview")
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                
            }
        }
//
    }
    
    @objc func tableViewDoubleAction() {
        let i = tableView.clickedRow
        let name = self.ta_[i].name
        let cmd = self.ta_[i].cmd
        
        self.ta_.remove(at: i)
        Command.removeByName(name: name)
        if RunCommand.testCmd(cmd: cmd, kill: true){
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
                
            }
        }
        print("remove one")
    }
    
    
}


extension ShowCommandsViewController:NSTableViewDataSource, NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return ta_.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        let result:KSTableCellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "renderCell"), owner: self) as! KSTableCellView
        result.cmdName.stringValue = ta_[row].name
        DispatchQueue.global().async { [weak result, weak self] in
            if RunCommand.testCmd(cmd: (self?.ta_[row].cmd)! ){
                let pstyle = NSMutableParagraphStyle()
                pstyle.alignment = .center
                result?.startBtn.attributedTitle = NSAttributedString(
                    string: "✓",
                    attributes: [ NSAttributedString.Key.foregroundColor : NSColor.green, NSAttributedString.Key.paragraphStyle : pstyle ])
                
            }else{
                result?.startBtn.title = "x"
            }
            

        }
        result.cmdString.stringValue = ta_[row].cmd
        
        
        return result;
    }
    
    
    
    
    
}






class KSTableCellView: NSTableCellView {
    
    @IBOutlet weak var startBtn: NSButton!
    @IBOutlet weak var cmdName: NSTextField!
    @IBOutlet weak var cmdString: NSTextField!
    @IBAction func runOrOff(_ sender: Any) {
        
        DispatchQueue.global().async { [weak self] in
            
            let cmd = self?.cmdString.stringValue
            
            if RunCommand.testCmd(cmd: cmd!){
                if RunCommand.testCmd(cmd: cmd!, kill: true){
                    DispatchQueue.main.async {[weak self] in
                        self?.startBtn.title = "X"
                    }
                }
                
            }else{
            
                DispatchQueue.global().async {
                    RunCommand(cmd: cmd!).run()
                }
                DispatchQueue.main.async {[weak self] in
                    let pstyle = NSMutableParagraphStyle()
                    pstyle.alignment = .center
                    self?.startBtn.attributedTitle = NSAttributedString(
                        string: "✓",
                        attributes: [ NSAttributedString.Key.foregroundColor : NSColor.green, NSAttributedString.Key.paragraphStyle : pstyle ])
                }
                
            }
            
            
        }
        
        
        
        
        
    }
    
}
