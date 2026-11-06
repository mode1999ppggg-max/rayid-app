<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CYBER_LUDO // SYSTEM_MAIN</title>
    <style>
        :root {
            --neon-pink: #ff007f;
            --neon-aqua: #00ffcc;
            --neon-yellow: #ffff00;
            --neon-purple: #9900ff;
            --bg-dark: #050512;
            --panel-bg: rgba(10, 10, 35, 0.9);
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Courier New', Courier, monospace;
        }

        body {
            background-color: var(--bg-dark);
            color: #fff;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            overflow-x: hidden;
            background-image: linear-gradient(rgba(255, 0, 127, 0.05) 1px, transparent 1px),
                              linear-gradient(90deg, rgba(255, 0, 127, 0.05) 1px, transparent 1px);
            background-size: 30px 30px;
        }

        /* شاشة الدخول */
        #login-screen {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(5, 5, 18, 0.95);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            z-index: 100;
            backdrop-filter: blur(10px);
            transition: all 0.5s ease;
        }

        .glitch-title {
            font-size: 3.5rem;
            font-weight: bold;
            text-transform: uppercase;
            color: #fff;
            text-shadow: 0 0 10px var(--neon-aqua), 0 0 20px var(--neon-pink);
            margin-bottom: 2rem;
            animation: pulse 2s infinite;
        }

        .setup-panel {
            background: var(--panel-bg);
            border: 2px solid var(--neon-aqua);
            padding: 2.5rem;
            border-radius: 10px;
            box-shadow: 0 0 30px rgba(0, 255, 204, 0.2);
            width: 400px;
            text-align: center;
        }

        .setup-panel h2 {
            color: var(--neon-pink);
            margin-bottom: 1.5rem;
            font-size: 1.2rem;
            letter-spacing: 2px;
        }

        .input-group {
            margin-bottom: 1.5rem;
            text-align: right;
        }

        .input-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--neon-aqua);
            font-size: 0.9rem;
        }

        .input-group select, .input-group input {
            width: 100%;
            padding: 0.8rem;
            background: rgba(0,0,0,0.5);
            border: 1px solid var(--neon-purple);
            color: #fff;
            border-radius: 5px;
            outline: none;
            font-size: 1rem;
        }

        .input-group select:focus {
            border-color: var(--neon-aqua);
            box-shadow: 0 0 10px var(--neon-aqua);
        }

        .btn-cyber {
            background: transparent;
            color: var(--neon-pink);
            border: 2px solid var(--neon-pink);
            padding: 1rem 2rem;
            font-size: 1.2rem;
            font-weight: bold;
            cursor: pointer;
            width: 100%;
            text-transform: uppercase;
            box-shadow: 0 0 15px rgba(255, 0, 127, 0.3);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .btn-cyber:hover {
            background: var(--neon-pink);
            color: #000;
            box-shadow: 0 0 30px var(--neon-pink);
        }

        /* واجهة اللعبة الرئيسية */
        #main-game-interface {
            display: none;
            opacity: 0;
            transition: opacity 0.5s ease;
            width: 100%;
            max-width: 1200px;
            padding: 20px;
            display: flex;
            flex-direction: row-reverse;
            justify-content: center;
            gap: 40px;
            align-items: center;
        }

        #game-board-wrapper {
            position: relative;
            border: 4px solid var(--neon-aqua);
            box-shadow: 0 0 25px rgba(0, 255, 204, 0.4);
            background: #06061a;
            border-radius: 8px;
        }

        canvas {
            display: block;
            cursor: pointer;
        }

        /* لوحة التحكم الجانبية */
        .side-panel {
            width: 350px;
            background: var(--panel-bg);
            border: 2px solid var(--neon-purple);
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 0 20px rgba(153, 0, 255, 0.2);
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .status-box {
            border: 1px solid rgba(255,255,255,0.1);
            padding: 15px;
            border-radius: 5px;
            background: rgba(0,0,0,0.3);
        }

        .status-title {
            font-size: 0.8rem;
            color: #888;
            margin-bottom: 5px;
        }

        #current-turn-display {
            font-size: 1.4rem;
            font-weight: bold;
            color: var(--neon-aqua);
            text-shadow: 0 0 10px var(--neon-aqua);
        }

        /* حاوية النرد النيون */
        .dice-container {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 20px;
            background: rgba(0, 0, 0, 0.4);
            border: 1px dashed var(--neon-pink);
            border-radius: 5px;
        }

        .cyber-dice {
            width: 70px;
            height: 70px;
            border: 3px solid var(--neon-pink);
            border-radius: 10px;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 2.2rem;
            font-weight: bold;
            color: #fff;
            text-shadow: 0 0 15px var(--neon-pink);
            box-shadow: 0 0 15px rgba(255, 0, 127, 0.4);
            transition: transform 0.1s ease;
            background: #110516;
            margin-bottom: 15px;
        }

        .rolling {
            animation: dice-spin 0.5s linear infinite;
        }

        .logs-box {
            height: 180px;
            overflow-y: auto;
            border: 1px solid rgba(255,255,255,0.1);
            padding: 10px;
            font-size: 0.8rem;
            background: #02020a;
            color: #00ff66;
            border-radius: 4px;
        }

        .log-entry {
            margin-bottom: 5px;
            border-bottom: 1px solid rgba(255,255,255,0.05);
            padding-bottom: 3px;
        }

        @keyframes dice-spin {
            0% { transform: rotate(0deg) scale(0.9); }
            50% { transform: rotate(180deg) scale(1.1); }
            100% { transform: rotate(360deg) scale(0.9); }
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; text-shadow: 0 0 15px var(--neon-aqua), 0 0 25px var(--neon-pink); }
            50% { opacity: 0.8; text-shadow: 0 0 5px var(--neon-aqua), 0 0 10px var(--neon-pink); }
        }

        /* لتجاوب الشاشات الصغيرة */
        @media (max-width: 1000px) {
            #main-game-interface {
                flex-direction: column-reverse;
                align-items: center;
            }
            .side-panel { width: 100%; max-width: 600px; }
        }
    </style>
