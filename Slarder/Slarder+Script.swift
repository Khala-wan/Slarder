//
//  Slarder+Script.swift
//  PodMan
//
//  Created by 万圣 on 2017/6/20.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Foundation

extension Process {
    
    /// Process的简便初始化方法，当你需要Process执行一个脚本的时候.
    ///
    /// - Parameters:
    ///   - scriptName: 脚本名称（请使用全名包含类型后缀）
    ///   - bundle: 脚本文件所在的Bundle，默认是主Bundle.
    static func initWith(scriptName:String,bundle:Bundle?)throws ->Process{
        let process:Process = Process()
        let scriptBundle:Bundle = bundle ?? Bundle.main
        if let scriptPath:String = scriptBundle.path(forResource: scriptName, ofType: nil){
            process.launchPath = scriptPath
        }else{
            throw SlarderError.ScriptNotFound(description: "\(scriptName) Not Found in \(scriptBundle.className)")
        }
        return process
    }
}

