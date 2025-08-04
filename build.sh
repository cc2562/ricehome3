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
if [[ " ${FLUTTER_ARGS[@]} " =~ " --no-web-resources-cdn " ]]; then
  export NO_CDN=true
fi
if [[ " ${FLUTTER_ARGS[@]} " =~ " --debug " ]]; then
  export DEBUG=true
fi

# flutter "${FLUTTER_ARGS[@]}"
flutter build web --no-web-resources-cdn
# shellcheck disable=SC1073
if "%~1"=="--debug" set DEBUG=true
flutter !FLUTTER_ARGS!

if [ $? -ne 0 ]; then
  echo "Flutter 构建失败"
  exit 1
fi

echo "正在注入加载页面..."
dart run tools/inject_loading_screen.dart "${INJECT_ARGS[@]}"

if [ $? -ne 0 ]; then
  echo "注入脚本失败"
  exit 1
fi

echo "构建和注入完成!"