</head>
<body>

    <!-- الشاشة الأولى: تسجيل الدخول وإعداد النظام -->
    <div id="login-screen">
        <div class="glitch-title">CYBER_LUDO // v2077</div>
        <div class="setup-panel">
            <h2>تأمين الوصول // INITIALIZATION</h2>
            
            <div class="input-group">
                <label>عدد بروتوكولات اللاعبين (Players)</label>
                <select id="player-count">
                    <option value="2">لاعبين اثنين (2P)</option>
                    <option value="3">3 لاعبين (3P)</option>
                    <option value="4" selected>4 لاعبين (4P)</option>
                </select>
            </div>

            <div class="input-group">
                <label>مستوى تدمير الخصوم (Combat Logic)</label>
                <select id="game-mode">
                    <option value="classic">كلاسيكي // CLASSIC NET</option>
                    <option value="hardcore">تدمير عنيف // HARDCORE BRUTAL</option>
                </select>
            </div>

            <button class="btn-cyber" onclick="bootSystem()">تشغيل اللعبة // BOOT_SYSTEM</button>
        </div>
    </div>

    <!-- واجهة اللعبة الأساسية واللوحة -->
    <div id="main-game-interface" style="display: none;">
        
        <!-- اللوحة الجانبية (التحكم والمعلومات) -->
        <div class="side-panel">
            <div class="status-box">
                <div class="status-title">النظام النشط الحالي // CURRENT_NODE</div>
                <div id="current-turn-display">جاري التحميل...</div>
            </div>

            <div class="dice-container">
                <div class="cyber-dice" id="visual-dice">-</div>
                <button class="btn-cyber" id="roll-button" onclick="executeDiceRoll()">تفعيل النرد // INJECT_DICE</button>
            </div>

            <div class="status-box">
                <div class="status-title">سجل العمليات // SYSTEM_LOGS</div>
                <div class="logs-box" id="system-logs">
                    <div class="log-entry">> تم تشغيل النواة المركزية بنجاح...</div>
                </div>
            </div>
        </div>

        <!-- لوحة الرسم الرئيسية اللودو -->
        <div id="game-board-wrapper">
            <canvas id="cyberLudoCanvas" width="600" height="600"></canvas>
        </div>

    </div>

    <script>
        // إعدادات البيئة والرموز الستة للشبكة العالمية للودو

