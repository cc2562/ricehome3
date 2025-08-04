import 'dart:io';
import 'dart:async';
import 'dart:convert';

void main(List<String> args) async {

  final noCdn = Platform.environment['NO_CDN'] == 'true';
  final debugMode = Platform.environment['DEBUG'] == 'true';

  if (debugMode) {
    print('Starting build with options:');
    print('--no-web-resources-cdn: $noCdn');
  }

  // 1. 准备构建命令
  List<String> flutterArgs = ['build', 'web'];

  // 添加 --no-web-resources-cdn 参数
  if (noCdn) {
    flutterArgs.add('--no-web-resources-cdn');

    // 添加额外参数以优化本地资源加载
    flutterArgs.addAll([
      '--dart-define=FLUTTER_WEB_CANVASKIT_URL=assets/canvaskit/',
      '--dart-define=FLUTTER_WEB_USE_SKIA=true'
    ]);
  }

  if (debugMode) {
    print('Flutter build command: flutter ${flutterArgs.join(' ')}');
  }

  // 2. 运行Flutter构建命令
  final flutterProcess = await Process.start(
    'flutter',
    flutterArgs,
    runInShell: true,
  );

  // 转发输出
  flutterProcess.stdout.transform(utf8.decoder).listen(print);
  flutterProcess.stderr.transform(utf8.decoder).listen(print);

  // 等待构建完成
  final exitCode = await flutterProcess.exitCode;

  if (exitCode != 0) {
    print('Flutter build failed with exit code $exitCode');
    exit(exitCode);
  }

  // 3. 检查是否成功添加了本地资源
  if (noCdn) {
    final canvaskitDir = Directory('build/web/assets/canvaskit');
    if (!canvaskitDir.existsSync()) {
      print('Warning: CanvasKit assets not found!');
      print('Check that --no-web-resources-cdn is working correctly');
    } else {
      print('CanvasKit assets successfully bundled locally');
      if (debugMode) {
        print('Local assets:');
        canvaskitDir.listSync().forEach((f) => print('  ${f.path}'));
      }
    }
  }

  // 4. 运行注入脚本
  final injectArgs = ['run', 'tools/inject_loading_screen.dart'];
  if (noCdn) injectArgs.add('--local-assets');

  final injectProcess = await Process.start(
    'dart',
    injectArgs,
    runInShell: true,
  );

  injectProcess.stdout.transform(utf8.decoder).listen(print);
  injectProcess.stderr.transform(utf8.decoder).listen(print);

  final injectExitCode = await injectProcess.exitCode;

  if (injectExitCode != 0) {
    print('Injection script failed with exit code $injectExitCode');
    exit(injectExitCode);
  }

  print('Build and injection completed successfully!');

  // 5. 生成部署报告
  _generateDeploymentReport(noCdn);
}

void _generateDeploymentReport(bool noCdn) {
  final report = File('build/web/deployment_report.txt');
  final timestamp = DateTime.now().toIso8601String();

  String content = '''
Flutter Web Deployment Report
==============================
Timestamp: $timestamp
Build Mode: ${noCdn ? 'With local assets' : 'Using CDN resources'}
  
Important Notes:
${noCdn ?
  '* All CanvasKit resources are bundled locally in /assets/canvaskit\n' +
      '* You MUST ensure the server correctly serves these assets\n' +
      '* Asset paths must be correctly configured in index.html'
      :
  '* CanvasKit is loaded from Flutter CDN\n' +
      '* Ensure your network allows access to https://flutter-canvaskit.s3.amazonaws.com'
  }

Recommended Server Configuration:
${noCdn ?
  '1. Add cache headers for static assets:\n' +
      '   - assets/canvaskit: max-age=31536000 (1 year)\n' +
      '   - main.dart.js: max-age=86400 (1 day)\n' +
      '2. Use gzip/brotli compression for .js and .wasm files'
      :
  '1. Add Content Security Policy (CSP):\n' +
      '   script-src \'self\' https://flutter-canvaskit.s3.amazonaws.com;\n' +
      '   connect-src \'self\' https://flutter-canvaskit.s3.amazonaws.com;'
  }
  
Build Directory Size: ${_getDirectorySize('build/web')}
''';

  report.writeAsStringSync(content);
  print('Deployment report generated: build/web/deployment_report.txt');
}

String _getDirectorySize(String path) {
  final dir = Directory(path);
  if (!dir.existsSync()) return 'N/A';

  int size = 0;
  dir.listSync(recursive: true).forEach((f) {
    if (f is File) size += f.lengthSync();
  });

  if (size > 1024 * 1024) {
    return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
  } else {
    return '${(size / 1024).toStringAsFixed(2)} KB';
  }
}