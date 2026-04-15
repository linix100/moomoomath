#!/bin/bash
# 小恐龙数学大冒险 - 启动服务器

PORT=8080
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "🦖 小恐龙数学大冒险 - 启动中..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Get local LAN IP (works on macOS and Linux)
if command -v ipconfig &>/dev/null; then
  # macOS
  IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "无法获取IP")
elif command -v hostname &>/dev/null; then
  # Linux
  IP=$(hostname -I 2>/dev/null | awk '{print $1}' || echo "无法获取IP")
else
  IP="请手动查询您的局域网IP"
fi

echo ""
echo "📡 本机访问地址:  http://localhost:$PORT"
echo "📱 局域网访问地址: http://$IP:$PORT"
echo ""
echo "其他设备（手机/平板/电脑）在同一WiFi下"
echo "打开浏览器输入上面的局域网地址即可访问！"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "按 Ctrl+C 停止服务器"
echo ""

cd "$SCRIPT_DIR"
python3 -m http.server $PORT --bind 0.0.0.0
