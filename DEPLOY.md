# 部署说明 · 意大利希腊旅行手册

单个静态 HTML（`public/index.html`），通过 Cloudflare Workers + GitHub 自动发布。
以后你每次 `git push`，Cloudflare 自动重新上线。

---

## 一、必须在【电脑】上做的步骤

> 因为要用命令行 push 代码，这几步必须在电脑上完成。

### 1. 确认已装 git
```bash
git --version    # Mac 一般自带；没有就装 Xcode Command Line Tools
```

### 2. 首次提交（项目已 git init，文件已就位）
```bash
cd /Users/I342202/travel-italy-greece-2026
git add -A
git commit -m "init travel handbook"
```
（若第一次用 git，先设身份：
`git config --global user.name "你的名字"`；
`git config --global user.email "你的邮箱"`）

### 3. 在 GitHub 新建一个【空】仓库
- 打开 https://github.com/new
- 仓库名随意，例如 `travel-italy-greece-2026`
- **不要**勾选 "Add README / .gitignore / license"（保持空）
- 建好后复制它给出的仓库地址（形如 `https://github.com/你/仓库.git`）

### 4. 关联远程并推送
```bash
git remote add origin https://github.com/你的用户名/travel-italy-greece-2026.git
git branch -M main
git push -u origin main
```

---

## 二、可在【电脑或手机浏览器】做，建议电脑

### 5. 用 Cloudflare 连接 GitHub 自动部署
- 登录 https://dash.cloudflare.com （没账号先免费注册）
- 左侧 **Workers & Pages** → **Create** → 选 **Workers** → **Connect to Git**
- 授权 GitHub，选中刚才的仓库
- 构建设置（一般自动识别 `wrangler.toml`）：
  - Build command：留空
  - Deploy command：`npx wrangler deploy`
- 点 **Save and Deploy**

### 6. 拿到公开网址
部署成功后得到：
```
https://travel-italy-greece-2026.<你的子域>.workers.dev
```
任何人点开即可看，无需登录、无需装 App。手机能加到主屏当图标用。

---

## 三、以后怎么更新

我改完页面后，你只需在电脑上：
```bash
git add -A && git commit -m "update" && git push
```
push 完 Cloudflare 自动重新发布，几十秒后新版上线。

---

## 步骤归属速查

| 步骤 | 在哪做 |
|---|---|
| 1 装 git | 电脑 |
| 2 首次 commit | 电脑 |
| 3 建 GitHub 空仓库 | 电脑/手机浏览器（建议电脑，接着要 push）|
| 4 push 代码 | **必须电脑** |
| 5 Cloudflare 连 Git 部署 | 电脑/手机浏览器（建议电脑）|
| 6 拿网址 | 任意 |
| 日常更新 push | **必须电脑** |
