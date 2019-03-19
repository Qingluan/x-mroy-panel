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
    var updateService = Services(schedulerName: "updateCmds", reapeat: 3)
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
        
    }
    
    @objc func tableViewDoubleAction() {
        let i = tableView.clickedRow
        let name = self.ta_[i].name
        self.ta_.remove(at: i)
        Command.removeByName(name: name)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
            
            
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
        if RunCommand(cmd: ta_[row].cmd).if_running(){
            let pstyle = NSMutableParagraphStyle()
            pstyle.alignment = .center
            result.startBtn.attributedTitle = NSAttributedString(
                string: "✓",
                attributes: [ NSAttributedString.Key.foregroundColor : NSColor.green, NSAttributedString.Key.paragraphStyle : pstyle ])
            
        }else{
            result.startBtn.title = "x"
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
        let cmd = self.cmdString.stringValue
        let r = RunCommand(cmd: cmd)
        if r.if_running(){
            r.if_running(kill: true)
            startBtn.title = "X"
            
        }else{
            
            DispatchQueue.global().async {
                let r = RunCommand(cmd: cmd)
                r.run()
            }
            
            if r.if_running(){
                let pstyle = NSMutableParagraphStyle()
                pstyle.alignment = .center
                startBtn.attributedTitle = NSAttributedString(
                    string: "✓",
                    attributes: [ NSAttributedString.Key.foregroundColor : NSColor.green, NSAttributedString.Key.paragraphStyle : pstyle ])
            }
            
        }
        
        
        
        
    }
    
}
