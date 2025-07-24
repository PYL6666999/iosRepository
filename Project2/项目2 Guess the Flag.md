### **1.** UI设计与 Interface Builder

- 使用 **Storyboard** 创建界面，包括：

  - 添加三个 UIButton 作为国旗按钮。
  - 使用导航控制器（通过 Editor > Embed In > Navigation Controller）为游戏添加顶部标题栏。

  

- 学习了 **Auto Layout** 两种方式：

  - 约束按钮位置（垂直间距、水平居中）。
  - 更新布局（Editor > Resolve Auto Layout Issues > Update Frames）。

  

### **2.** 资源目录与图像管理

- 学习了 **Asset Catalog (Assets.xcassets)**：
  - 图片支持 @2x 和 @3x 自动适配不同分辨率。
  - 拖入 12 张国旗图，Xcode 根据命名自动匹配到正确的分辨率槽位。



- 按钮图片的设置通过 UIButton.setImage()。

  

### **3.** 核心逻辑（随机数与交互）

- 使用 countries.shuffle() 随机打乱数组。
- 随机选择正确答案 correctAnswer = Int.random(in: 0...2)。
- 通过 IBAction 连接按钮点击事件：
  - 用 sender.tag 区分哪个按钮被点中（需在 Storyboard 手动设置 Tag 值 0、1、2）。
  - 比对是否等于 correctAnswer，更新 score。
- 弹出提示框 UIAlertController，显示正确或错误并继续下一题。



### **4.** CALayer 与 UIButton 样式

- 使用按钮的 layer 属性设置样式：

  - button.layer.borderWidth
  - button.layer.borderColor

  

### **5.** 项目扩展挑战（练习题）

1. **在导航栏显示分数**：

   在每次更新题目时，把 title 设置为 COUNTRY (Score: X) 格式。

2. **统计题目数量并显示最终成绩**：

   用一个 questionsAsked 计数器，每答 10 题显示最终成绩弹窗，然后重置游戏。

3. **错误提示增强**：

   在 UIAlertController 的 message 中加入被误选的国旗名称，例如：

   "Wrong! That’s the flag of \(countries[sender.tag].uppercased())"。

# 解惑

## 自动布局后的最后一步的作用

最后一步 **“Update Frames”** 的作用，是让 **界面上按钮的实际位置和大小，自动匹配你刚才加的 Auto Layout 约束**。

在 Xcode 的 Interface Builder 里，其实有两个“状态”：

1. **视图当前显示的位置/大小（Frame）**：就是你拖动或输入 X、Y、宽高得到的视觉效果。
2. **Auto Layout 约束计算出来的期望位置**：系统根据你添加的规则（Top、Spacing、Center 等）算出的结果。



当你加完约束以后，这两者 **不一定一致**。比如：

- 你拖动按钮时，它位置可能是手工随便放的（X=50,Y=100），
- 但约束说它应该水平居中、安全区下 100 点（比如 X=187.5,Y=100），
- 这时按钮会显示**黄色警告**，表示“Frame 不符合约束”。



### **如果不做这步会怎样？**

- 界面在 Interface Builder（Storyboard 里）显示的按钮位置和运行时会不一样：

  - 运行时系统会 **强制用 Auto Layout 计算的位置**，所以按钮可能“跳”到新位置。
  - 你在编辑器看到的布局和真机/模拟器显示的不一致。

  

- 约束面板上会一直有 **黄色警告（Frame Misplaced）**，提示位置和约束冲突。



###  每个图片都需要放 @2x 和 @3x 吗？**

不一定要手动准备两套图片，现在主要看你的资源来源和项目需求：



- **iOS 从 iPhone 4 以后几乎都是 Retina 屏幕**，所以 **至少要提供 @2x（2倍分辨率）**，否则图片会模糊。
- **很多设备（iPhone Plus、Pro 机型）还会用到 @3x（3倍分辨率）**，如果没有 @3x，系统会自动拉伸 @2x 图片，看起来会有点糊。
- **如果只提供一张普通分辨率图片**（比如 1x），iOS 也能显示，但效果会差。



好消息是：

如果你用的是设计工具（比如 Figma、Photoshop）导出切图，通常一键可以导出 @1x/@2x/@3x 三套资源。

而且 **Xcode 的 Asset Catalog 会帮你管理这些后缀，你只需要拖进去一次**，代码里直接写：

```
UIImage(named: "france")
```

系统会自动选择最合适的分辨率版本。

如果懒得搞多份资源，也可以只放一份分辨率足够高（比如 @3x），但文件会大，加载慢，不推荐。



### 项目 2 是始终一个页面吗？

是的，**整个游戏都在一个 ViewController 上运行**。

逻辑是这样的：

1. 界面上有三个按钮（显示国旗），每次 askQuestion() 随机挑 3 面国旗更新按钮图案。
2. 标题栏（Navigation Bar）上显示要猜的国名。
3. 用户点按钮 → 检查答案 → 弹出提示（UIAlertController），然后重新刷新国旗。

所以页面没有跳转，只有内容动态更新。

你可以理解为 **所有逻辑都围绕 askQuestion() 循环运行**。