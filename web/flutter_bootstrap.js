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
      background: #000000;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      z-index: 9999;
      font-family: Arial, sans-serif;
      overflow: hidden;
    }

    .progress-background-text {
      position: absolute;
      top: 50%;
      left: 50%;
      transform: translate(-50%, -50%);
      font-size: 20vw;
      font-weight: 900;
      color: rgba(255, 255, 255, 0.03);
      pointer-events: none;
      user-select: none;
      z-index: 1;
      font-family: 'Arial Black', Arial, sans-serif;
      letter-spacing: -0.05em;
    }

    .progress-corner {
      position: absolute;
      top: 30px;
      left: 30px;
      z-index: 10;
      color: #ffffff;
      font-family: 'Arial Black', Arial, sans-serif;
    }

    .progress-corner-percent {
      font-size: 8rem;
      font-weight: 900;
      line-height: 0.9;
      text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);
      margin-bottom: 5px;
    }

    .progress-corner-label {
      font-size: 2rem;
      font-weight: bold;
      opacity: 0.8;
      text-transform: uppercase;
      letter-spacing: 2px;
    }

    .mission-title {
      color: #fff;
      font-size: 2rem;
      text-align: left;
      font-weight: bold;
    }

    .rocket-container {
      position: relative;
      width: 95%;
      max-width: none;
      height: 100px;
      margin: 30px 0;
    }

    .rocket-track {
      position: absolute;
      top: 50%;
      left: 0;
      right: 0;
      height: 12px;
      background: rgba(255, 255, 255, 0.1);
      border-radius: 6px;
      transform: translateY(-50%);
      overflow: hidden;
      border: 1px solid rgba(255, 255, 255, 0.2);
    }

    .rocket-progress-fill {
      position: absolute;
      top: 0;
      left: 0;
      height: 100%;
      width: 0%;
      background: #ffffff;
      border-radius: 6px;
      transition: width 0.5s ease;
      box-shadow: 
        0 0 15px rgba(255, 255, 255, 0.3),
        inset 0 1px 0 rgba(255, 255, 255, 0.4),
        inset 0 -1px 0 rgba(255, 255, 255, 0.2);
      animation: progressGlow 2s ease-in-out infinite alternate;
    }

    @keyframes progressGlow {
      0% { 
        box-shadow: 
          0 0 15px rgba(255, 255, 255, 0.3),
          inset 0 1px 0 rgba(255, 255, 255, 0.4),
          inset 0 -1px 0 rgba(255, 255, 255, 0.2);
      }
      100% { 
        box-shadow: 
          0 0 25px rgba(255, 255, 255, 0.5),
          inset 0 1px 0 rgba(255, 255, 255, 0.6),
          inset 0 -1px 0 rgba(255, 255, 255, 0.4);
      }
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
      z-index: 5;
      position: relative;
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

    /* 响应式设计 */
    @media (max-width: 768px) {
      .progress-corner {
        top: 20px;
        left: 20px;
        right: 20px;
        width: auto;
      }
      
      .progress-corner-percent {
        font-size: 4rem;
      }
      
      .progress-corner-label {
        font-size: 1.2rem;
      }
      
      .mission-title {
        font-size: 1.5rem;
      }
      
      .progress-background-text {
        font-size: 25vw;
      }
      
      .rocket-container {
        width: 90%;
        margin: 20px 0;
      }
    }

    @media (max-width: 480px) {
      .progress-corner {
        top: 15px;
        left: 15px;
        right: 15px;
        padding: 10px 15px;
      }
      
      .progress-corner-percent {
        font-size: 3rem;
      }
      
      .progress-corner-label {
        font-size: 1rem;
        letter-spacing: 1px;
      }
      
      .mission-title {
        font-size: 1.2rem;
      }
      
      .progress-background-text {
        font-size: 30vw;
      }
      
      .rocket-container {
        width: 85%;
        height: 80px;
        margin: 15px 0;
      }
      
      .rocket {
        width: 60px;
        height: 40px;
      }
      
      .rocket-body {
        width: 40px;
        height: 20px;
      }
    }
  `;
  
  document.head.appendChild(style);

  const container = document.createElement('div');
  container.className = 'rocket-loading';
  container.innerHTML = `
    <div class="progress-background-text">0%</div>
    
    <div class="progress-corner">
      <div class="progress-corner-percent">0%</div>
      <div class="progress-corner-label">准备发射</div>
      <div class="mission-title">正在前往CC米饭的空间站</div>
    </div>
    
    
    
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
  `;

  document.body.appendChild(container);
  return container;
}

// 更新火箭进度 - 修改为尾部对齐进度条
function updateRocketProgress(progress, status) {
  const rocket = document.querySelector('.rocket');
  const percent = document.querySelector('.progress-corner-percent');
  const statusText = document.querySelector('.progress-corner-label');
  const progressFill = document.querySelector('.rocket-progress-fill');
  const cornerPercent = document.querySelector('.progress-corner-percent');
  const backgroundText = document.querySelector('.progress-background-text');
  
  if (rocket && percent && statusText && progressFill) {
    const container = document.querySelector('.rocket-container');
    const trackWidth = container.offsetWidth;
    const rocketWidth = 120;
    
    // 简化火箭位置计算，让火箭尾部跟随进度条末端
    const rocketPosition = (progress * (trackWidth - rocketWidth) / 100+80);
    rocket.style.left = rocketPosition + 'px';
    
    // 更新进度条填充 - 填充到火箭尾部位置
    const fillWidth = (progress * trackWidth / 100);
    progressFill.style.width = fillWidth + 'px';
    
    // 更新所有文字显示
    const progressText = Math.round(progress) + '%';
    percent.textContent = progressText;
    statusText.textContent = status;
    
    // 更新左上角进度显示
    if (cornerPercent) {
      cornerPercent.textContent = progressText;
    }
    
    // 更新背景装饰文字
    if (backgroundText) {
      backgroundText.textContent = progressText;
    }
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

// 加载状态和对应的状态文字
const loadingSteps = [
  { progress: 0, status: '准备发射...' },
  { progress: 20, status: '点火升空 🔥' },
  { progress: 45, status: '脱离大气层 🌍' },
  { progress: 70, status: '接近空间站 🛰️' },
  { progress: 90, status: '准备对接...' },
  { progress: 100, status: '欢迎来到空间站' }
];

let currentProgress = 0;
let targetProgress = 90; // 初始目标进度90%
let currentStepIndex = 0;

// 获取当前进度对应的状态文字
function getCurrentStatus(progress) {
  for (let i = loadingSteps.length - 1; i >= 0; i--) {
    if (progress >= loadingSteps[i].progress) {
      return loadingSteps[i].status;
    }
  }
  return loadingSteps[0].status;
}

// 平滑进度更新 - 更真实的加载曲线
const progressTimer = setInterval(() => {
  if (currentProgress < 99) { // 最多增长到99%
    let increment;
    
    if (currentProgress < 40) {
      // 0-40%：正常速度
      increment = Math.random() * 1.2 + 0.6;
    } else if (currentProgress < 60) {
      // 40-60%：较慢速度（模拟复杂资源加载）
      increment = Math.random() * 0.3 + 0.2;
    } else if (currentProgress < 85) {
      // 60-90%：恢复正常速度
      increment = Math.random() * 1.0 + 0.5;
      // 当接近90%时，将目标设为99%
      if (currentProgress >= 85) {
        targetProgress = 99;
      }
    } else {
      // 90-99%：极慢速度（等待最终初始化）
      increment = Math.random() * 0.01 + 0.01;
    }
    
    currentProgress = Math.min(currentProgress + increment, 99);
    
    const status = getCurrentStatus(currentProgress);
    updateRocketProgress(currentProgress, status);
  }
}, 60);

_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    clearInterval(progressTimer);
    
    // 如果当前进度小于90%，则设为90%，否则保持当前进度
    const finalProgress = Math.max(currentProgress, 90);
    updateRocketProgress(finalProgress, '准备对接...');

    const appRunner = await engineInitializer.initializeEngine();
    updateRocketProgress(100, '欢迎来到空间站');
    
    await new Promise(resolve => setTimeout(resolve, 400));
    removeRocketLoading();
    
    await appRunner.runApp();
  }
});