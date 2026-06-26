# Philo - 哲学慰藉应用

Philo 是一款 iOS 哲学慰藉应用，通过古典哲学语录为你的每一天带来心灵慰藉。

## ✨ 功能

- **每日哲思** — 每天自动显示一句古典哲学语录，开启有智慧的一天
- **心情匹配** — 选择当前心情（14 种），获得 ~10 句匹配的哲学语录
- **情绪日记** — 心情记录和收藏的语录自动保存，形成可回顾的历史日记
- **每日推送** — 每天早上 8:00 推送今日语录（需授权通知权限）

## 📁 项目结构

```
Philo/
├── Sources/
│   ├── App/              # App 入口 (PhiloApp.swift)
│   ├── Models/           # 数据模型 (Quote, Mood, MoodEntry)
│   ├── Services/         # 服务层 (QuoteService, StorageService, NotificationService)
│   ├── ViewModels/       # 视图模型 (MVVM 模式)
│   ├── Views/            # 视图层
│   │   ├── Components/   # 可复用组件 (QuoteCard, MoodIcon)
│   │   ├── DailyQuoteView.swift
│   │   ├── MoodSelectionView.swift
│   │   ├── HistoryView.swift
│   │   └── QuoteDetailView.swift
│   └── Resources/        # 资源文件 (quotes.json)
├── project.yml           # XcodeGen 配置
└── Philo/Info.plist      # 应用信息配置
```

## 🚀 如何构建

### 方法一：使用 XcodeGen（推荐）

1. 安装 XcodeGen：
   ```bash
   brew install xcodegen
   ```

2. 生成 Xcode 项目：
   ```bash
   cd Philo
   xcodegen generate
   ```

3. 打开 Philo.xcodeproj，选择 iOS 17.0+ 模拟器或真机运行

### 方法二：手动创建 Xcode 项目

1. 在 Xcode 中新建 iOS App 项目（SwiftUI, iOS 17.0+）
2. 将所有 `Sources/` 下的 Swift 文件拖入项目
3. 将 `Sources/Resources/quotes.json` 拖入项目，确保加入 target
4. 将 `Philo/Info.plist` 配置到项目设置中
5. 在 Signing & Capabilities 中配置自己的 Apple 开发者账号

## 📱 技术栈

- **UI 框架**: SwiftUI
- **数据持久化**: SwiftData
- **架构模式**: MVVM + @Observable
- **本地通知**: UserNotifications
- **最低部署目标**: iOS 17.0

## 📊 内容

内置 107 条古典哲学语录，涵盖 14 种心情类别，收录的哲学家包括：

| 东方 | 西方 |
|------|------|
| 老子、孔子、庄子 | 马可·奥勒留、塞涅卡 |
| 苏轼、王阳明、屈原 | 柏拉图、亚里士多德 |
| 陶渊明、李白、木心 | 尼采、萨特、克尔凯郭尔 |
| ... 等 | ... 等 |

## 🔜 后续可扩展

- iCloud 数据同步
- Apple Watch 版本（每日语录推送）
- 自定义语录收藏夹
- 更多哲学流派（禅宗、存在主义、斯多葛专题）
- 心情趋势图表
- 分享语录到社交媒体
- 黑暗模式自适应（已内置支持）

---

*"未经审视的人生不值得过。" —— 苏格拉底*
