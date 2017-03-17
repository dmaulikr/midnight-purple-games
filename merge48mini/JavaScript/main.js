
var gameState = "menu";

function init() {
    initTouch();
    initGame();
}

function willTransistion(type) {
    print("will transition to " + type + " with a state of " + gameState);
    
    if (type == "expanded") {
        if (gameState == "pause") {
            document.getElementById("main_pause").style.display = "none";
            setTimeout(showGame, 300);
        }
    } else {
        if (gameState == "game") {
            document.getElementById("main_game").style.display = "none";
            document.getElementById("main_help").style.display = "none";
            setTimeout(showPause, 300);
        }
    }
}

function showCompact() {
    document.getElementById("main_compact").style.display = "block";
}

function showPause() {
    document.getElementById("main_pause").style.display = "block";
    gameState = "pause";
}

function showGame() {
    document.getElementById("main_game").style.display = "block";
    halfWidth = document.getElementById("grid_1_1").clientWidth / 2;
    gameState = "game";
}

function showHelp(element) {
    document.getElementById("main_game").style.display = "none";
    document.getElementById("main_help").style.display = "block";
}

function backFromHelp(element) {
    document.getElementById("main_help").style.display = "none";
    document.getElementById("main_game").style.display = "block";
}

function resumeFromPause(element) {
    document.getElementById("main_pause").style.display = "none";
    setTimeout(showGame, 300);
    swift("FullScreen", "{}");
}
