#!/bin/bash
# build.sh - Flutter web 构建脚本
# 用法: ./build.sh [--no-web-resources-cdn] [--debug]

FLUTTER_ARGS=("build" "web")
INJECT_ARGS=()

for arg in "$@"; do
  case $arg in
    --no-web-resources-cdn)
      FLUTTER_ARGS+=("$arg")
      INJECT_ARGS+=("--local-assets")
      ;;
    --debug)
      FLUTTER_ARGS+=("$arg")
      ;;
  esac
done

echo "正在运行 Flutter 构建..."

flutter build web --no-web-resources-cdn


#  echo "正在注入加载页面..."
#  dart run tools/inject_loading_screen.dart "--local-assets"


echo "构建和注入完成!"