let enemyPos = getTokenCurrentGridPos(p, enemyToken);
if (enemyPos.x === targetPos.x && enemyPos.y === targetPos.y) {
// حدوث عملية الأسر (Kill)
enemyToken.state = "base";
enemyToken.stepIndex = -1;
pushLog(عنيف! ${PLAYER_NAMES[activePlayer]} دمر رقاقة الخصم ${PLAYER_NAMES[p]} وأعادها لنقطة الصفر.);
}
}
});
}
}
// رسم اللوحة الأساسية والمربعات بأسلوب الـ Canvas
function renderCore() {
ctx.fillStyle = THEME.bg;
ctx.fillRect(0, 0, canvas.width, canvas.height);
// 1. رسم شبكة المربعات التفصيلية (15x15)
ctx.strokeStyle = THEME.grid;
ctx.lineWidth = 1;
for (let i = 0; i < 15; i++) {
for (let j = 0; j < 15; j++) {
ctx.strokeRect(i * size, j * size, size, size);
}
}
// 2. تلوين خلايا المسارات الخاصة لكل لاعب والمربعات الآمنة
GLOBAL_SAFESPOTS.forEach(spot => {
ctx.fillStyle = THEME.safe + "33";
ctx.fillRect(spot.x * size, spot.y * size, size, size);
ctx.strokeStyle = THEME.safe;
ctx.strokeRect(spot.x * size + 2, spot.y * size + 2, size - 4, size - 4);
});
// 3. رسم القواعد الأربعة الضخمة للاعبين
drawCyberBase(0, 0, 6, 6, THEME.p1, "PRTCL_PINK_01");
drawCyberBase(9, 0, 6, 6, THEME.p2, "CORE_AQUA_02");
drawCyberBase(9, 9, 6, 6, THEME.p3, "NODE_YEL_03");
drawCyberBase(0, 9, 6, 6, THEME.p4, "CELL_PURP_04");
// 4. رسم ممرات الصعود الداخلية نحو خط النهاية
for(let i=1; i<=5; i++) {
ctx.fillStyle = THEME.p1 + "22"; ctx.fillRect(7size, isize, size, size);
ctx.fillStyle = THEME.p2 + "22"; ctx.fillRect(isize, 7size, size, size);
ctx.fillStyle = THEME.p3 + "22"; ctx.fillRect(7*size, (14-i)*size, size, size);
ctx.fillStyle = THEME.p4 + "22"; ctx.fillRect((14-i)size, 7size, size, size);
}
// 5. رسم قلب المعالجة المركزي (مثلثات الفوز بالمنتصف)
ctx.fillStyle = "#111125";
ctx.beginPath();
ctx.moveTo(6size, 6size); ctx.lineTo(9size, 6size);
ctx.lineTo(7.5size, 7.5size); ctx.closePath(); ctx.fill();
// 6. رسم رقاقات اللعب الحالية لجميع المشاركين المتواجدين بالخريطة
for (let p = 1; p <= 4; p++) {
playerTokens[p].forEach(token => {
if (token.state !== "done") {
let pos = getTokenCurrentGridPos(p, token);
drawCyberPiece(pos.x, pos.y, THEME['p' + p], token.id + 1);
}
});
}
}
// تزيين القواعد الكبيرة بلمسات رقمية متوهجة ومؤشرات نصية سبرانية
function drawCyberBase(x, y, w, h, color, label) {
ctx.strokeStyle = color;
ctx.lineWidth = 3;
ctx.shadowBlur = 15;
ctx.shadowColor = color;
ctx.strokeRect(x * size + 6, y * size + 6, w * size - 12, h * size - 12);
ctx.fillStyle = color + "11";
ctx.fillRect(x * size + 6, y * size + 6, w * size - 12, h * size - 12);
ctx.shadowBlur = 0;
ctx.fillStyle = color;
ctx.font = "10px 'Courier New'";
ctx.fillText(// ${label}, x * size + 15, y * size + 25);
}
// رسم القطع بشكل معالج كمبيوتر دائري يتوسطه نواة مظلمة متوهجة نيون
function drawCyberPiece(gx, gy, color, num) {
let cx = gx * size + size / 2;
let cy = gy * size + size / 2;
ctx.shadowBlur = 12;
ctx.shadowColor = color;
ctx.fillStyle = color;
ctx.beginPath();
ctx.arc(cx, cy, size / 2.6, 0, Math.PI * 2);
ctx.fill();
ctx.shadowBlur = 0;
ctx.fillStyle = "#02020a";
ctx.beginPath();
ctx.arc(cx, cy, size / 5, 0, Math.PI * 2);
ctx.fill();
// رقم القطعة لتمييزها للاعب أثناء اتخاذ القرار بالتحريك
ctx.fillStyle = "#fff";
ctx.font = "bold 10px Arial";
ctx.textAlign = "center";
ctx.textBaseline = "middle";
ctx.fillText(num, cx, cy);
}
