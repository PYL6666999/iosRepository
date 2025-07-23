# 设置

在这个项目中，你将开发一个应用程序，让用户滚动浏览图片列表，然后选择其中一张进行查看。这个项目特意设计得比较简单，因为在这个过程中你还需要学习很多其他东西，所以请做好准备——这将会是一个漫长的过程！

启动 Xcode，在欢迎屏幕上选择“创建新的 Xcode 项目”。从列表中选择“单视图应用”，然后点击“下一步”。在“产品名称”中输入“Project1”，并确保已选择 Swift 作为开发语言。

![创建项目](./assets/Newproject.png)

## **1.** **Team**

- 指你在 Apple Developer 里的开发团队账号（通常是你的个人账号或公司账号）。
- 选择后，Xcode 会自动帮你管理证书和签名，用于真机调试和上架 App Store。
- **如果只是本地调试，可以选 None，但无法上架或用真机测试**。

## **2.** **Organization Identifier**

- 就是你团队的唯一标识符，一般用反向域名格式，比如：

```
com.yourcompany
```

- 这个会和 App 名字一起生成唯一的 **Bundle Identifier**。

## **3.** **Bundle Identifier**

- 每个 iOS App 都必须有唯一的 ID，比如：

```
com.yourcompany.myapp
```

- App Store 就靠它区分不同的 App。
- 通常自动生成，你只需要保证和开发者账号里的 Bundle ID 一致。

## **4.** **Interface（界面开发方式）**

- 有两个主要选项：

  1. **SwiftUI**

     - Apple 推的新式 UI 框架，用声明式语法。
     - 适合新项目，代码简洁，但生态还没 UIKit 全。

     

  2. **Storyboard**

     - UIKit 的界面工具，用可视化拖拽。
     - 传统方式，适合需要 UIKit 的老项目或兼容性更好的项目。

     

- **如果你要做 UIKit 项目，选 Storyboard**（因为 UIKit 项目就是基于 Storyboard 或纯代码布局）。



## **5.** **Language（语言）**

- 目前一般选 **Swift**，除非你特别需要 Objective-C。



## **6.** **Testing System（测试方式）**

- 有三种：

  1. **Swift Testing with XCTest**

     - Swift 原生的测试框架，写起来比较简洁。

  2. **XCTest for Unit and UI Tests**

     - Apple 传统的测试框架，兼容性最好（业界常用）。

  3. **None**

     - 不生成任何测试文件。

     

- **做练习项目可以选 None，公司项目通常选 XCTest**。

## **7.** **Storage（数据存储）**

- 三个选项：
  1. **None**
     - 不使用任何数据存储，适合小 Demo。
  2. **SwiftData**
     - Apple 在 iOS 17 推出的新框架，简化 Core Data 的用法，用法类似现代数据库。
  3. **Core Data**
     - 传统的对象关系映射框架，老项目广泛使用。
- **新手 UIKit 项目，建议先选 None，以后需要本地数据再选 Core Data 或 SwiftData**。

# 学到的主要知识点

这个项目主要是为了让你熟悉 **iOS 开发的核心概念**，包括：

### **①** **TableView（表格视图）**

- 用来展示一系列数据（比如图片文件名）。

- 通过以下两个方法提供行数和内容：

  - numberOfRowsInSection → 告诉系统有几行。
  - cellForRowAt → 告诉系统每一行显示什么。

  

### **②** **FileManager（文件管理器）**

- 用来读取应用程序包里的资源，比如我们用它找到 nssl 开头的图片文件。



### **③** **数组（Array）和排序**

- 用 pictures = [String]() 存储所有文件名。
- 用 sort() 方法让它们按字母顺序排列。



### **④** **Storyboard 和 ViewController**

- **Storyboard** 用来可视化设计 UI。
- **ViewController** 是每个界面的逻辑代码。
- 通过 **Segue 或手动加载** 切换界面（这里是手动用 instantiateViewController）。



### **⑤** **Outlet（拖线）和 UIImageView**

- 用 **@IBOutlet** 连接 UI 元素到代码（比如 imageView）。
- UIImageView 显示图片，用 UIImage(named:) 加载。



### **⑥** **NavigationController（导航控制器）**

- 负责多个页面的切换（带顶部导航栏）。
- 用 pushViewController() 推送新的界面。
- 用 hidesBarsOnTap 隐藏/显示导航栏。



### **⑦** **生命周期方法**

- viewDidLoad()：视图加载完成时调用，适合初始化。
- viewWillAppear() / viewWillDisappear()：界面即将显示/消失时，适合修改 UI 状态。



### **⑧** **可选类型（Optional）与解包**

- 像 var selectedImage: String? 这样的变量可能为 nil。
- 需要用 if let 安全解包，避免程序崩溃。



### **⑨** **UI 调整**

- Content Mode 控制图片如何显示（Aspect Fit、Aspect Fill）。
- title 设置导航栏标题。
- navigationController?.navigationBar.prefersLargeTitles = true 控制大标题。





------





## **2. 项目实现的逻辑流程**

整个项目的逻辑分为 3 个部分：

### **（1）加载图片并显示在列表**

