
var checkingRow, checkingCol, highestColorIndex, score;
var colors = [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048];
var halfWidth, littleMoreWidth, littleLessWidth;
var coins, highScore, dashHighScore;
var soundIndex = 0;
var timer = 0;
var timerHandle;
var isTimer = false;

function initGame() {
    score = 0;
    foundMatch = true;
    highestColorIndex = 0;
}

function startGame(element) {
    isTimer = false;
    document.getElementById("score").innerHTML = 0;
    score = 0;
    highestColorIndex = 0;
    clearGrid();
    document.getElementById("refresh").style.display = "none";
    document.getElementById("main_menu").style.display = "none";
    document.getElementById("main_overone").style.display = "none";
    document.getElementById("next_piece").setAttribute("bgcolor", "2");
    document.getElementById("timer").style.display = "none";
    halfWidth = document.getElementById("grid_1_1").clientWidth / 2;
    littleMoreWidth = halfWidth * 2.5;
    littleLessWidth = halfWidth / 2.5;
    playSound("tiny_button");
    swift("LevelStart", "");
}

function startTimer(element) {
    timer = 60;
    timerHandle = setInterval(runTimer, 1000);
    refreshTimerUI();
    removeClass("danger");
    isTimer = true;
    document.getElementById("timer").style.display = "block";
}

function runTimer() {
    --timer;
    refreshTimerUI();
    
    if (timer < 10) {
        document.getElementById("timer_value").classList.add("danger");
    }
    
    if (timer <= 0) {
        gameOver(true);
        clearInterval(timerHandle);
    }
}

function refreshTimerUI() {
    var seconds = timer % 60;
    var minutes = Math.floor(timer / 60);
    document.getElementById("timer_value").innerHTML = minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
}

function buySmallCoinPackage(element) {
    hidePurchaseBox(null);
    swift("BuySmallCoinPackage", "");
}

function buyLargeCoinPackage(element) {
    hidePurchaseBox(null);
    swift("BuyLargeCoinPackage", "");
}

