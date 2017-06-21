//
//  Slarder+Process.swift
//  PodMan
//
//  Created by 万圣 on 2017/6/20.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Foundation

extension Slarder where Base:Process {
    
    func setInOutputAndErrorOutput(input:Pipe?, output:Pipe?, errorOutput:Pipe?)->(FileHandle?,FileHandle?){
        
        if let inputPipe:Pipe = input{
            self.base.standardInput = inputPipe
        }
        
        var result:(FileHandle?,FileHandle?) = (nil,nil)
        
        if let outputPipe:Pipe = output{
            self.base.standardOutput = output
            result.0 = outputPipe.fileHandleForReading
        }
        
        if let errorPipe:Pipe = errorOutput{
            self.base.standardError = errorPipe
            result.1 = errorPipe.fileHandleForReading
        }else{
            self.base.standardError = output ?? nil
            result.1 = nil
        }
        return result
    }
    
    func handleOutPutString(readHandler:FileHandle?)->(Bool,String){
        guard readHandler != nil else{
            return (false,"")
        }
        let outputData:Data = readHandler!.availableData
        if outputData.count > 0{
            let str:String = String.init(data: outputData, encoding: .utf8) ?? "output is not UTF8 String"
            return (true,str)
        }else{
            return (false,"")
        }
    }
    
//    func authorizationLaunch()->SlarderAuthorStatus{
//        guard !base.isRunning else { return SlarderAuthorStatus.isRunning}
//
//
//    }
}
