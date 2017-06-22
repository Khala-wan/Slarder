//
//  SlarderAuthorization.swift
//  PodMan
//
//  Created by 万圣 on 2017/6/20.
//  Copyright © 2017年 万圣. All rights reserved.
//

import Cocoa

enum SlarderAuthorError:Error {
    case isRunning(description:String)
    case OSError(description:String)
}

extension Process{
    
    // ported from: https://github.com/sveinbjornt/STPrivilegedTask
    // see : https://github.com/gui-dos/Guigna/blob/9fdd75ca0337c8081e2a2727960389c7dbf8d694/Legacy/Guigna-Swift/Guigna/GAgent.swift#L42-L80
    // 移植自OC： https://github.com/sveinbjornt/STPrivilegedTask
    func authorLanuch()throws->FileHandle{
        
        if isRunning {
            throw SlarderAuthorError.isRunning(description: "isRunning")
        }
        
        var err:OSStatus = noErr
        var toolPath = launchPath!.cString(using: .utf8)
        var authorizationRef:AuthorizationRef?
        let myArguments = (arguments ?? []).map { $0.cString(using: .utf8) }
        var args = [UnsafePointer<CChar>?]()
        for cArg in myArguments {
            args.append(UnsafePointer<CChar>(cArg))
        }
        args.append(nil)
        
        var outputFile = FILE()
        var outputFilePointer = withUnsafeMutablePointer(to: &outputFile) { UnsafeMutablePointer<FILE>($0) }
        let outputFilePointerPointer = withUnsafeMutablePointer(to: &outputFilePointer) {UnsafeMutablePointer<UnsafeMutablePointer<FILE>>($0)}
        var myItem:AuthorizationItem = AuthorizationItem.init(name: kAuthorizationRightExecute, valueLength: toolPath!.count, value: &toolPath, flags: 0)
        var myRights:AuthorizationRights = AuthorizationRights.init(count: 1, items: &myItem)
        
        let RTLD_DEFAULT = UnsafeMutableRawPointer(bitPattern: -2)
        var authExecuteWithPrivsFn: @convention(c) (AuthorizationRef, UnsafePointer<CChar>, AuthorizationFlags, UnsafePointer<UnsafePointer<CChar>>?,  UnsafeMutablePointer<UnsafeMutablePointer<FILE>>?) -> OSStatus
        authExecuteWithPrivsFn = unsafeBitCast(dlsym(RTLD_DEFAULT, "AuthorizationExecuteWithPrivileges"), to: type(of: authExecuteWithPrivsFn))
        
        err = AuthorizationCreate(nil, nil, AuthorizationFlags(rawValue: 0), &authorizationRef)
        if err != errAuthorizationSuccess{
            throw SlarderAuthorError.OSError(description: err.description)
        }
        
        err = AuthorizationCopyRights(authorizationRef!, &myRights, nil, AuthorizationFlags(rawValue: 19), nil)
        if err != errAuthorizationSuccess{
            throw SlarderAuthorError.OSError(description: err.description)
        }
        
        /// UnsafePointer<UnsafePointer<CChar>>(args) is Deprecated
        var argsPoint:UnsafePointer<CChar> = UnsafePointer(args).withMemoryRebound(to: UnsafePointer<CChar>.self, capacity: args.count) { $0.pointee }
        
        err = authExecuteWithPrivsFn(authorizationRef!,UnsafePointer<CChar>(toolPath!),AuthorizationFlags(rawValue: 0),&argsPoint,outputFilePointerPointer)
        
        AuthorizationFree(authorizationRef!, [])
        let outputFileHandle = FileHandle(fileDescriptor: fileno(outputFilePointer), closeOnDealloc: true)
        let processIdentifier: pid_t = fcntl(fileno(outputFilePointer), F_GETOWN, 0)
        var terminationStatus: Int32 = 0
        waitpid(processIdentifier, &terminationStatus, 0)
        return outputFileHandle
    }
}


