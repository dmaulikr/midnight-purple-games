
var score = 0;
var highScore = 0;
var sideLimit = 20;
var blockWidth = 36;
var speed;
var fallingBlocks = [];
var gameTimer;
var isGaming, isGameReady;

var blockIds = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

function init() {
    initTouch();
}

function sendText(element) {
    swift('SendText', '{"high_score":"' + highScore + '"}');
}

function startGame(element) {
    score = 0;
    speed = Math.floor(screen.height / 40);
    blockWidth = Math.floor(screen.height / 10);
    fallingBlocks = [];
    blockIds = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
    isGaming = false;
    isGameReady = true;
    
    for (var i = 0; i < 25; i++) {
        document.getElementById("falling_block_" + i).style.top = -blockWidth * 2;
    }
    
    document.getElementById("score").innerHTML = score;
    document.getElementById("main_menu").style.display = "none";
    document.getElementById("main_over").style.display = "none";
    document.getElementById("main_game").style.display = "block";
    document.getElementById("block_runner").style.left = "calc(50% - 18px)";
    blockWidth = document.getElementById("block_runner").offsetWidth;
}

function startMoving() {
    if (isGameReady && !isGaming) {
        isGaming = true;
        gameTimer = setInterval(update, 25);
    }
}

function steerBlock(event) {
    var x = event.touches[0].clientX;
    
    if (x < sideLimit) {
        x = sideLimit;
    } else if (x > document.getElementById("steering_zone").offsetWidth - sideLimit) {
        x = document.getElementById("steering_zone").offsetWidth - sideLimit;
    }
    
    document.getElementById("block_runner").style.left = x - blockWidth / 2;
}

function update() {
    var highestBlock = 999;
    var gameOverBlock = -1;
    
    for (var i = fallingBlocks.length - 1; i >= 0; i--) {
        fallingBlocks[i].y += speed;
        
        // get highest block
        if (fallingBlocks[i].y < highestBlock) {
            highestBlock = fallingBlocks[i].y;
        }
        
        // update all
        if (document.getElementById(fallingBlocks[i].id).offsetTop > screen.height) {
            blockIds[parseInt(fallingBlocks[i].id.split("_")[2])] = 0;
            fallingBlocks.splice(i, 1);
            document.getElementById("score").innerHTML = ++score;
            
            if (score > highScore) {
                highScore = score;
            }
        } else {
            document.getElementById(fallingBlocks[i].id).style.top = fallingBlocks[i].y;
        }
        
        // check for collision
        if (Math.abs(document.getElementById("block_runner").offsetTop - fallingBlocks[i].y) < blockWidth) {
            if (Math.abs(document.getElementById("block_runner").offsetLeft - fallingBlocks[i].x) < blockWidth) {
                gameOverBlock = i;
            }
        }
    }
    
    // make new blocks
    if (highestBlock > 75) {
        addNewBlock();
    }

    // game over
    if (gameOverBlock > -1) {
        gameOver(gameOverBlock);
    }
}

function addNewBlock() {
    var xPos = Math.floor(Math.random() * screen.width - blockWidth);
    var yPos = -blockWidth;
    
    // get id
    var id = -1;
    while (blockIds[++id] != 0 && id < 24);
    blockIds[id] = 1;
    
    // create block
    var elementId = "falling_block_" + id;
    fallingBlocks.push({ x: xPos, y: yPos, id: elementId });
    document.getElementById(elementId).style.left = xPos;
    document.getElementById(elementId).style.top = yPos;
}

function gameOver(leftOverBlock) {
    clearInterval(gameTimer);
    isGaming = false;
    isGameReady = false;
    
    // remove all other blocks
    for (var i = fallingBlocks.length - 1; i >= 0; i--) {
        if (i != leftOverBlock) {
            document.getElementById(fallingBlocks[i].id).style.top = -blockWidth;
            fallingBlocks.splice(i, 1);
        }
    }
    
    setTimeout(showGameOver, 500);
    swift('SaveHighScore', '{"high_score":' + highScore + '}');
    swift('LogScore', '{"score":' + score + '}');
}

function showGameOver() {
    document.getElementById("main_game").style.display = "none";
    document.getElementById("main_over").style.display = "block";
    document.getElementById("final_high_score").innerHTML = highScore;
    document.getElementById("final_score").innerHTML = score;
}
