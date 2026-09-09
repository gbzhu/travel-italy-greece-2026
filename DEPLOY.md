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
git remote add origin https://github.com/gbzhu/travel-italy-greece-2026.git
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

## 四、国内访问：香港轻量服务器（无需备案）

`*.workers.dev` 在国内会被墙/限速，所以 Cloudflare 只作**境外入口**（旅行途中、海外访问最快）。
国内看/分享，用一台**香港**轻量服务器托管同一个仓库——香港服务器**无需 ICP 备案**，国内可稳定访问。
两个入口指向同一份代码，你 push 一次，两边都更新。

### A. 购买与开端口【浏览器，电脑/手机都行】
1. 腾讯云或阿里云买「轻量应用服务器」，**地域选香港**，镜像 **Ubuntu 22.04**，约 ¥24/月。
2. 控制台「防火墙 / 安全组」放行端口 **80** 和 **443**。
3. 设置登录密码，记下**公网 IP**。
4. （可选）想要 HTTPS + 好记域名：买个域名，把它解析（A 记录）到这台服务器 IP。**香港服务器即使绑域名也不需要备案。**

### B. 部署【必须在电脑上，用终端 SSH】
5. SSH 登录服务器：
   ```bash
   ssh ubuntu@你的服务器IP      # 有的镜像是 root@你的IP
   ```
6. 拉取仓库并运行一键脚本（脚本会装好 Caddy、拉代码、配好自动更新）：
   ```bash
   git clone https://github.com/gbzhu/travel-italy-greece-2026.git /tmp/italy
   # 编辑脚本顶部两行：REPO 填你的仓库地址；DOMAIN 有域名就填、没有留空
   nano /tmp/italy/deploy/server-setup.sh
   bash /tmp/italy/deploy/server-setup.sh
   ```
7. 完成后访问 `http://你的服务器IP`（填了域名则是 `https://你的域名`）。

> 说明：脚本用 **Caddy** 托管 `public/`，有域名会自动签发 HTTPS。
> 自动更新靠一条 cron：每 2 分钟 `git pull` 一次，所以你 push 后最多 2 分钟国内入口就更新。
> 因为页面里**不含任何确认号/证件号**，仓库设为公开最省事（cron 免密拉取）。若设为私有，需在服务器加一把只读 deploy key。

### C. 以后更新
和 Cloudflare 一样，你只需在电脑上 `git push`。
- 境外入口（Cloudflare）：几十秒自动上线
- 国内入口（香港服务器）：push 后 SSH 登录执行 `update-italy` 即可更新（也可手动 `cd /tmp/italy && git pull`）

---

## 步骤归属速查

| 步骤 | 在哪做 |
|---|---|
| 1 装 git | 电脑 |
| 2 首次 commit | 电脑 |
| 3 建 GitHub 空仓库 | 电脑/手机浏览器（建议电脑，接着要 push）|
| 4 push 代码 | **必须电脑** |
| 5 Cloudflare 连 Git 部署（境外入口）| 电脑/手机浏览器 |
| 6 买香港服务器 + 开端口 | 浏览器（电脑/手机）|
| 7 SSH 跑一键脚本（国内入口）| **必须电脑** |
| 日常更新 push | **必须电脑** |
