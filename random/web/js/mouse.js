
var isLegitTap, lastX, lastY, canShowPressButton, halfPressedButton, removeButtonHandle;

function initTouch() {
    lastX = 0;
    lastY = 0;
    isLegitTap = true;
    canShowPressButton = true;
    halfPressedButton = null;
    document.addEventListener("mousedown", mouseStart, false);
    document.addEventListener("mousemove", mouseMove, false);
    document.addEventListener("mouseup", mouseEnd, false);
}

function mouseStart(e) {
    lastX = e.clientX;
    lastY = e.clientY;
}

function mouseMove(e) {
    if ((Math.abs(lastX - e.clientX) > 10 || Math.abs(lastY - e.clientY) > 10)) {
        removeButtonDown();
    }
    
    canShowPressButton = false;
}

function mouseEnd(e) {
    e.preventDefault();
    canShowPressButton = false;
}
