
var isLegitTap, lastX, lastY, canShowPressButton, halfPressedButton, removeButtonHandle;

function initTouch() {
    lastX = 0;
    lastY = 0;
    isLegitTap = true;
    canShowPressButton = true;
    halfPressedButton = null;
    document.addEventListener("touchstart", touchStart, false);
    document.addEventListener("touchmove", touchMove, false);
    document.addEventListener("touchend", touchEnd, false);
}

function touchStart(e) {
    if (e.touches.length > 1) {
        isLegitTap = false;
        removeButtonDown();
    } else {
        lastX = e.touches[0].clientX
        lastY = e.touches[0].clientY
    }
}

function touchMove(e) {
    if (isLegitTap && (Math.abs(lastX - e.touches[0].clientX) > 10 || Math.abs(lastY - e.touches[0].clientY) > 10)) {
        isLegitTap = false;
        removeButtonDown();
    }
    
    canShowPressButton = false;
}

function touchEnd(e) {
    isLegitTap = (e.touches.length == 0);
    canShowPressButton = false;
}
