
var score = 0;
var highScore = 0;
var gameTimer = null;
var currentColorName = "blue";
var rotationSpeed = [-3, -2, -1, 1, 2, 3];
var colorNames = ["blue", "green", "red", "white"];
var hexColors = ["#1f50be", "#33cc33", "#cc3333", "#ffffff"];
var bottomPigClassName = "";
var loserTop = 0;
var loserLeft = 0;
var prevColorIndex = -1;
var dropSpeed = 0;
var pigSize = 0;

// ---------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                         Init
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

function initGame(high) {
    document.querySelectorAll(".highscore_label")[0].innerHTML = "high score: " + high;
    document.querySelectorAll(".highscore_label")[1].innerHTML = "high score: " + high;
    highScore = high;
    
    // iPhones and iPods
    if (window.matchMedia('all and (max-width: 600px)').matches) {
        dropSpeed = 7;
        pigSize = 80;
        
    // iPads
    } else {
        dropSpeed = 10;
        pigSize = 130;
    }
}

function startGame() {
    document.getElementById("main_menu").style.display = "none";
    document.getElementById("main_game_over").style.display = "none";
    document.getElementById("main_game").style.display = "block";
    clearInterval(gameTimer);
    gameTimer = setInterval(update, 25);
    
    if (document.getElementById("old_pig") != null) {
        document.getElementById("old_pig").parentNode.removeChild(document.getElementById("old_pig"));
    }
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                        Update
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

function update() {
    var topPigTop = 999;
    var isGoodPigs = false;
    var fallingPigs = document.querySelectorAll(".falling_pig");
    
    // move falling pigs
    for (var i = fallingPigs.length - 1; i >= 0; i--) {
        
        // move downward
        fallingPigs[i].style.top = (fallingPigs[i].offsetTop + dropSpeed) + "px";
        
        // remove if needed
        if (fallingPigs[i].offsetTop > document.getElementById("main_game").offsetHeight) {
            fallingPigs[i].parentNode.removeChild(fallingPigs[i]);
        }
        
        // find topmost box
        if (fallingPigs[i].offsetTop < topPigTop) {
            topPigTop = fallingPigs[i].offsetTop;
        }
        
        if (fallingPigs[i].className.indexOf(currentColorName) != -1) {
            isGoodPigs = true;
            
            // lose game if needed
            if (fallingPigs[i].offsetTop > document.getElementById("main_game").offsetHeight - (pigSize - dropSpeed)) {
                gameOver(fallingPigs[i], fallingPigs[i].offsetTop, fallingPigs[i].offsetLeft);
            }
        }
        
        var rotationPos = parseInt(fallingPigs[i].getAttribute("rotation")) + parseInt(fallingPigs[i].getAttribute("rotationSpeed"));
        fallingPigs[i].style.webkitTransform = "rotate(" + rotationPos + "deg)";
        fallingPigs[i].setAttribute("rotation", rotationPos);
    }
    
    // add more pigs if needed
    if (topPigTop > 0) {
        addNewPig(isGoodPigs);
    }
}

function addNewPig(isGoodPigs) {
    var pigColorName = colorNames[Math.random() * 4 | 0];
    var leftPercent = Math.random() * 60 + 10;
    var spin = rotationSpeed[Math.random() * 6 | 0];
    var rotation = Math.random() * 360;
    
    if (!isGoodPigs && (Math.random() * 2 | 0) == 0) {
        pigColorName = currentColorName;
    }
    
    var newPig = document.createElement("div");
    newPig.className = "image-" + pigColorName + "_pig falling_pig";
    newPig.setAttribute("rotation", rotation);
    newPig.setAttribute("rotationSpeed", rotationSpeed);
    newPig.style.top = "-" + pigSize + "px";
    newPig.style.left = leftPercent + "%";
    newPig.setAttribute("ontouchstart", "tapOnPig(this)");
    document.getElementById("main_game").appendChild(newPig);
}

function changeColorMaybe() {
    if ((Math.random() * 2 | 0) == 0) {
        var bottomPigIndex = 0;
        var colorIndex = Math.random() * 4 | 0;
        
        if (colorIndex != prevColorIndex) {
            var fallingPigs = document.querySelectorAll(".falling_pig");
            
            currentColorName = colorNames[colorIndex];
            
            var colorLimitTop = document.getElementById("main_game").offsetHeight * 0.5;
            
            // remove pigs of color on bottom
            for (var i = fallingPigs.length - 1; i >= 0; i--) {
                if (fallingPigs[i].className.indexOf(currentColorName) != -1 && fallingPigs[i].offsetTop > colorLimitTop) {
                    fallingPigs[i].parentNode.removeChild(fallingPigs[i]);
                }
            }
            
//            document.querySelector(".left_side_bar").style.backgroundColor = hexColors[colorIndex];
//            document.querySelector(".right_side_bar").style.backgroundColor = hexColors[colorIndex];
            
            document.querySelector(".left_side_bar").classList.remove("gr0");
            document.querySelector(".left_side_bar").classList.remove("gr1");
            document.querySelector(".left_side_bar").classList.remove("gr2");
            document.querySelector(".left_side_bar").classList.remove("gr3");
            document.querySelector(".right_side_bar").classList.remove("gr0");
            document.querySelector(".right_side_bar").classList.remove("gr1");
            document.querySelector(".right_side_bar").classList.remove("gr2");
            document.querySelector(".right_side_bar").classList.remove("gr3");
            document.querySelector(".left_side_bar").classList.add("gr" + colorIndex);
            document.querySelector(".right_side_bar").classList.add("gr" + colorIndex);
            
            prevColorIndex = colorIndex;
        }
    }
}

function tapOnPig(element) {
    if (element.className.indexOf(currentColorName) != -1) {
        swift("Sound", "correct");
        element.parentNode.removeChild(element);
        document.querySelector(".in_game_score_label").innerHTML = ++score;
    } else {
        gameOver(element, element.offsetTop, element.offsetLeft);
    }
    
    changeColorMaybe();
}

function gameOver(pig, top, left) {
    clearInterval(gameTimer);
    swift("Sound", "incorrect");
    document.getElementById("main_game").style.display = "none";
    document.getElementById("main_game_over").style.display = "block";
    document.querySelector(".final_score_label").innerHTML = score;
    
    if (score > highScore) {
        highScore = score;
        swift("SaveHighScore", highScore);
        document.querySelector(".game_over_title").innerHTML = "new high score!";
        document.querySelector(".game_over_title").style.color = "#44bb44";
        document.querySelectorAll(".highscore_label")[1].innerHTML = "high score: " + highScore;
        document.querySelectorAll(".highscore_label")[1].style.display = "none";
    } else {
        document.querySelector(".game_over_title").innerHTML = "game over";
        document.querySelector(".game_over_title").style.color = "#bb4444";
        document.querySelectorAll(".highscore_label")[1].style.display = "block";
    }
    
    // reset game
    document.querySelector(".in_game_score_label").innerHTML = "0";
    removeAllPigs();
    score = 0;
    
    // fade old pig
    var oldPig = document.createElement("div");
    oldPig.id = "old_pig";
    oldPig.style.top = top + "px";
    oldPig.style.left = left + "px";
    oldPig.style.webkitTransform = "rotate(" + pig.getAttribute("rotation") + "deg)";
    oldPig.className = pig.className + " pig_fade_out";
    document.getElementById("main_game_over").appendChild(oldPig);
}

function removeAllPigs() {
    var fallingPigs = document.querySelectorAll(".falling_pig");
    
    for (var i = fallingPigs.length - 1; i >= 0; i--) {
        fallingPigs[i].parentNode.removeChild(fallingPigs[i]);
    }
}
