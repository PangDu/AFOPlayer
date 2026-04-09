# AFOPlayer 内存优化工作流

本文档对应「iOS 原生应用内存优化」计划中的可重复流程；宿主工程壳代码在 `AFOPlayer/AFOPlayer/`，业务多在 CocoaPods 模块中，**Instruments / Memory Graph 需在真机或模拟器上由人工执行**。

---

## 1. Debug Memory Graph（配置与使用）

### Xcode Scheme（已预置）

共享 Scheme [`AFOPlayer.xcodeproj/xcshareddata/xcschemes/AFOPlayer.xcscheme`](../AFOPlayer.xcodeproj/xcshareddata/xcschemes/AFOPlayer.xcscheme) 的 **Run → Arguments → Environment Variables** 中已加入：

| Variable | Value | 默认 |
|----------|-------|------|
| `MallocStackLogging` | `1` | **关闭**（需在 Scheme 中勾选启用） |

启用后配合 **Allocations** 更易对照调用栈；注意会增加开销，日常调试可保持关闭。

### 使用步骤

1. 用 **Debug** 配置运行 App。
2. 打开 **Debug Navigator**（⌘7）→ **Memory** → **Memory Graph**。
3. 在典型场景操作后点击 **Capture**，检查紫色感叹号（泄漏/循环引用嫌疑）。
4. 对可疑对象查看 **Retain Cycle** 提示与引用关系。

可选第三方：MLeaksFinder、FBRetainCycleDetector（需自行集成与评估）。

---

## 2. Instruments 基线（Leaks + Allocations）

在优化前、后各跑一轮，把结果填入下表便于对比。

| 场景 | 设备 / OS | 峰值内存 (MB) | Leaks 持续增长? | 备注 |
|------|-----------|---------------|-----------------|------|
| 冷启动完成 | | | | |
| 播放 10 分钟 | | | | |
| 反复进入/退出列表 | | | | |
| 后台再回前台 | | | | |

**操作要点：**

- **Product → Profile**（⌘I）→ 选 **Leaks** 或 **Allocations**。
- Allocations 中关注 **Persistent** 字节与 VM，对照关键操作前后是否回落。
- 同一设备、同一构建配置（Debug/Release）下对比才有意义。

---

## 3. 循环引用与常见泄漏点（排查清单）

宿主工程内已审查：`AFOAppDelegate`、`AppDelegate`、`AFOAppTabBarController`、`AFOAddControllerModel`、`AFOAppWindow` — **未发现** `NSTimer` / `addObserver:` / 典型 Block 强引用 `self` 模式。

**请在各 Pod / 业务模块中重点自查：**

- `delegate` / `block` 属性：ObjC 用 `weak`/`assign`，Swift 用 `weak`/`unowned`。
- `NSTimer`、`CADisplayLink`：必须在 `dealloc` / `invalidate` 路径释放；**`CADisplayLink` 会强引用 target**，不 `invalidate` 会导致管理器无法释放。
- `NSNotificationCenter`、`KVO`：成对移除。
- 大图片、`CVPixelBuffer`、FFmpeg 缓冲：页面消失或收到内存警告时释放或缩小缓存。

### 已知：AFOViews `AFOProgressSliderManager`

`CADisplayLink` 懒创建且 `dealloc` 中若未 `invalidate`，会造成泄漏。**建议在源码 Pod 中合并以下修改**（若无法写 Pods，请在 AFOViews 仓库改后发版）：

```objc
// AFOProgressSliderManager.m — dealloc
- (void)dealloc {
    [_displayLink invalidate];
    _displayLink = nil;
#if DEBUG
    NSLog(@"dealloc AFOProgressSliderManager");
#endif
}
```

---

## 4. 大图与缓存策略

### 宿主提供的 API

- [`UIImage+AFOMemorySafe`](../AFOPlayer/utilities/UIImage+AFOMemorySafe.h)：`+afo_imageWithContentsOfFile:maxPixelSize:` 使用 ImageIO 按长边上限解码，适合**磁盘大图**展示缩略图，避免整幅解压进内存。

**建议：**

- Asset Catalog 中小图仍可用 `imageNamed:`；**超大静态图**优先放磁盘 + 上述 API 或等价 ImageIO 流程。
- 列表/封面图使用与 cell 尺寸匹配的像素上限（如 `maxPixelSize = max(cellWidth, cellHeight) * scale * 系数`）。
- 业务侧 `NSCache` / SDWebImage 等需在 `AFOApplicationDidReceiveMemoryWarningNotification` 或系统内存通知里 `removeAllObjects` 或降配额。

---

## 5. 视图层级（View Debugger）

1. 运行 App → **Debug → View Debugging → Capture View Hierarchy**。
2. 关注：过深嵌套、`UIVisualEffectView` 叠加、大量透明层导致的离屏渲染。
3. 宿主 Tab 壳较薄；**主要优化在播放页、列表页等业务 Pod**。

---

## 6. 内存警告与业务释放

宿主在 [`AFOAppDelegate`](../AFOPlayer/AFOAppDelegate.m) 中实现 `applicationDidReceiveMemoryWarning:`，并广播：

- **通知名**：`AFOApplicationDidReceiveMemoryWarningNotification`（定义见 [`AFOMemoryPressure.h`](../AFOPlayer/utilities/AFOMemoryPressure.h)）

各模块可监听该通知，执行：

- 清空图片/预览缓存
- 丢弃可重建的解码缓冲
- 缩小预加载队列

系统仍会发送 `UIApplicationDidReceiveMemoryWarningNotification`，两者可同时存在；业务任选其一即可，避免重复逻辑可抽公共工具。

---

## 7. 回归测试（每次优化后）

1. 重复 **§2** 基线场景，填写「优化后」列。
2. 跑一遍核心用例：启动、播放、列表滑动、旋转（若支持）、前后台切换。
3. 对比 Leaks：无新增持续泄漏。
4. 若集成 CI，可将 Profile 脚本或内存阈值检查（如有）附在流水线说明中。

---

## 相关文件索引

| 内容 | 路径 |
|------|------|
| 内存警告广播 | `AFOPlayer/AFOAppDelegate.m` |
| 通知常量 | `AFOPlayer/utilities/AFOMemoryPressure.{h,m}` |
| 大图降采样 | `AFOPlayer/utilities/UIImage+AFOMemorySafe.{h,m}` |
| Scheme 环境变量 | `AFOPlayer.xcodeproj/xcshareddata/xcschemes/AFOPlayer.xcscheme` |
