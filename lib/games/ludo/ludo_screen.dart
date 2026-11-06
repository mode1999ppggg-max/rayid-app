<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>VS AI CYBER ARENA</title>
    <link href="https://fonts.googleapis.com/css2?family=Cairo:wght@400;700;900&display=swap" rel="stylesheet">
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Cairo', sans-serif;
        }

        body {
            background-color: #0A0E0D;
            color: #ffffff;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            overflow: hidden;
        }

        .cyber-container {
            width: 100%;
            max-width: 480px;
            height: 100vh;
            background: linear-gradient(135deg, #0A0E0D 0%, #050807 100%);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 12px;
            border: 2px solid rgba(0, 230, 118, 0.4);
            box-shadow: 0 0 25px rgba(0, 230, 118, 0.2);
        }

        /* شريط الرأس */
        .cyber-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #080C0B;
            padding: 10px 14px;
            border-radius: 12px;
            border: 1px solid rgba(0, 229, 255, 0.3);
        }

        .room-id {
            font-size: 11px;
            color: #a0a0a0;
        }

        .game-title {
            font-size: 13px;
            font-weight: 900;
            color: #00E5FF;
            letter-spacing: 1px;
        }

        .exit-btn {
            background: none;
            border: none;
            color: #00E676;
            font-size: 16px;
            cursor: pointer;
        }

        /* عداد النقاط العلوي */
        .score-board {
            display: flex;
            justify-content: space-between;
            gap: 6px;
            margin: 8px 0;
        }

        .badge {
            flex: 1;
            padding: 6px 4px;
            border-radius: 8px;
            font-size: 10px;
            font-weight: bold;
            text-align: center;
            background-color: #121816;
            border: 1px solid currentColor;
        }

        .green-badge { color: #00E676; }
        .yellow-badge { color: #FFD54F; }
        .red-badge { color: #FF5252; }
        .blue-badge { color: #40C4FF; }

        /* مؤشر الدور */
        .turn-indicator-box {
            background-color: #050709;
            padding: 8px;
            text-align: center;
            border-radius: 8px;
            border: 1px dashed #00E5FF;
            margin-bottom: 8px;
        }

        #turn-text {
            font-size: 12px;
            font-weight: bold;
            color: #00E676;
        }

        /* ساحة اللعب */
        .cyber-arena {
            flex: 1;
            background-color: #050709;
            border-radius: 16px;
            border: 2px solid #00E676;
            box-shadow: inset 0 0 15px rgba(0, 230, 118, 0.2), 0 0 15px rgba(0, 230, 118, 0.3);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            padding: 12px;
            position: relative;
        }

        .board-grid {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .player-box {
            width: 44%;
            height: 110px;
            background-color: #121816;
            border-radius: 14px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .yellow-box { border-color: #FFD54F; }
        .green-box { border-color: #00E676; }
        .blue-box { border-color: #40C4FF; }
        .red-box { border-color: #FF5252; }

        .player-box.active-turn {
            transform: scale(1.05);
            box-shadow: 0 0 15px currentColor;
        }

        .shield-icon {
            font-size: 22px;
            margin-bottom: 4px;
        }

        .box-name {
            font-size: 11px;
            font-weight: bold;
            margin-bottom: 4px;
        }

        .step-counter {
            font-size: 10px;
            background-color: #0A0E0D;
            padding: 2px 8px;
            border-radius: 6px;
            color: #fff;
        }

        /* الموصلات العمودية */
        .vertical-connector {
            width: 35px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            gap: 4px;
        }

        .conn-bar {
            height: 10px;
            background-color: rgba(0, 229, 255, 0.3);
            border-radius: 2px;
            border: 1px solid rgba(0, 229, 255, 0.5);
        }

        /* منطقة الأمان المركزية */
        .center-home-hub {
            background-color: #080C0B;
            padding: 8px;
            text-align: center;
            border-radius: 10px;
            border: 1px solid rgba(255, 215, 0, 0.4);
        }

        .center-home-hub span {
            font-size: 10px;
            font-weight: 900;
            color: #FFD54F;
            letter-spacing: 0.5px;
        }

        /* شريط التحكم السفلي */
        .cyber-footer {
            display: flex;
            gap: 8px;
            margin-top: 8px;
        }

        .control-btn {
            flex: 1;
            padding: 10px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: bold;
            cursor: pointer;
            border: none;
            transition: 0.2s;
        }

        .action-btn {
            background-color: #00E676;
            color: #000;
        }

        .action-btn:hover {
            background-color: #00c853;
        }

        .reset-btn {
            background-color: #121816;
            color: #FF5252;
            border: 1px solid #FF5252;
        }

        .reset-btn:hover {
            background-color: rgba(255, 82, 82, 0.1);
        }
    </style>
</head>
<body>

    <div class="cyber-container">
        <!-- شريط الرأس (Header) -->
        <header class="cyber-header">
            <span class="room-id">الغرفة: #88219</span>
            <h1 class="game-title">VS AI CYBER ARENA</h1>
            <button class="exit-btn" onclick="exitGame()">➔</button>
        </header>

        <!-- عداد النقاط العلوي -->
        <section class="score-board">
            <div class="badge green-badge">أخضر: <span id="score-green">0</span></div>
            <div class="badge yellow-badge">أصفر: <span id="score-yellow">0</span></div>
            <div class="badge red-badge">أحمر: <span id="score-red">0</span></div>
            <div class="badge blue-badge">أزرق: <span id="score-blue">0</span></div>
        </section>

        <!-- مؤشر الدور -->
        <div class="turn-indicator-box">
            <span id="turn-text">دور اللاعب: أخضر (رائد)</span>
        </div>

        <!-- ساحة اللعب (Arena) -->
        <main class="cyber-arena">
            <div class="board-grid">
                <!-- المربع العلوي الأيسر (أصفر) -->
                <div class="player-box yellow-box" id="box-yellow" onclick="handlePlayerClick(1)">
                    <div class="shield-icon">🛡️</div>
                    <div class="box-name">أصفر</div>
                    <div class="step-counter">الخطوة: <span id="steps-yellow">0</span></div>
                </div>

                <!-- الموصل العمودي الأيمن -->
                <div class="vertical-connector">
                    <div class="conn-bar"></div><div class="conn-bar"></div><div class="conn-bar"></div><div class="conn-bar"></div>
                </div>

                <!-- المربع العلوي الأيمن (أخضر) -->
                <div class="player-box green-box active-turn" id="box-green" onclick="handlePlayerClick(0)">
                    <div class="shield-icon">🛡️</div>
                    <div class="box-name">أخضر (رائد)</div>
                    <div class="step-counter">الخطوة: <span id="steps-green">0</span></div>
                </div>
            </div>

            <!-- منطقة الأمان السيبرانية في المنتصف -->
            <div class="center-home-hub">
                <span>⚡ منطقة الأمان السيبرانية (HOME) ⚡</span>
            </div>

            <div class="board-grid">
                <!-- المربع السفلي الأيسر (أزرق) -->
                <div class="player-box blue-box" id="box-blue" onclick="handlePlayerClick(3)">
                    <div class="shield-icon">🛡️</div>
                    <div class="box-name">أزرق</div>
                    <div class="step-counter">الخطوة: <span id="steps-blue">0</span></div>
                </div>

                <!-- الموصل العمودي الأيسر -->
                <div class="vertical-connector">
                    <div class="conn-bar"></div><div class="conn-bar"></div><div class="conn-bar"></div><div class="conn-bar"></div>
                </div>

                <!-- المربع السفلي الأيمن (أحمر) -->
                <div class="player-box red-box" id="box-red" onclick="handlePlayerClick(2)">
                    <div class="shield-icon">🛡️</div>
                    <div class="box-name">أحمر</div>
                    <div class="step-counter">الخطوة: <span id="steps-red">0</span></div>
                </div>
            </div>
        </main>

        <!-- شريط التحكم السفلي -->
        <footer class="cyber-footer">
            <button class="control-btn action-btn" onclick="rollDiceAndMove()">تأكيد الإجراء / رمي النرد</button>
            <button class="control-btn reset-btn" onclick="resetGame()">إعادة التعيين</button>
        </footer>
    </div>

    <script>
        // حالة اللعبة وبيانات اللاعبين الأربعة (0: أخضر، 1: أصفر، 2: أحمر، 3: أزرق)
        const playerNamesList = ["أخضر (رائد)", "أصفر", "أحمر", "أزرق"];
        let currentTurnIndex = 0; // يبدأ دور الأخضر افتراضياً

        let steps = [0, 0, 0, 0];
        let scores = [0, 0, 0, 0];

        const maxStepsToSecure = 5; // الحد لتأمين الخطوات والحصول على نقطة

        function updateUI() {
            // تحديث الخطوات في الواجهة
            document.getElementById('steps-green').innerText = steps[0];
            document.getElementById('steps-yellow').innerText = steps[1];
            document.getElementById('steps-red').innerText = steps[2];
            document.getElementById('steps-blue').innerText = steps[3];

            // تحديث النقاط في الواجهة العلويّة
            document.getElementById('score-green').innerText = scores[0];
            document.getElementById('score-yellow').innerText = scores[1];
            document.getElementById('score-red').innerText = scores[2];
            document.getElementById('score-blue').innerText = scores[3];

            // تحديث نص مؤشر الدور
            document.getElementById('turn-text').innerText = `دور اللاعب: ${playerNamesList[currentTurnIndex]}`;

            // تحديث الإضاءة النيون وتأثير التميز لمربع الدور الحالي
            const boxIds = ['box-green', 'box-yellow', 'box-red', 'box-blue'];
            boxIds.forEach((id, idx) => {
                const boxElement = document.getElementById(id);
                if (idx === currentTurnIndex) {
                    boxElement.classList.add('active-turn');
                } else {
                    boxElement.classList.remove('active-turn');
                }
            });
        }

        // التعامل مع الضغط اليدوي على مربعات اللاعبين
        function handlePlayerClick(playerIndex) {
            if (playerIndex !== currentTurnIndex) {
                alert(`تنبيه: ليس دورك! الدور الحالي لـ (${playerNamesList[currentTurnIndex]})`);
                return;
            }
            executeMove(playerIndex);
        }

        // زر تأكيد الإجراء / رمي النرد التلقائي
        function rollDiceAndMove() {
            executeMove(currentTurnIndex);
        }

        // تنفيذ خطوة الحركة وفحص شروط التأمين وتناوب الأدوار
        function executeMove(playerIndex) {
            steps[playerIndex]++;

            // إذا وصل اللاعب للحد الأقصى للخطوات (مثلاً 5 خطوات)
            if (steps[playerIndex] >= maxStepsToSecure) {
                steps[playerIndex] = 0; // تصفير الخطوات
                scores[playerIndex]++;  // زيادة نقطة التأمين في العداد العلوي
                alert(`رائع! اللاعب (${playerNamesList[playerIndex]}) نجح في تأمين منطقته وحصل على نقطة!`);
            }

            // الانتقال التلقائي للدور التالي بالتتابع (0 -> 1 -> 2 -> 3 -> 0)
            currentTurnIndex = (currentTurnIndex + 1) % 4;

            updateUI();
        }

        // زر إعادة التعيين الكامل للعبة
        function resetGame() {
            steps = [0, 0, 0, 0];
            scores = [0, 0, 0, 0];
            currentTurnIndex = 0;
            updateUI();
        }

        function exitGame() {
            if(confirm("هل أنت متأكد من الخروج من الساحة؟")) {
                window.location.reload();
            }
        }

        // التشغيل الأولي لتحديث الواجهة عند التحميل
        window.onload = function() {
            updateUI();
        };
    </script>
</body>
</html>