1. 在 viewDidLoad() 里：

   - 用 FileManager 找到所有 nssl 开头的图片。
   - 把文件名存进数组 pictures。
   - 用 sort() 排序。

   

2. 表格视图通过：

   - numberOfRowsInSection 返回数组的数量。
   - cellForRowAt 把数组里的文件名填到每行。

### **（2）点击一行跳转详情页面**

1. 在 didSelectRowAt：
   - 从 Storyboard 里加载 DetailViewController。
   - 把选中的文件名通过 selectedImage 传过去。
   - 用 pushViewController() 显示新界面。

### **（3）在详情页显示图片**

1. 在 DetailViewController.viewDidLoad()：

   - 用 if let 检查 selectedImage 是否有值。
   - 用 UIImage(named:) 加载图片，显示在 imageView。
   - 设置标题，比如 "第 X 张，共 Y 张"。
   - 设置 hidesBarsOnTap = true 支持全屏查看。

   



------



## **项目最终效果**

1. 打开应用 → 显示按顺序排列的图片文件名。
2. 点击一行 → 页面滑入，显示对应图片（全屏可隐藏导航栏）。
3. 顶部导航栏显示当前图片序号，返回时能回到列表。



## **1.** **FileManager 是能找到程序包里的所有资源吗？**

是的，但它只能找到**你应用程序包 (App Bundle)** 里的资源，而不是你电脑里的所有文件。

- Bundle.main.resourcePath! 表示**应用自己的资源目录**，也就是 .app 包里的 Resources 文件夹。
- 当我们写：

```swift
let fm = FileManager.default
let path = Bundle.main.resourcePath!
let items = try! fm.contentsOfDirectory(atPath: path)
```

- 它只会列出 **这个目录下的文件**（比如 .png、.jpg、.plist 等），不会去遍历系统的所有文件夹，也不会去你的桌面或其他地方找。

**换句话说：**

- 它是读取你项目中“Copy Bundle Resources”阶段被打包进应用的文件。
- 不会自动递归子文件夹（除非你自己去调用递归方法）。

如果想只找特定类型（比如图片），通常还会加条件，比如：

```swift
if item.hasPrefix("nssl") {
    pictures.append(item)
}
```



## **2.** **Storyboard 和 ViewController 的关系：为什么还要用 Outlet 绑定？**

- **Storyboard** 是 UI 的图形描述文件，它画出了控件的位置（比如按钮、图片）。
- **ViewController.swift** 是逻辑代码，控制这些控件怎么工作（比如点击按钮切换界面）。



这两者是**分开的**，Xcode 不会自动知道“这个按钮属于哪个变量”。

所以我们用 **@IBOutlet** 绑定：

```swift
@IBOutlet var imageView: UIImageView!
```

这相当于告诉 Xcode：

> “Storyboard 里的这个 UIImageView，就是代码里的 imageView 变量。”

如果不用 Outlet，你没法在代码里修改这个控件（比如设置图片），Storyboard 上的控件也不会响应逻辑。



## **3.** **NavigationController 是不是自己没有页面？它怎么生效？**

- **UINavigationController** 本身只是一个“容器”，没有内容页面。
- 它的作用是：
  - 维护一堆 ViewController 的堆栈。
  - 提供导航栏、返回按钮、滑动返回等功能。
  - 负责页面切换的动画。

通常在项目入口（App 启动时），你会把它设置为 **rootViewController（根控制器）**，然后让它包含你的第一个页面，比如：

```swift
NavigationController
    └── ViewController (第一个界面)
```

之后再用：

```swift
navigationController?.pushViewController(vc, animated: true)
```

来往堆栈里添加页面。

如果没有设置成入口，它就无法显示，因为它自己不是“页面”。





## **4.** **iOS 生命周期方法有哪些？每个阶段做什么？**

主要有以下常见方法（按执行顺序）：

1. **viewDidLoad()**

   - 视图加载完成时调用（只调用一次）。
   - 适合做初始化（比如加载数据、设置 UI）。
   - 此时界面还没显示到屏幕上。

   

2. **viewWillAppear(_:)**

   - 每次页面**将要显示**时调用。
   - 适合做一些 UI 更新（比如隐藏导航栏、刷新数据）。
   - 会被多次调用（每次页面出现时）。

   

3. **viewDidAppear(_:)**

   - 页面已经显示在屏幕上。
   - 适合启动动画、网络请求等。

   

4. **viewWillDisappear(_:)**

   - 页面将要消失时调用。
   - 适合撤销一些设置（比如恢复导航栏）。

   

5. **viewDidDisappear(_:)**

   - 页面完全从屏幕上消失。
   - 适合停止动画、释放资源。

   

6. **viewWillLayoutSubviews() / viewDidLayoutSubviews()**

   - 视图即将布局/布局完成时调用。
   - 适合处理布局相关逻辑，比如动态调整控件位置。

   

7. **deinit**

   - 控制器销毁前调用，用来清理资源。

   

------



## **生命周期执行顺序举例：**

当你打开一个页面时：

```swift
viewDidLoad()         // 页面首次加载
viewWillAppear()      // 即将显示
viewDidAppear()       // 已显示
```

当你离开页面时：

```swift
viewWillDisappear()   // 即将消失
viewDidDisappear()    // 已经消失
```

