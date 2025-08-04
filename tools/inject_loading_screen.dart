import 'dart:io';
import 'dart:convert';

void main(List<String> args) {
  // 检查是否使用了本地资源
  final bool localAssets = args.contains('--local-assets');

  print('Injecting loading screen (local assets: $localAssets)...');

  // 1. 获取构建目录
  final projectDir = Directory.current.path;
  final buildDir = '$projectDir/build/web';

  // 2. 处理 index.html
  final indexFile = File('$buildDir/index.html');
  if (!indexFile.existsSync()) {
    print('Error: index.html not found in build directory!');
    exit(1);
  }

  // 备份原始文件
  indexFile.copySync('$buildDir/index.html.bak');

  var indexContent = indexFile.readAsStringSync();

  // 添加加载页面结构
  const loadingScreenHTML = '''
  <!-- Flutter Loading Screen (Auto-injected) -->
  <div id="loading-screen" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center; background: white; z-index: 9999; transition: opacity 0.5s;">
    <div class="spinner" style="border: 4px solid rgba(0, 0, 0, 0.1); width: 36px; height: 36px; border-radius: 50%; border-left-color: #09f; animation: spin 1s linear infinite;"></div>
    <p style="margin-top: 20px; font-family: sans-serif;">Loading application...</p>
  </div>
  <div id="flutter-host"></div>
  ''';

  // 修复正则表达式问题
  indexContent = indexContent.replaceFirstMapped(
      RegExp(r'<body(\s[^>]*)?>', caseSensitive: false),
          (match) => '<body${match.group(1) ?? ''}>$loadingScreenHTML'
  );

  // 添加CSS样式
  const loadingScreenCSS = '''
  <style>
    @keyframes spin {
      0% { transform: rotate(0deg); }
      100% { transform: rotate(360deg); }
    }
  </style>
  ''';

  indexContent = indexContent.replaceFirstMapped(
      RegExp(r'<head>', caseSensitive: false),
          (match) => '<head>$loadingScreenCSS'
  );

  // 3. 处理 flutter_bootstrap.js
  final bootstrapFile = File('$buildDir/flutter_bootstrap.js');
  if (!bootstrapFile.existsSync()) {
    print('Error: flutter_bootstrap.js not found!');
    exit(1);
  }

  // 备份原始文件
  bootstrapFile.copySync('$buildDir/flutter_bootstrap.js.bak');

  var bootstrapContent = bootstrapFile.readAsStringSync();

  // 添加加载逻辑
  String loaderLogic = '''
// ===== Loading Screen Logic (Auto-injected) =====
console.log('[LOADER] Starting Flutter loader...');
const loadingScreen = document.getElementById('loading-screen');

// 确保我们找到了加载页面
if (!loadingScreen) {
  console.error('[LOADER] Loading screen element not found!');
}

// 更新加载状态
function updateLoadingText(text) {
  console.log('[LOADER] ' + text);
  if (loadingScreen) {
    const textElement = loadingScreen.querySelector('p');
    if (textElement) textElement.textContent = text;
  }
}

// 隐藏加载页面的函数
function hideLoadingScreen() {
  if (!loadingScreen) {
    console.error('[LOADER] Cannot hide loading screen: element not found');
    return;
  }
  
  console.log('[LOADER] Hiding loading screen');
  
  // 添加淡出动画
  loadingScreen.style.opacity = "0";
  
  // 动画完成后移除元素
  setTimeout(() => {
    console.log('[LOADER] Removing loading screen');
    loadingScreen.style.display = 'none';
    
    // 可选：完全移除元素
    // loadingScreen.remove();
  }, 300);
}

// 初始化加载逻辑
updateLoadingText('正在加载，请稍后');

// 配置对象 - 根据是否使用本地资源调整
const loaderConfig = {
  hostElement: document.getElementById('flutter-host')
''';

//  if (localAssets) {
//    loaderLogic += ''',
//  canvasKitBaseUrl: "assets/canvaskit/",
//  canvasKitVariant: "full"
//''';
//  }

  loaderLogic += '''
};

// 关键修复：添加两种隐藏机制
try {
  _flutter.loader.load({
    config: loaderConfig,
    onEntrypointLoaded: async function(engineInitializer) {
      try {
        console.log('[LOADER] Flutter entrypoint loaded');
        updateLoadingText('初始化Flutter引擎...');
        
        // 初始化引擎
        const appRunner = await engineInitializer.initializeEngine();
        console.log('[LOADER] Engine initialized');
        
        updateLoadingText('即将呈现...');
        
        // 运行应用
        await appRunner.runApp();
        console.log('[LOADER] App running');
        
        // 方法1：在应用启动后立即隐藏加载页面
        hideLoadingScreen();
      } catch (error) {
        console.error('[LOADER] Error during initialization:', error);
       //updateLoadingText('Initialization error: ' + error.message);
       updateLoadingText('很快就好啦');
        hideLoadingScreen();
      }
    }
  });
} catch (e) {
  console.error('[LOADER] Error in loader setup:', e);
  updateLoadingText('Fatal loader error: ' + e.message);
  hideLoadingScreen();
}

// 方法2：监听Flutter的首帧渲染事件
window.addEventListener('flutter-first-frame', function() {
  console.log('[LOADER] Flutter first frame rendered - hiding loading screen');
  hideLoadingScreen();
});

// 方法3：超时后自动隐藏（安全网）
setTimeout(function() {
  console.log('[LOADER] Timeout reached - forcing hide of loading screen');
  hideLoadingScreen();
}, 10000); // 10秒后强制隐藏
''';

  // 确保只添加一次加载逻辑
  if (!bootstrapContent.contains('// ===== Loading Screen Logic')) {
    bootstrapContent += loaderLogic;
  }

  // 4. 保存修改后的文件
  indexFile.writeAsStringSync(indexContent);
  bootstrapFile.writeAsStringSync(bootstrapContent);

  // 5. 如果是本地资源模式，添加资源预加载
  if (localAssets) {
    _addResourcePreloading(buildDir, indexContent);
  }

  print('Successfully injected loading screen!');
}

void _addResourcePreloading(String buildDir, String indexContent) {
  // 查找所有需要预加载的资源
  final assetDir = Directory('$buildDir/assets');
  final preloadTags = StringBuffer();

  if (assetDir.existsSync()) {
    assetDir.listSync(recursive: true).whereType<File>().forEach((file) {
      final path = file.path.replaceFirst('$buildDir/', '');
      final extension = path.split('.').last;

      // 只预加载关键资源
      if (extension == 'wasm' || extension == 'js' || path.contains('canvaskit')) {
        final asType = extension == 'wasm' ? 'fetch' : 'script';
        preloadTags.writeln('<link rel="preload" href="$path" as="$asType" crossorigin="anonymous">');
      }
    });
  }

  if (preloadTags.isNotEmpty) {
    final updatedContent = indexContent.replaceFirstMapped(
        RegExp(r'</head>', caseSensitive: false),
            (match) => '$preloadTags</head>'
    );

    File('$buildDir/index.html').writeAsStringSync(updatedContent);
    print('Added ${preloadTags.toString().split('\n').length} resource preload tags');
  }
}