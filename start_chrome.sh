#!/bin/bash
# 关闭所有 Chrome 进程
# pkill -f "Google Chrome"

# 启动 Chrome 并开启远程调试
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --remote-debugging-port=9222 &
