#!/usr/bin/env bash
# 香港轻量服务器一键部署（Ubuntu）。首次在服务器上运行一次即可。
# 用 Caddy 托管静态页：有域名自动 HTTPS；没域名就走 IP + HTTP。
# 之后每 2 分钟自动 git pull，你 push 到 GitHub 后自动上线。
set -euo pipefail

# ============ 只需改这两行 ============
REPO="https://github.com/你的用户名/travel-italy-greece-2026.git"
DOMAIN=""      # 有域名就填（如 trip.example.com，需先把域名解析到本机 IP）；留空则用 IP+HTTP
# =====================================

APP_DIR=/var/www/travel

echo ">> 1/4 安装 git 与 Caddy ..."
sudo apt-get update -y
sudo apt-get install -y git curl debian-keyring debian-archive-keyring apt-transport-https
if ! command -v caddy >/dev/null 2>&1; then
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
  curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list >/dev/null
  sudo apt-get update -y
  sudo apt-get install -y caddy
fi

echo ">> 2/4 拉取代码 ..."
sudo mkdir -p "$APP_DIR"
sudo chown -R "$USER" "$APP_DIR"
if [ -d "$APP_DIR/.git" ]; then
  git -C "$APP_DIR" pull --ff-only origin main
else
  git clone "$REPO" "$APP_DIR"
fi

echo ">> 3/4 写入 Caddy 配置 ..."
SITE="${DOMAIN:-:80}"
sudo tee /etc/caddy/Caddyfile >/dev/null <<EOF
$SITE {
    root * $APP_DIR/public
    file_server
    encode gzip
}
EOF
sudo systemctl restart caddy

echo ">> 4/4 设置每 2 分钟自动更新 ..."
( crontab -l 2>/dev/null | grep -v '# travel-auto-pull' ; \
  echo "*/2 * * * * cd $APP_DIR && git pull -q --ff-only origin main # travel-auto-pull" ) | crontab -

echo ""
echo "✅ 完成！访问：${DOMAIN:+https://$DOMAIN}${DOMAIN:-http://<你的服务器公网IP>}"
echo "   以后在电脑上 git push，服务器 2 分钟内自动更新。"
