//
//  Slarder.swift
//  PodMan
//
//  Created by 万圣 on 2017/6/19.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

extension Slarder where Base:Process {
    
    /// Process 执行普通脚本（无异步任务的,无输入）并获得 标准输出、错误输出、执行完成等回调处理能力。
    ///
    /// - Parameters:
    ///   - sudo: 是否需要root权限 默认不需要
    ///   - outputHandler: 标准输出回调
    ///       - outputString: 输出信息
    ///       - input:输入流Pipe
    ///   - errorputHandler: 错误输出回调 如果该参数为nil，则错误信息当做标准输出信息输出。
    ///       - errorMessage:错误信息
    ///   - terminateHandler:
    ///       - status:完成结果的Code
    func launchWith(sudo:Bool = false,outputHandler:((_ outputMessage:String,_ input:Pipe?)->())?,errorputHandler:((_ errorMessage:String)->())?,terminateHandler:((_ status:Int32)->())?){
        
        let outputPipe = outputHandler == nil ? nil : Pipe()
        let errorputPipe = errorputHandler == nil ? nil : Pipe()
        
        var readHandlers:(FileHandle?,FileHandle?) = self.setInOutputAndErrorOutput(input: nil, output: outputPipe, errorOutput: errorputPipe)
        if sudo {
            do{
                readHandlers.0 = try self.base.authorLanuch()
            }catch{
                print(error.localizedDescription)
                return
            }
        }else{
            base.launch()
        }
        
        /// 标准输出
        let outResult = handleOutPutString(readHandler: readHandlers.0)
        if outResult.0 {
            outputHandler!(outResult.1, nil)
        }
        
        /// 标准错误输出
        let errorResult = handleOutPutString(readHandler: readHandlers.1)
        if errorResult.0 {
            errorputHandler!(errorResult.1)
        }
        
        /// 执行结束回调
        if let handler = terminateHandler{
            handler(base.terminationStatus)
        }
    }
    
    
    /// Process 执行异步脚本（有异步任务的,有输入）并获得 标准输出、错误输出、执行完成等回调处理能力。
    ///
    /// - Parameters:
    ///   - sudo: 是否需要root权限 默认不需要
    ///   - outputHandler: 标准输出回调
    ///       - outputString: 输出信息
    ///       - input:输入流Pipe
    ///   - errorputHandler: 错误输出回调 如果该参数为nil，则错误信息当做标准输出信息输出。
    ///       - errorMessage:错误信息
    ///   - terminateHandler:
    ///       - status:完成结果的Code
    func launchAsyncWith(sudo:Bool = false,outputHandler:((_ outputMessage:String,_ input:Pipe?)->())?,errorputHandler:((_ errorMessage:String)->())?,terminateHandler:((_ status:Int32)->())?){
        
        let outputPipe = outputHandler == nil ? nil : Pipe()
        let errorputPipe = errorputHandler == nil ? nil : Pipe()
        
        let inputPipe = Pipe()
        
        var readHandlers:(FileHandle?,FileHandle?) = self.setInOutputAndErrorOutput(input: inputPipe, output: outputPipe, errorOutput: errorputPipe)
        
        if sudo {
            do{
                readHandlers.0 = try self.base.authorLanuch()
            }catch{
                print(error.localizedDescription)
                return
            }
        }else{
            base.launch()
        }
        
        /// 标准输出
        if let outHandler:FileHandle = readHandlers.0{
            outHandler.waitForDataInBackgroundAndNotify()
            NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outHandler , queue: nil, using: { (noti) in
                let result = self.handleOutPutString(readHandler: readHandlers.0)
                if result.0 {
                    outputHandler!(result.1,inputPipe)
                }
                outHandler.waitForDataInBackgroundAndNotify()
            })
        }
        
        /// 标准错误输出
        if let outHandler:FileHandle = readHandlers.1{
            outHandler.waitForDataInBackgroundAndNotify()
            NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: outHandler , queue: nil, using: { (noti) in
                let result = self.handleOutPutString(readHandler: readHandlers.0)
                if result.0 {
                    errorputHandler!(result.1)
                }
                outHandler.waitForDataInBackgroundAndNotify()
            })
        }
        
        /// 执行结束回调
        if let handler = terminateHandler{
            NotificationCenter.default.addObserver(forName: Process.didTerminateNotification, object: base, queue: nil) { (noti) in
                handler(self.base.terminationStatus)
            }
        }
    }
    
}

open class haha : NSObject {
    
}

public struct Slarder<Base> {
    
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public extension Process {
    public var sd: Slarder<Process> {
        return Slarder(self)
    }
}
