
var checkingRow, checkingCol, highestColorIndex, score;
var colors = [2, 4, 8, 16, 32, 64, 128, 256, 512, 1024, 2048];
var halfWidth, littleMoreWidth, littleLessWidth;
var soundIndex = 0;
var latestMatchedColor = 0;
var futurePiece = 0;

function initGame() {
    score = 0;
    foundMatch = true;
    highestColorIndex = 0;
}

function startNewGame(element) {
    startGameWith("0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0", 0, 0, false);
    playSound("tiny_button");
    setTimeout(showGame, 500);
    swift("FullScreen", "{}");
}

function startGameWith(grid, you_score, themScore, theirTurn) {
    document.getElementById("main_compact").style.display = "none";
    document.getElementById("score").innerHTML = you_score;
    document.getElementById("them_score").innerHTML = themScore;
    score = parseInt(you_score);
    highestColorIndex = getHighestColorIndex(grid);
    
    if (highestColorIndex < 3) {
        highestColorIndex += 2;
    }
    
    loadGrid(grid);
    littleMoreWidth = halfWidth * 2.5;
    littleLessWidth = halfWidth / 2.5;
    
    if (checkForFullGrid()) {
        document.getElementById("help_button").style.display = "none";
        document.getElementById("next_piece_holder").classList.add("full_width");
        document.getElementById("future_piece_holder").style.display = "none";
        
        if (score > themScore) {
            document.getElementById("next_piece_holder").innerHTML = "<div class='their_turn_banner'>You win!</div>";
        } else {
            document.getElementById("next_piece_holder").innerHTML = "<div class='their_turn_banner'>You lose</div>";
        }
    } else {
        if (theirTurn) {
            document.getElementById("next_piece_holder").innerHTML = "<div class='their_turn_banner'>their turn</div>";
            document.getElementById("next_piece_holder").classList.add("full_width");
            document.getElementById("future_piece_holder").style.display = "none";
        } else {
            refreshBlock(null);
        }
    }
}

function loadGameFromMessage(grid, you_score, them_score, theirTurn) {
    showGame();
    startGameWith(grid, you_score, them_score, theirTurn);
}

function refreshBlock(element) {
    var newBlock = colors[rand(highestColorIndex % colors.length)];
    var partialColors = cloneWithout(colors, newBlock);
    futurePiece = partialColors[rand(highestColorIndex % partialColors.length)];
    document.getElementById("next_piece").setAttribute("bgcolor", newBlock);
    document.getElementById("future_piece").setAttribute("bgcolor", futurePiece);
}

function cloneWithout(arr, bad) {
    var newArr = [];
    
    for (var i = 0; i < arr.length; i++) {
        if (arr[i] != bad) {
            newArr.push(arr[i]);
        }
    }
    
    return newArr;
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
        
        if (futurePiece == 0) {
            document.getElementById("next_piece_holder").innerHTML = "";
        } else {
            setFuturesToNow();
        }

        playSound("tiny_button");
    } else {
        playSound("error_drop");
    }
    
    // remove hover styles
    removeClass("hover_over");
}

function sendMessage() {
    document.getElementById("top_info_holder").style.display = "none";
    document.getElementById("help_button").style.display = "none";
    document.getElementById("future_piece_holder").style.display = "none";
    document.getElementById("top_info_spacer").style.display = "block";
    setTimeout(callSwiftWithSendMessage, 100);
}

function callSwiftWithSendMessage() {
    var themScore = document.getElementById("them_score").innerHTML;
    document.getElementById("top_info_holder").innerHTML = "<div>&nbsp;</div><div>&nbsp;</div>";
    swift('SendMessage', '{"score":"' + score + '","them_score":"' + themScore + '","grid":"' + exportGrid() + '"}');
}

function finishCurrentAnimation() {
    checkForMatchNow();
}

function checkForMatchNow() {
    if (checkForMatch(checkingRow, checkingCol)) {
        score += latestMatchedColor;
        score = Math.floor(score);
        document.getElementById("score").innerHTML = score;
        checkForMatchNow();
        playSound("note_" + ++soundIndex);
    } else {
        if (checkForFullGrid()) {
            gameOver();
            sendMessage();
        } else {
            if (futurePiece == 0) {
                sendMessage();
            } else {
                futurePiece = 0;
            }
        }
        
        soundIndex = 0;
    }
}

function checkForMatchLater() {
    if (checkForMatch(checkingRow, checkingCol)) {
        score += latestMatchedColor;
        score = Math.floor(score);
        document.getElementById("score").innerHTML = score;
        setTimeout(checkForMatchLater, 350);
        playSound("note_" + ++soundIndex);
    } else {
        if (checkForFullGrid()) {
            gameOver();
            sendMessage();
        } else {
            if (futurePiece == 0) {
                sendMessage();
            } else {
                futurePiece = 0;
            }
        }
        
        soundIndex = 0;
    }
}

function setFuturesToNow() {
    document.getElementById("future_piece_holder").style.display = "none";
    document.getElementById("next_piece").setAttribute("bgcolor", futurePiece);
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

function gameOver() {
    document.getElementById("next_piece_holder").innerHTML = "<div class='their_turn_banner'>game over</div>";
    document.getElementById("next_piece_holder").classList.add("full_width");
    document.getElementById("future_piece_holder").style.display = "none";
    document.getElementById("help_button").style.display = "none";
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
            playSound("hit");
        }
        
        if (newHighestIndex > highestColorIndex) {
            highestColorIndex = newHighestIndex;
        }
    }
    
    latestMatchedColor = newColor;
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
//    document.getElementById("next_piece").setAttribute("bgcolor", "2");
//    score += 1000;
    document.getElementById("score").innerHTML = score;
    playSound("hit");
}

function gridItemAt(x, y) {
    return document.getElementById("grid_" + parseInt(x) + "_" + parseInt(y));
}

function loadGrid(numbers) {
    var arr = numbers.split(",");
    
    for (var i = 0; i < 16; i++) {
        var a = Math.floor(i / 4) + 1;
        var b = i % 4 + 1;
        
        if (arr[i] == "0") {
            document.getElementById("grid_" + a + "_" + b).removeAttribute("bgcolor");
        } else {
            document.getElementById("grid_" + a + "_" + b).setAttribute("bgcolor", arr[i]);
        }
    }
}

function exportGrid() {
    var arr = [];
    var gridItems = document.querySelectorAll(".grid_item");
    
    for (var i = 0; i < gridItems.length; i++) {
        var bgcolor = gridItems[i].getAttribute("bgcolor");
        
        if (bgcolor == null) {
            arr.push("0");
        } else {
            arr.push(bgcolor);
        }
    }
    
    return arr.join(",");
}

function getHighestColorIndex(numbers) {
    var arr = numbers.split(",");
    var maxIndex = 0;
    
    for (var i = 0; i < arr.length; i++) {
        var n = parseInt(arr[i]);
        var index = 0;
        
        if (n == 4) {
            index = 1;
        } else if (n == 8) {
            index = 2;
        } else if (n == 16) {
            index = 3;
        } else if (n == 32) {
            index = 4;
        } else if (n == 64) {
            index = 5;
        } else if (n == 128) {
            index = 6;
        } else if (n == 256) {
            index = 7;
        } else if (n == 512) {
            index = 8;
        } else if (n == 1024) {
            index = 9;
        }
        
        if (index > maxIndex) {
            maxIndex = index;
        }
    }
    
    return maxIndex;
}
