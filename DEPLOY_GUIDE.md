# GMGN.AI Clone - 部署指南

本文档提供了GMGN.AI Clone Flutter Web应用的详细部署指南。

## 🚀 快速部署 (推荐方式)

### 方法一: GitHub Pages 自动部署

1. **Fork 项目到您的GitHub账户**
   ```bash
   # 或者直接在GitHub网页上fork
   git clone https://github.com/your-username/GMGN.AI.git
   cd GMGN.AI
   ```

2. **启用GitHub Pages**
   - 进入您fork的仓库
   - 点击 `Settings` -> `Pages`
   - Source 选择 `GitHub Actions`
   - 保存设置

3. **推送代码触发自动部署**
   ```bash
   git add .
   git commit -m "Initial commit"
   git push origin main
   ```

4. **访问您的应用**
   - 部署完成后，访问: `https://your-username.github.io/GMGN.AI/`

## 🛠️ 手动部署

### 方法二: 手动构建和部署

1. **环境准备**
   ```bash
   # 确保Flutter版本 >= 3.0.0
   flutter --version
   
   # 如果没有安装Flutter，请先安装
   # https://docs.flutter.dev/get-started/install
   ```

2. **克隆项目**
   ```bash
   git clone https://github.com/your-username/GMGN.AI.git
   cd GMGN.AI
   ```

3. **安装依赖**
   ```bash
   flutter pub get
   ```

4. **构建生产版本**
   ```bash
   # 替换 your-repo-name 为您的实际仓库名
   flutter build web --release --base-href "/your-repo-name/"
   ```

5. **部署到GitHub Pages**
   ```bash
   # 创建并切换到gh-pages分支
   git checkout -b gh-pages
   
   # 复制构建文件到根目录
   cp -r build/web/* .
   
   # 提交并推送
   git add .
   git commit -m "Deploy to GitHub Pages"
   git push origin gh-pages
   ```

## 🌐 其他部署选项

### Vercel 部署

1. **安装Vercel CLI**
   ```bash
   npm i -g vercel
   ```

2. **构建项目**
   ```bash
   flutter build web --release
   ```

3. **部署**
   ```bash
   cd build/web
   vercel --prod
   ```

### Netlify 部署

1. **构建项目**
   ```bash
   flutter build web --release
   ```

2. **创建 netlify.toml**
   ```toml
   [build]
     publish = "build/web"
     command = "flutter build web --release"

   [[redirects]]
     from = "/*"
     to = "/index.html"
     status = 200
   ```

3. **拖拽 build/web 目录到 Netlify Dashboard**

### Firebase Hosting 部署

1. **安装Firebase CLI**
   ```bash
   npm install -g firebase-tools
   ```

2. **初始化Firebase**
   ```bash
   firebase login
   firebase init hosting
   ```

3. **配置 firebase.json**
   ```json
   {
     "hosting": {
       "public": "build/web",
       "ignore": [
         "firebase.json",
         "**/.*",
         "**/node_modules/**"
       ],
       "rewrites": [
         {
           "source": "**",
           "destination": "/index.html"
         }
       ]
     }
   }
   ```

4. **构建和部署**
   ```bash
   flutter build web --release
   firebase deploy
   ```

## 🔧 自定义配置

### 修改基础路径

如果您的应用不在根路径下，需要修改 `base-href`:

```bash
flutter build web --release --base-href "/your-path/"
```

### 自定义域名

1. **GitHub Pages 自定义域名**
   - 在仓库根目录创建 `CNAME` 文件
   - 文件内容为您的域名: `yourdomain.com`
   - 更新 `.github/workflows/deploy.yml` 中的 `cname` 配置

2. **DNS 配置**
   ```
   # A 记录指向 GitHub Pages IP
   185.199.108.153
   185.199.109.153
   185.199.110.153
   185.199.111.153
   
   # 或者 CNAME 记录指向
   your-username.github.io
   ```

## 📋 部署检查清单

### 部署前检查

- [ ] **依赖版本**: 确认 `pubspec.yaml` 中所有依赖都是稳定版本
- [ ] **资源文件**: 检查所有图片、图标、字体文件是否存在
- [ ] **路径配置**: 确认 base-href 设置正确
- [ ] **测试通过**: 运行 `flutter test` 确保测试通过
- [ ] **本地构建**: 本地运行 `flutter build web --release` 确保构建成功

### 部署后验证

- [ ] **页面加载**: 确认主页正常加载
- [ ] **导航功能**: 测试底部导航栏切换
- [ ] **响应式**: 测试不同屏幕尺寸的显示效果
- [ ] **功能测试**: 测试登录、演示账户等基本功能
- [ ] **性能检查**: 使用 Chrome DevTools 检查性能

## 🔍 常见问题排查

### Q1: 页面显示空白

**原因**: 通常是路径配置错误或资源文件找不到

**解决方案**:
```bash
# 检查base-href设置
flutter build web --release --base-href "/correct-repo-name/"

# 检查控制台错误信息
# 在Chrome中按F12查看Network和Console标签
```

### Q2: 字体或图标不显示

**原因**: 资源文件路径错误或缺失

**解决方案**:
```yaml
# 确认 pubspec.yaml 中的资源配置
flutter:
  assets:
    - assets/images/
    - assets/icons/
  fonts:
    - family: Geist
      fonts:
        - asset: assets/fonts/Geist-Regular.ttf
```

### Q3: GitHub Actions 构建失败

**原因**: 依赖版本冲突或Flutter版本不兼容

**解决方案**:
```yaml
# 更新 .github/workflows/deploy.yml 中的Flutter版本
- name: Setup Flutter
  uses: subosito/flutter-action@v2
  with:
    flutter-version: '3.19.0'  # 使用稳定版本
    channel: 'stable'
```

### Q4: CSS样式显示异常

**原因**: 缓存问题或CSS文件未正确加载

**解决方案**:
```bash
# 清除浏览器缓存
# 或者强制刷新 (Ctrl+F5)

# 检查web/index.html中的CSS引用
```

## 📊 性能优化建议

### 1. 构建优化

```bash
# 启用Web渲染器优化
flutter build web --release --web-renderer html

# 或使用canvaskit (更好的性能，但文件更大)
flutter build web --release --web-renderer canvaskit
```

### 2. 资源优化

- **图片压缩**: 使用WebP格式，压缩图片大小
- **字体子集**: 只加载需要的字符集
- **代码分割**: 按需加载模块

### 3. 缓存策略

```html
<!-- 在web/index.html中添加缓存头 -->
<meta http-equiv="Cache-Control" content="max-age=31536000">
```

## 🔄 更新部署

### 代码更新流程

1. **修改代码**
2. **本地测试**
   ```bash
   flutter run -d chrome
   ```
3. **构建验证**
   ```bash
   flutter build web --release
   ```
4. **提交推送**
   ```bash
   git add .
   git commit -m "Update: 描述更改内容"
   git push origin main
   ```
5. **自动部署** (GitHub Actions会自动触发)

### 版本管理

```bash
# 创建版本标签
git tag v1.0.0
git push origin v1.0.0

# 在pubspec.yaml中更新版本号
version: 1.0.0+1
```

## 📞 技术支持

如果部署过程中遇到问题，可以：

1. **检查控制台错误**: Chrome F12 -> Console
2. **查看构建日志**: GitHub Actions 中的详细日志
3. **参考官方文档**: [Flutter Web部署指南](https://docs.flutter.dev/deployment/web)

---

**祝您部署成功！🎉**

项目部署完成后，您将拥有一个专业的GMGN.AI克隆应用，具有完整的加密货币交易界面和功能。