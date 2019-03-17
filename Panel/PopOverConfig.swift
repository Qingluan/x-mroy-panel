//
//  PopOverConfig.swift
//  Panel
//
//  Created by dr on 2019/3/14.
//  Copyright © 2019 dr. All rights reserved.
//

import Cocoa

class PopOverConfig: NSPageController, NSPageControllerDelegate{
    
    
//    let popover = NSPopover()
    
    var myViewArray = [ "config", "show", "test"]
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        let account1 = Command(name:"Account 1", cmd: "ls -a ");
//        let account2 = Command(name:"Account 2", cmd: "shadowsocks some ... ");
//
//
//        department1.comands.append(account1)
//        department1.comands.append(account2)
//        department2.comands.append(account2)
        delegate = self
        self.arrangedObjects = myViewArray
        self.transitionStyle = .horizontalStrip
    
    }
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: String) -> NSViewController {
        print("\(identifier) \(selectedIndex)")
        switch identifier {
            
        case "show":
            //            return NSStoryboard(name: "", bundle:nil).instantiateController(withIdentifier: "Page02") as! NSViewController
            
            return  ShowCommandsViewController(nibName: "ShowCommandsViewController", bundle: nil)
        case "config":
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            let vc:ViewController = storyboard.instantiateController(withIdentifier: "viewController") as! ViewController
            return vc
        case "test":
            return NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "commandViewController") as! NSViewController
        //            return NSStoryboard(name: "Main", bundle:nil).instantiateController(withIdentifier: "viewController") as! NSViewController
        default:
            return self.storyboard?.instantiateController(withIdentifier: identifier) as! NSViewController
        }
        
    }
    
    
    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> String {
        return String(describing: object)
        
    }
  
    
    
    func pageControllerDidEndLiveTransition(_ pageController: NSPageController) {
        self.completeTransition()
    }

}
