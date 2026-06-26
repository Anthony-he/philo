# Philo Web — 哲学慰藉应用

> 可在浏览器中直接运行的哲学慰藉应用。每日一句古典哲学语录 + 心情匹配 + 情绪日记。

## 本地运行

双击 `index.html` 即可在浏览器中打开。

或者启动本地 HTTP 服务器（支持 Service Worker）：
```bash
npx serve .
# 或
python3 -m http.server 3000
# 或
npx http-server -p 3000
```

## 🚀 部署到线上（发布域名）

### 方式一：Vercel（推荐，免费）

1. 去 [vercel.com](https://vercel.com) 注册账号（用 GitHub 登录即可）
2. 安装 Vercel CLI 或直接网页部署
3. 执行：
```bash
# 安装 Vercel CLI
npm i -g vercel

# 部署
cd philo-web
vercel --prod
```
4. 按照提示登录、确认、等待部署完成
5. 你会得到一个 `xxx.vercel.app` 域名
6. **绑定你自己的域名**：在 Vercel 项目设置 → Domains → 输入你的域名（如 `philo.example.com`），按提示配置 DNS

或者最简单的方式：直接把 `philo-web` 文件夹拖到 [vercel.com/new](https://vercel.com/new) 网页上传即可。

### 方式二：Netlify

1. 去 [netlify.com](https://netlify.com) 注册
2. 拖拽 `philo-web` 文件夹到 Netlify 网页
3. 自动获得 `xxx.netlify.app` 域名
4. 设置 → Domain management → Add custom domain

### 方式三：GitHub Pages

```bash
# 创建 GitHub 仓库
gh repo create philo --public
# 上传代码
cd philo-web
git init
git add .
git commit -m "init"
git remote add origin https://github.com/你的用户名/philo.git
git push -u origin main
# 启用 GitHub Pages：仓库 Settings → Pages → 选择 main 分支
```

## 文件结构

```
philo-web/
├── index.html    ← 完整的 Web 应用（HTML + CSS + JS + 107条语录）
├── vercel.json   ← Vercel 部署配置
└── README.md     ← 本文件
```

## 后续可优化

- 添加数据库（替换 localStorage，实现多设备同步）
- 添加用户登录
- 增加更多语录
- 支持深色模式
- 添加心情趋势图表
- 国际化（英文版）
