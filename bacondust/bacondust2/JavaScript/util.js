
function init(highScore) {
    initTouch();
    initGame(highScore);
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                         Touch
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

var isLegitTap, lastX = 0, lastY = 0, lastMovingX = 0, lastMovingY = 0, canShowPressButton, halfPressedButton;

document.addEventListener("touchstart", touchStart, false);
document.addEventListener("touchmove", touchMove, false);
document.addEventListener("touchend", touchEnd, false);

function initTouch() {
    isLegitTap = true;
    canShowPressButton = true;
    halfPressedButton = null;
}

function touchStart(e) {
    if (e.touches.length > 1) {
        isLegitTap = false;
        removeButtonDown();
    } else {
        lastX = e.touches[0].clientX;
        lastY = e.touches[0].clientY;
    }
    
    lastMovingX = e.touches[0].clientX;
    lastMovingY = e.touches[0].clientY;
}

function touchMove(e) {
    if (isLegitTap && (Math.abs(lastX - e.touches[0].clientX) > 10 || Math.abs(lastY - e.touches[0].clientY) > 10)) {
        isLegitTap = false;
        removeButtonDown();
    }
    
    canShowPressButton = false;
    lastMovingX = e.touches[0].clientX;
    lastMovingY = e.touches[0].clientY;
}

function touchEnd(e) {
    e.preventDefault();
    isLegitTap = (e.touches.length == 0);
    canShowPressButton = false;
    removeButtonDown();
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                        Buttons
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

function tap(element, funcNameArr) {
    if (isLegitTap) {
        for (var i = 0; i < funcNameArr.length; i++) {
            funcNameArr[i](element);
        }
    }
}

function pressButtonNow(element) {
    element.classList.add("button_down");
}

function pressButton(element) {
    canShowPressButton = true;
    halfPressedButton = element;
    setTimeout(showPressButton, 50);
}

function showPressButton() {
    if (canShowPressButton) {
        halfPressedButton.classList.add("button_down");
    }
}

function removeButtonDown() {
    if (document.querySelector(".button_down") != null) {
        document.querySelector(".button_down").classList.remove("button_down");
    }
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                        Console
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

function swift(native, data) {
    window.webkit.messageHandlers.callSwift.postMessage("{\"native\":\"" + native + "\",\"data\":\"" + data + "\"}");
}

function playSound(name) {
    swift("Sound", name);
}

function log(message) {
    window.webkit.messageHandlers.callSwift.postMessage("{\"native\":\"Log\",\"data\":\"" + message + "\"}");
}
