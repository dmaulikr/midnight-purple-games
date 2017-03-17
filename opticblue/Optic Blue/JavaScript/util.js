
var currentRefreshMenu = "";
var currentRefreshDistance = 0;

// ---------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                         Touch
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

var isLegitTap, lastX = 0, lastY = 0, canShowPressButton, halfPressedButton;

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
        lastX = e.touches[0].clientX
        lastY = e.touches[0].clientY
    }
}

function touchMove(e) {
    if (isLegitTap && (Math.abs(lastX - e.touches[0].clientX) > 10 || Math.abs(lastY - e.touches[0].clientY) > 10)) {
        isLegitTap = false;
        removeButtonDown();
    }
    
    // pull down to refresh
    if (currentRefreshMenu != "" && document.getElementById(currentRefreshMenu).scrollTop < -75) {
        refreshCurrentMenu(currentRefreshMenu);
        currentRefreshMenu = "";
    }
    
    canShowPressButton = false;
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
//                                                                     Almost JQuery
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

function addClass(queryClass, newClass) {
    var arr = document.querySelectorAll("." + queryClass);
    var len = arr.length;
    
    for (var i = 0; i < len; i++) {
        arr[i].classList.add(newClass);
    }
}

function removeClass(name) {
    var elem = document.querySelectorAll("." + name);
    var len = elem.length;
    
    for (var i = 0; i < len; i++) {
        elem[i].classList.remove(name);
    }
}

function childElement(element, childQuery) {
    element.id = "query_selector_id";
    var child = element.querySelector("#" + element.id + " > " + childQuery);
    element.removeAttribute("id");
    return child;
}

function childElements(element, childQuery) {
    element.id = "query_selector_id";
    var children = element.querySelectorAll("#" + element.id + " > " + childQuery);
    element.removeAttribute("id");
    return children;
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                        Console
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

function swift(native, data) {
    window.webkit.messageHandlers.callSwift.postMessage("{\"native\":\"" + native + "\",\"data\":\"" + data + "\"}");
}

function log(message) {
    window.webkit.messageHandlers.callSwift.postMessage("{\"native\":\"Log\",\"data\":\"" + message + "\"}");
}