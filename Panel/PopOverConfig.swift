//
//  PopOverConfig.swift
//  Panel
//
//  Created by dr on 2019/3/14.
//  Copyright © 2019 dr. All rights reserved.
//

import Cocoa

class PopOverConfig: NSViewController{
    
    var ta_ = [Command]()
    
    
    @IBOutlet weak var tableView:NSTableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        let account1 = Command(name:"Account 1", cmd: "ls -a ");
//        let account2 = Command(name:"Account 2", cmd: "shadowsocks some ... ");
//
//
//        department1.comands.append(account1)
//        department1.comands.append(account2)
//        department2.comands.append(account2)
        self.ta_ = Command.load()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    
    }
    

}



extension PopOverConfig:NSTableViewDataSource, NSTableViewDelegate{
    func numberOfRows(in tableView: NSTableView) -> Int {
        return ta_.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        let result:KSTableCellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "renderCell"), owner: self) as! KSTableCellView
        result.imgView.image = NSImage(named: "icon_dock_mul")
        result.cmdName.stringValue = ta_[row].name
        result.startBtn.stringValue = "Off"
        result.startBtn.state = .off
        result.cmdString.stringValue = ta_[row].cmd
        return result;
    }
    
    
}

    
    
    
    

class KSTableCellView: NSTableCellView {
    
    @IBOutlet weak var startBtn: NSButton!
    @IBOutlet weak var imgView: NSImageView!
    @IBOutlet weak var cmdName: NSTextField!
    @IBOutlet weak var cmdString: NSTextField!
    
}
