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
    
    @IBOutlet weak var tableView:NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.ta_ = Command.load()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    
}


extension ShowCommandsViewController:NSTableViewDataSource, NSTableViewDelegate{
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
