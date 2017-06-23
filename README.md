<div><img width="629" height="98" src="https://github.com/Khala-wan/Slarder/raw/master/resources/logo.png"/></div>

![platforms](https://img.shields.io/badge/platforms-MacOS-333333.svg) ![Xcode 8.3](https://img.shields.io/badge/Xcode-8.3%2B-blue.svg) ![MacOS 10.5](https://img.shields.io/badge/MacOS-10.5%2B-blue.svg) ![Swift 3.1](https://img.shields.io/badge/Swift-3.1%2B-orange.svg) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Khala-wan/Slarder) [![中文 README](https://img.shields.io/badge/%E4%B8%AD%E6%96%87-README-blue.svg?style=flat)](https://github.com/Khala-wan/Slarder/blob/master/README.zh-cn.md)

Its a easier way to use Process on MacOS for handling STDOUT、STDERR、termination status, and running your script as `root`. 
## Feature
### Common Script：
<div align="center"><img style="border: 1px solid #dcdcdc" width="500" height="350" src="https://github.com/Khala-wan/Slarder/raw/master/resources/gif1.gif"/></div>

### Async Script：
<div align="center"><img style="border: 1px solid #dcdcdc" width="500" height="350" src="https://github.com/Khala-wan/Slarder/raw/master/resources/gif2.gif"/></div>

## Install
`Carthage` and `CocoaPods` are the optional tools to install Slarder into your project.

Of course, you can also download the source code and drag the source file to your project as you like.
### Carthage
1.Create Cartfile in your project directory
>$ touch Cartfile

2.Add this to Cartfile：
>github "Khala-wan/Slarder"

3.Run
>carthage update

4.Drag Slarder.frameWork to your project directory. Slarder.frameWork stored in：
>${ Project }/Carthage/Build/Mac/Slarder.frameWork

5.Embedde in your project：
>Target -> General -> Embedded Binaries -> Add Other -> Select "Slarder.frameWork"

6.Where you want to use Slarder
>Import Slarder

7.Just try it!

**More Carthage usage in [Carthage](https://github.com/Carthage/Carthage)**

### CocoaPods (not supported yet)
1.Create Podfile
>$ Pod init

2.Add this to Podfile
>pod Slarder

3.Where you want to use Slarder
>Import Slarder

## Usage

### Create a Process
If you only want to run a command, you can create a process instance as before. If you want to run a script, Slarder provides you with a simple constructor:

```swift
let process:Process = try! Process.initWith(scriptName: "commonShell.sh", bundle: nil)

```

### sd
Every Process instance has a property named `sd` , by which we can use all the features of Slarder.


```swift
Process().sd.someFunc()
```

### Run Process
Slardar provides two running privileges for your Process: current users and root users

**If you need root privileges to lanuch process, set the first parameter `sudo` to True**

#### Common Script launchWith
```swift 
process.sd.launchWith(sudo: false，outputHandler: { (string, input) in
            //STDOUT everytime
        }, errorputHandler: { (string) in
            //STDERR everytime
        }) { (statusCode) in
            //Process terminated
        }
```
**If the `errorputHandler` parameter is nil, STDERR is output with STDOUT**

#### Async Script launchAsyncWith
If your script has tasks such as delay or network request, you may not be able to get all the output at once, then you need to listen to STDOUT, and connect each output in series.

```swift
process.sd.launchAsyncWith(sudo: self.root, outputHandler: { (newStr, input) in
            self.outputString.append(newStr)
        }, errorputHandler: nil) { (code) in
            self.updateConsoleView(newMessage: "statusCode = \(code)")
        }
```

#### STDIN

Maybe your script needs to read some data from STDIN, like shell's `read userName; echo $ userName`. You can use the outputHandler closure parameter `input: Pipe`。

```swift
process.sd.launchAsyncWith(sudo: self.root, outputHandler: { (newStr, input) in
            let writeHandle = input?.fileHandleForWriting
            writeHandle?.write(someData)
        }, errorputHandler: nil) { (code) in
            self.updateConsoleView(newMessage: "statusCode = \(code)")
        }
```

## About Swift4.0
Slarder is supported by `Swift4.0`, but SlarderSimpleExample is not supported. In case you want to use SlarderSimpleExample in `Swift4.0`, there is a branch named [Swift4.0](https://github.com/Khala-wan/Slarder/tree/Swift4.0).

## NextStep

* Test Slarder
* Add more useful features

## Last
Contact me if you have any questions. We welcome any contributions to make Slarder better. Look forward to your use ~ 
