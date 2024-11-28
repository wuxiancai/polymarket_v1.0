#!/bin/bash

# 设置颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}开始安装 Polymarket 自动交易程序...${NC}"

# 检查 Python3 是否安装
if ! command -v python3 &> /dev/null; then
    echo -e "${RED}未检测到 Python3，正在通过 Homebrew 安装...${NC}"
    if ! command -v brew &> /dev/null; then
        echo -e "${RED}未检测到 Homebrew，正在安装...${NC}"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install python3
fi

# 检查 Chrome 是否安装
if [ ! -d "/Applications/Google Chrome.app" ]; then
    echo -e "${YELLOW}未检测到 Google Chrome，正在安装...${NC}"
    brew install --cask google-chrome
fi

# 创建虚拟环境
echo -e "${GREEN}创建 Python 虚拟环境...${NC}"
python3 -m venv venv
source venv/bin/activate

# 升级 pip
echo -e "${GREEN}升级 pip...${NC}"
python3 -m pip install --upgrade pip

# 安装依赖
echo -e "${GREEN}安装依赖包...${NC}"
python3 -m pip install selenium
python3 -m pip install pyautogui

# 创建启动脚本
cat > start_chrome.sh << 'EOL'
#!/bin/bash
# 关闭所有 Chrome 进程
# pkill -f "Google Chrome"

# 启动 Chrome 并开启远程调试
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --remote-debugging-port=9222 &
EOL

# 创建运行脚本
cat > run.sh << 'EOL'
#!/bin/bash
# 激活虚拟环境
source venv/bin/activate

# 运行程序
python3 crypto_trader.py
EOL

# 设置脚本权限
chmod +x start_chrome.sh
chmod +x run.sh

# 创建日志目录
mkdir -p logs

echo -e "${GREEN}安装完成！${NC}"
echo -e "${YELLOW}使用说明:${NC}"
echo -e "1. 运行 ${GREEN}./start_chrome.sh${NC} 启动 Chrome 浏览器"
echo -e "2. 运行 ${GREEN}./run.sh${NC} 启动交易程序"
echo -e "当前程序目录: ${GREEN}$(pwd)${NC}" 