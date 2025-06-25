# GMGN.AI Clone - Flutter Web版本

这是一个高度还原GMGN.AI移动端界面的Flutter Web应用，具有像素级的视觉还原度和完整的功能实现。

## 🚀 项目特色

- **像素级还原**: 完全复制GMGN.AI的视觉设计、配色方案和交互体验
- **响应式设计**: 优先适配移动端，同时兼容桌面端浏览器
- **中文界面**: 完整的中文本地化界面
- **暗色主题**: 符合加密货币交易平台的专业外观
- **完整功能**: 包含登录、钱包、市场、跟单等核心功能

## 📱 主要功能

### 1. 用户认证
- 登录/注册页面，包含表单验证
- 演示账户快速体验
- 错误处理和加载状态

### 2. 钱包概览
- 总资产展示和变化趋势
- 代币余额列表
- 最近交易记录
- 投资组合分析

### 3. 跟单交易
- 顶级交易员排行榜
- 交易员详细信息和历史表现
- 一键跟单/取消跟单功能
- 收益统计和风险指标

### 4. 市场行情
- 实时代币价格和涨跌幅
- 热门代币、新币、涨幅榜、跌幅榜分类
- K线图表和技术指标
- 搜索和筛选功能

## 🛠️ 技术栈

- **Flutter Web**: 跨平台UI框架
- **Provider**: 状态管理
- **Flutter ScreenUtil**: 响应式适配
- **Google Fonts**: 字体管理
- **FL Chart**: 图表组件
- **Mock Data**: 模拟API数据

## 📦 项目结构

```
lib/
├── core/
│   └── theme/           # 主题配置
├── data/
│   └── models/          # 数据模型
├── presentation/
│   ├── pages/           # 页面组件
│   ├── widgets/         # 通用组件
│   └── providers/       # 状态管理
├── app.dart            # 应用入口
└── main.dart           # 主函数
```

## 🚀 快速开始

### 环境要求
- Flutter SDK >= 3.0.0
- Dart SDK >= 3.0.0
- Web浏览器 (Chrome推荐)

### 安装依赖
```bash
flutter pub get
```

### 运行项目
```bash
# 开发模式
flutter run -d chrome

# 或指定端口
flutter run -d chrome --web-port=8080
```

### 构建生产版本
```bash
flutter build web --release
```

## 🌐 GitHub Pages 部署

### 方法一: 自动部署 (推荐)
1. Fork 这个项目到你的 GitHub 账户
2. 在项目设置中启用 GitHub Pages
3. 选择 GitHub Actions 作为部署源
4. 每次推送到 main 分支时会自动部署

### 方法二: 手动部署
```bash
# 构建项目
flutter build web --release --base-href "/your-repo-name/"

# 将 build/web 内容推送到 gh-pages 分支
git subtree push --prefix build/web origin gh-pages
```

## 📋 部署检查清单

- [ ] 确认 `pubspec.yaml` 中的依赖版本
- [ ] 更新 `web/index.html` 中的基础路径
- [ ] 检查 `web/manifest.json` 配置
- [ ] 验证所有资源文件路径
- [ ] 测试在不同设备和浏览器的兼容性

## 🎨 设计系统

### 颜色方案
- 主色调: `#00D4AA` (Teal)
- 背景色: `#0B0E11` (Deep Dark)
- 卡片背景: `#1A1D21` (Dark Gray)
- 成功色: `#00C896` (Green)
- 错误色: `#FF4D6D` (Red)

### 字体
- 主字体: Geist (Sans-serif)
- 备用字体: System fonts

## 📱 响应式适配

项目使用 Flutter ScreenUtil 实现响应式设计:
- 基准设计尺寸: 375x812 (iPhone 13 mini)
- 自动文本适配
- 支持分屏模式

## 🔧 开发指南

### 添加新页面
1. 在 `lib/presentation/pages/` 创建页面文件
2. 在 `lib/app.dart` 中注册路由
3. 更新底部导航栏配置

### 添加新组件
1. 在 `lib/presentation/widgets/` 创建组件文件
2. 遵循现有的样式规范
3. 使用 ScreenUtil 进行尺寸适配

### 状态管理
使用 Provider 模式:
1. 在 `lib/presentation/providers/` 创建 Provider
2. 在 `main.dart` 中注册
3. 在页面中使用 Consumer 或 Provider.of

## 🐛 常见问题

### Q: 页面空白或加载失败
A: 检查控制台错误信息，通常是资源路径或依赖问题

### Q: 在GitHub Pages上显示404
A: 确认base-href设置正确，路径应该包含仓库名称

### Q: 样式显示异常
A: 清除浏览器缓存，或检查CSS文件是否正确加载

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 🤝 贡献

欢迎提交 Issue 和 Pull Request！

---

**注意**: 这是一个演示项目，使用模拟数据。在生产环境中请替换为真实的API接口。