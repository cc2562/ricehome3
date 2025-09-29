{{flutter_js}}
{{flutter_build_config}}

// 创建火箭飞向空间站的加载页面
function createRocketLoadingScreen() {
  const style = document.createElement('style');
  style.textContent = `
    .rocket-loading {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: linear-gradient(135deg, #0c0c2e 0%, #1a1a3e 50%, #2d1b69 100%);
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      z-index: 9999;
      font-family: Arial, sans-serif;
      overflow: hidden;
    }

    .mission-title {
      color: #fff;
      font-size: 24px;
      margin-bottom: 40px;
      text-align: center;
      font-weight: bold;
    }

    .rocket-container {
      position: relative;
      width: 70%;
      max-width: 500px;
      height: 100px;
      margin: 30px 0;
    }

    .rocket-track {
      position: absolute;
      top: 50%;
      left: 0;
      right: 0;
      height: 8px;
      background: rgba(255, 255, 255, 0.3);
      border-radius: 10px;
      transform: translateY(-50%);
      overflow: hidden;
    }

    .rocket-progress-fill {
      position: absolute;
      top: 0;
      left: 0;
      height: 100%;
      width: 0%;
      background: linear-gradient(90deg, #ff6b6b, #ee5a24, #ff9ff3);
      border-radius: 10px;
      transition: width 0.5s ease;
      box-shadow: 0 0 10px rgba(255, 107, 107, 0.4);
    }

    .rocket {
      position: absolute;
      top: 50%;
      left: 0;
      width: 80px;
      height: 50px;
      transform: translateY(-50%);
      transition: left 0.5s ease;
    }

    .rocket-body {
          width: 50px;
    height: 25px;
    background: #fff;
    border-top-left-radius: 20px;
    border-top-right-radius: 100px;
    border-bottom-left-radius: 20px;
    border-bottom-right-radius: 100px;
    position: relative;
    box-shadow: 0 0 15px rgba(255, 107, 107, 0.6);
    border: 2px solid #ff4757;
}
    }

    .rocket-nose {
      position: absolute;
      right: -8px;
      top: 50%;
      transform: translateY(-50%);
      width: 16px;
      height: 16px;
      background: #ff4757;
      border-radius: 50%;
      box-shadow: 0 0 8px rgba(255, 71, 87, 0.8);
    }

    .rocket-tail {
      position: absolute;
      left: -10px;
      top: 50%;
      transform: translateY(-50%);
      width: 16px;
      height: 16px;
      background: #ff4757;
      border-radius: 50%;
    }

    .rocket-window {
      position: absolute;
      right: 12px;
      top: 50%;
      transform: translateY(-50%);
      width: 8px;
      height: 8px;
      background: rgba(135, 206, 250, 0.9);
      border-radius: 50%;
      border: 1px solid #4a90e2;
    }

    .rocket-flame {
    position: absolute;
    left: -30px;
    top: 12px;
    width: 25px;
    height: 10px;
    background: linear-gradient(90deg, #ff9f9f, #f3ca68);
    border-radius: 50% 0 0 50%;
    animation: flame 0.2s infinite alternate;
    }

    @keyframes flame {
      0% { transform: translateY(-50%) scaleX(1); }
      100% { transform: translateY(-50%) scaleX(0.7); }
    }

    .progress-info {
      color: #fff;
      text-align: center;
      margin-top: 30px;
    }

    .progress-percent {
      font-size: 28px;
      font-weight: bold;
      margin-bottom: 10px;
    }

    .progress-status {
      font-size: 18px;
      opacity: 0.9;
    }

    .fade-out {
      animation: fadeOut 0.6s ease-out forwards;
    }

    @keyframes fadeOut {
      to { opacity: 0; visibility: hidden; }
    }
  `;
  
  document.head.appendChild(style);

  const container = document.createElement('div');
  container.className = 'rocket-loading';
  container.innerHTML = `
    <div class="mission-title">正在前往CC米饭的空间站</div>
    
    <div class="rocket-container">
      <div class="rocket-track">
        <div class="rocket-progress-fill"></div>
      </div>
      <div class="rocket">
        <div class="rocket-body">
        <div class="rocket-flame"></div>
          <div class="rocket-nose"></div>
          <div class="rocket-tail"></div>
          <div class="rocket-window"></div>
          
        </div>
      </div>
    </div>
    
    <div class="progress-info">
      <div class="progress-percent">0%</div>
      <div class="progress-status">准备发射...</div>
    </div>
  `;

  document.body.appendChild(container);
  return container;
}

// 更新火箭进度 - 修改为尾部对齐进度条
function updateRocketProgress(progress, status) {
  const rocket = document.querySelector('.rocket');
  const percent = document.querySelector('.progress-percent');
  const statusText = document.querySelector('.progress-status');
  const progressFill = document.querySelector('.rocket-progress-fill');
  
  if (rocket && percent && statusText && progressFill) {
    const container = document.querySelector('.rocket-container');
    const trackWidth = container.offsetWidth;
    const rocketWidth = 80;
    
    // 计算火箭位置，让尾部跟随进度条
    const rocketPosition = (progress * (trackWidth - rocketWidth) / 100)+50;
    rocket.style.left = rocketPosition + 'px';
    
    // 更新进度条填充 - 填充到火箭尾部位置
    const fillWidth = (progress * trackWidth / 100);
    progressFill.style.width = fillWidth + 'px';
    
    // 更新文字
    percent.textContent = Math.round(progress) + '%';
    statusText.textContent = status;
  }
}

// 移除加载页面
function removeRocketLoading() {
  const loading = document.querySelector('.rocket-loading');
  if (loading) {
    loading.classList.add('fade-out');
    setTimeout(() => loading.remove(), 600);
  }
}

// 创建加载页面
createRocketLoadingScreen();

// 加载状态
const loadingSteps = [
  { progress: 0, status: '准备发射...' },
  { progress: 20, status: '点火升空 🔥' },
  { progress: 45, status: '脱离大气层 🌍' },
  { progress: 70, status: '接近空间站 🛰️' },
  { progress: 95, status: '准备对接...' },
  { progress: 100, status: '欢迎来到空间站' }
];

let currentStep = 0;

// 模拟进度更新
const progressTimer = setInterval(() => {
  if (currentStep < loadingSteps.length - 2) {
    updateRocketProgress(loadingSteps[currentStep].progress, loadingSteps[currentStep].status);
    currentStep++;
  }
}, 800);

_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    clearInterval(progressTimer);
    updateRocketProgress(95, '准备对接...');
    
    await new Promise(resolve => setTimeout(resolve, 500));
    
    const appRunner = await engineInitializer.initializeEngine();
    updateRocketProgress(100, '欢迎来到空间站');
    
    await new Promise(resolve => setTimeout(resolve, 800));
    removeRocketLoading();
    
    await appRunner.runApp();
  }
});