function buyUnlimitedCoins(element) {
    hidePurchaseBox(null);
    swift("BuyUnlimitedCoins", "");
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                          ----------
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

function sendText(element) {
    playSound("tiny_button");
    swift("SendText", highScore);
}

function refreshBlock(element) {
    if (coins > 2) {
        coins -= 3;
        document.getElementById("coins").innerHTML = coins;
        
        var newBlock = 2;
        var oldBlock = parseInt(document.getElementById("next_piece").getAttribute("bgcolor"));
        
        if (highestColorIndex > 0) {
            var newArr = [];
            
            for (var i = 0; i <= highestColorIndex; i++) {
                if (oldBlock != colors[i]) {
                    newArr.push(colors[i]);
                }
            }
            
            newBlock = newArr[rand(newArr.length)];
        }
        
        document.getElementById("next_piece").setAttribute("bgcolor", newBlock);
        document.getElementById("next_piece").classList.add("spin");
        setTimeout(removeRefreshSpin, 120);
        swift("UpdateCoins", coins);
    } else {
        showPurchaseBox();
    }
}

function removeRefreshSpin() {
    document.getElementById("next_piece").classList.remove("spin");
}

function showInfoBox(msg) {
    document.getElementById("info_box").style.display = "block";
    document.getElementById("info_text").innerHTML = msg;
}

function showPurchaseBox() {
    document.getElementById("purchase_description").innerHTML = "You do not have enough coins for this feature!";
    document.getElementById("purchase_box").style.display = "block";
}

function showPurchaseBoxWithoutProblem(element) {
    showPurchaseBox();
    document.getElementById("purchase_description").innerHTML = "Buy more coins";
}

function hideInfoBox(element) {
    document.getElementById("info_box").style.display = "none";
}

function hidePurchaseBox(element) {
    document.getElementById("purchase_box").style.display = "none";
}

function exitGame(element) {
    document.getElementById("bottom_menu").classList.add("closed");
    document.getElementById("main_gameone").style.display = "none";
    document.getElementById("main_menu").style.display = "block";
    clearInterval(timerHandle);
    playSound("tiny_button");
}

function openBottomMenu(element) {
    document.getElementById("bottom_menu").classList.remove("closed");
    playSound("tiny_button");
}

function closeBottomMenu(element) {
    document.getElementById("bottom_menu").classList.add("closed");
    
    if (element.innerHTML == "cancel") {
        playSound("tiny_button");
    }
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                       Dragging next piece
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

function pickUpNextPiece(event) {
    document.getElementById("next_piece").classList.add("lifted");
    
    var x = event.touches[0].clientX - halfWidth;
    var y = event.touches[0].clientY - 120;
    
    document.getElementById("next_piece").style.left = x + "px";
    document.getElementById("next_piece").style.top = y + "px";
    foundMatch = true;
}

function dragNextPiece(event) {
    var x = event.touches[0].clientX - halfWidth;
    var y = event.touches[0].clientY - 120;
    
    if (x > document.body.clientWidth - littleMoreWidth) {
        x = document.body.clientWidth - littleMoreWidth;
    } else if (x < littleLessWidth) {
        x = littleLessWidth;
    }
    
    document.getElementById("next_piece").style.left = x + "px";
    document.getElementById("next_piece").style.top = y + "px";
    
    // hover over styles
    var hx = document.getElementById("next_piece").offsetLeft + halfWidth;
    var hy = document.getElementById("next_piece").offsetTop + halfWidth;
    document.getElementById("next_piece").classList.remove("lifted");
    var hoverPie = document.elementFromPoint(hx, hy);
    document.getElementById("next_piece").classList.add("lifted");
    
    if (hoverPie.className.indexOf("grid_item") != -1 && hoverPie.getAttribute("bgcolor") == null) {
        removeClass("hover_over");
        hoverPie.classList.add("hover_over");
    }
}

function dropNextPiece(event) {
    var x = document.getElementById("next_piece").offsetLeft + halfWidth;
    var y = document.getElementById("next_piece").offsetTop + halfWidth;
    document.getElementById("next_piece").classList.remove("lifted");
    var possibleDest = document.elementFromPoint(x, y);
    
    // NaN bug (when playing during big money)
    if (isNaN(possibleDest.getAttribute("bgcolor"))) {
        possibleDest.removeAttribute("bgcolor");
    }
    
    if (possibleDest.className.indexOf("grid_item") != -1 && possibleDest.getAttribute("bgcolor") == null) {
        if (soundIndex != 0) {
            finishCurrentAnimation();
        }
    
        var currentColor = document.getElementById("next_piece").getAttribute("bgcolor");
        possibleDest.setAttribute("bgcolor", currentColor);
        checkingRow = possibleDest.getAttribute("row");
        checkingCol = possibleDest.getAttribute("col");
        setTimeout(checkForMatchLater, 300);
        document.getElementById("next_piece").setAttribute("bgcolor", colors[rand(highestColorIndex)]);
        playSound("tiny_button");
    } else {
        playSound("error_drop");
    }
    
    // remove hover styles
    removeClass("hover_over");
}

function finishCurrentAnimation() {
    checkForMatchNow();
}

function checkForMatchNow() {
    if (checkForMatch(checkingRow, checkingCol)) {
        score += colors[highestColorIndex] / 4;
        score = Math.floor(score);
        document.getElementById("score").innerHTML = score;
        checkForMatchNow();
        document.getElementById("refresh").style.display = "block";
        playSound("note_" + ++soundIndex);
    } else {
        if (checkForFullGrid()) {
            gameOver(isTimer);
        }
        
        soundIndex = 0;
    }
}

function checkForMatchLater() {
    if (checkForMatch(checkingRow, checkingCol)) {
        score += colors[highestColorIndex] / 4;
        score = Math.floor(score);
        document.getElementById("score").innerHTML = score;
        setTimeout(checkForMatchLater, 350);
        document.getElementById("refresh").style.display = "block";
        playSound("note_" + ++soundIndex);
    } else {
        if (checkForFullGrid()) {
            gameOver(isTimer);
        }
        
        soundIndex = 0;
    }
}

function checkForFullGrid() {
    var found = 0;
    
    for (var r = 1; r < 5; r++) {
        for (var c = 1; c < 5; c++) {
            if (gridItemAt(r, c).hasAttribute("bgcolor")) {
                ++found;
            }
        }
    }
    
    return (found == 16);
}

function gameOver(withTimer) {
    clearInterval(timerHandle);
    document.getElementById("main_gameone").style.display = "none";
    document.getElementById("main_overone").style.display = "block";
    document.getElementById("ending_score").innerHTML = score;
    
    if (isTimer) {
        if (score > dashHighScore) {
            dashHighScore = score;
            document.getElementById("dash_high_score").innerHTML = score;
            swift("UpdateHighScoreWithTimer", score);
        }
    } else {
        if (score > highScore) {
            highScore = score;
            document.getElementById("high_score").innerHTML = score;
            swift("UpdateHighScore", score);
        }
    }
    
    var newCoins = Math.round(score / 1000);
    coins += newCoins;
    document.getElementById("coins").innerHTML = coins;
    document.getElementById("coin_gains").innerHTML = "+" + newCoins + " coins";
    swift("UpdateCoins", coins);
    
    if (isTimer) {
        document.getElementById("play_again_button").setAttribute("ontouchend", "tap(this,[navigateForward,startGame,startTimer])");
        swift("LevelEndWithTimer", score);
    } else {
        document.getElementById("play_again_button").setAttribute("ontouchend", "tap(this,[navigateForward,startGame])");
        swift("LevelEnd", score);
    }
    
    playSound("game_over");
}

function checkForMatch(x, y) {
    x = parseInt(x);
    y = parseInt(y);
    
    var found = false;
    var color = gridItemAt(x, y).getAttribute("bgcolor");
    var newColor = parseInt(color);

    if (x < 4 && color == gridItemAt(x + 1, y).getAttribute("bgcolor")) {
        gridItemAt(x + 1, y).removeAttribute("bgcolor");
        newColor *= 2;
        found = true;
    }
    
    if (y < 4 && color == gridItemAt(x, y + 1).getAttribute("bgcolor")) {
        gridItemAt(x, y + 1).removeAttribute("bgcolor");
        newColor *= 2;
        found = true;
    }
    
    if (x > 1 && color == gridItemAt(x - 1, y).getAttribute("bgcolor")) {
        gridItemAt(x - 1, y).removeAttribute("bgcolor");
        newColor *= 2;
        found = true;
    }
    
    if (y > 1 && color == gridItemAt(x, y - 1).getAttribute("bgcolor")) {
        gridItemAt(x, y - 1).removeAttribute("bgcolor");
        newColor *= 2;
        found = true;
    }
    
    if (newColor > 2048) {
        newColor = 2048;
    }
    
    if (found) {
        gridItemAt(x, y).setAttribute("bgcolor", newColor);
        var newHighestIndex = 0;
        
        if (newColor == 4) {
            newHighestIndex = 1;
        } else if (newColor == 8) {
            newHighestIndex = 2;
        } else if (newColor == 16) {
            newHighestIndex = 3;
        } else if (newColor == 32) {
            newHighestIndex = 4;
        } else if (newColor == 64) {
            newHighestIndex = 5;
        } else if (newColor == 128) {
            newHighestIndex = 6;
        } else if (newColor == 256) {
            newHighestIndex = 7;
        } else if (newColor == 512) {
            newHighestIndex = 8;
        } else if (newColor == 1024) {
            newHighestIndex = 9;
        } else if (newColor == 2048) {
            setTimeout(bigMoney, 800);
            document.getElementById("refresh").style.display = "none";
            playSound("hit");
        }
        
        if (newHighestIndex > highestColorIndex) {
            highestColorIndex = newHighestIndex;
        }
    }
    
    return found;
}

function clearSmallGrid() {
    var big = document.querySelector(".grid_item[bgcolor='2048']");
    
    if (big != null) {
        var r = parseInt(big.getAttribute("row"));
        var c = parseInt(big.getAttribute("col"));
        
        for (var x = r - 1; x <= r + 1; x++) {
            for (var y = c - 1; y <= c + 1; y++) {
                var elem = gridItemAt(x, y);
                
                if (elem != null) {
                    elem.removeAttribute("bgcolor");
                }
            }
        }
    }
}

function bigMoney() {
    newHighestIndex = 0;
    highestColorIndex = 0;
    clearSmallGrid();
    document.getElementById("next_piece").setAttribute("bgcolor", "2");
    score += 1000;
    document.getElementById("score").innerHTML = score;
    playSound("hit");
}

function gridItemAt(x, y) {
    return document.getElementById("grid_" + parseInt(x) + "_" + parseInt(y));
}

function rand(max) {
    return Math.floor(Math.random() * max);
}

function clearGrid() {
    var att = document.querySelectorAll(".grid_item[bgcolor]");
    
    for (var i = 0; i < att.length; i++) {
        if (!att[i].hasAttribute("donotdisurb")) {
            att[i].removeAttribute("bgcolor");
        }
    }
}
