//
//  ViewController.swift
//  SlarderSimpleExample
//
//  Created by 万圣 on 2017/6/21.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    /// RunAsyncScirpt
    ///
    @IBAction func AsyncRunBtnClicked(_ sender: Any) {
        consoleView.string = ""
        let process:Process = try! Process.initWith(scriptName: "asyncShell.sh", bundle: nil)
        process.sd.launchAsyncWith(sudo: self.root, outputHandler: { (str, input) in
            self.updateConsoleView(newMessage: str)
        }, errorputHandler: nil) { (code) in
            self.updateConsoleView(newMessage: "statusCode = \(code)")
        }
    }
    
    /// RunCommonScript
    ///
    @IBAction func CommonRunBtnClicked(_ sender: Any) {
        consoleView.string = ""
        let process:Process = try! Process.initWith(scriptName: "commonShell.sh", bundle: nil)
        process.sd.launchWith(sudo: self.root, outputHandler: { (str, input) in
            self.updateConsoleView(newMessage: str)
        }, errorputHandler: nil) { (code) in
            self.updateConsoleView(newMessage: "statusCode = \(code)")
        }
    }
    
    @IBAction func rootCheckBoxChanged(_ sender: NSButton) {
        root = sender.state == .on
    }
    
    
    fileprivate final func updateConsoleView(newMessage:String){
        consoleView.textStorage?.append(NSMutableAttributedString.init(string: newMessage))
        consoleView.scrollRangeToVisible(NSMakeRange(consoleView.string.characters.count, 0))
    }
    
    
    
    var root:Bool = false
    
    @IBOutlet var consoleView: NSTextView!
}

