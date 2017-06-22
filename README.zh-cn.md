Slarder
=======

![platforms](https://img.shields.io/badge/platforms-MacOS-333333.svg) ![Xcode 9.0-beta](https://img.shields.io/badge/Xcode-9.0%2B-blue.svg) ![MacOS 10.5](https://img.shields.io/badge/MacOS-10.5%2B-blue.svg) ![Swift 4.0](https://img.shields.io/badge/Swift-4.0%2B-orange.svg) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Khala-wan/Slarder) [![中文 README](https://img.shields.io/badge/%E4%B8%AD%E6%96%87-README-blue.svg?style=flat)](https://github.com/Khala-wan/Slarder/raw/master/README.zh-cn.md)

让你在MacOS上使用Process更加简单。轻松捕获标准输出、标准错误输出、完成状态。并轻松获取Root权限来运行你的脚本。

## 演示
### 普通脚本：
<div align="center"><img style="border: 1px solid #dcdcdc" width="500" height="370" src="https://github.com/Khala-wan/Slarder/raw/master/resources/gif1.gif"/></div>

### 带有异步任务的脚本：
<div align="center"><img style="border: 1px solid #dcdcdc" width="500" height="370" src="https://github.com/Khala-wan/Slarder/raw/master/resources/gif2.gif"/></div>

## 安装
Slarder将为你提供Cathage和CocoaPods两种选择来安装它到你的项目中。当然，你也可以直接下载源代码并拖拽源文件到你的项目中。你开心就好~
### Carthage
1.在你的项目目录中创建Cartfile
>$ touch Cartfile

2.编辑Cartfile文件 并加入：
>github "Khala-wan/Slarder"

3.然后运行
>carthage update

4.拖拽Carthage帮你Build好的Slarder.frameWork到你的项目目录中。Slarder.frameWork存放在：
>${ Project }/Carthage/Build/Mac/Slarder.frameWork

5.进入你的项目进行嵌入：
>Target -> General -> Embedded Binaries -> Add Other -> 选中刚才你拖拽过来的Slarder.frameWork

6.在你要使用Slarder的地方
>Import Slarder

7.快试一试Slarder的功能吧~

**详细的Carthage使用请关注[Carthage](https://github.com/Carthage/Carthage)**

### CocoaPods (暂不支持)
1.创建 Podfile
>$ Pod init

2.编辑Podfile并加入
>pod Slarder

3.在你要使用Slarder的地方
>Import Slarder

## 使用

### 创建一个Process
如果你要运行一行命令，那么你可以正常创建Process实例.如果你要运行一个脚本，Slarder为你提供了一个简便构造方法：

```swift
let process:Process = try! Process.initWith(scriptName: "commonShell.sh", bundle: nil)

```

### sd
每一个Process实例都拥有一个属性：`sd`通过`sd`我们可以使用Slarder的所有功能。

```swift
	Process().sd.someFunc()
```

### 运行Process
Slarder为你的Process提供了两种运行权限：当前用户和Root用户
**是否需要Root权限运行只需要将第一个参数`sudo`设置为True or Flase**

#### 普通脚本 launchWith
```swift 
process.sd.launchWith(sudo: false，outputHandler: { (string, input) in
            //每次STDOUT都会来这里
        }, errorputHandler: { (string) in
            //每次STDERR都会来这里
        }) { (statusCode) in
            //Process完成后会到这里
        }
```
**如过errorputHandler参数传入nil，则STDERR会和STDOUT一起输出**

#### 异步脚本 launchAsyncWith
如果你的脚本有需要延迟或者请求网络之类的任务时，可能一次无法全部获取所有输出，那么就需要监听STDOUT。将每一条输出串联起来。

```swift
process.sd.launchAsyncWith(sudo: self.root, outputHandler: { (newStr, input) in
            self.outputString.append(newStr)
        }, errorputHandler: nil) { (code) in
            self.updateConsoleView(newMessage: "statusCode = \(code)")
        }
```

#### STDIN
也许你的脚本需要读取STDIN。就像Shell的`read userName ; echo $userName`则可以使用outputHandler闭包中给你的**input：Pipe**。

```swift
process.sd.launchAsyncWith(sudo: self.root, outputHandler: { (newStr, input) in
            let writeHandle = input?.fileHandleForWriting
            writeHandle?.write(someData)
        }, errorputHandler: nil) { (code) in
            self.updateConsoleView(newMessage: "statusCode = \(code)")
        }
```

## NextStep

* 测试 Slarder
* 加入更多好用的功能

## 最后
如果在使用中遇到任何问题都可以联系我。欢迎PR、Issue等等一切让Slarder变得更好的方式。期待你的使用~谢谢。
