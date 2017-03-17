
function toggleClass(element, name) {
    if (element.className.indexOf(name) == -1) {
        element.classList.add(name);
    } else {
        element.classList.remove(name);
    }
}

function removeClass(name) {
    var elem = document.querySelectorAll("." + name);
    var len = elem.length;
    
    for (var i = 0; i < len; i++) {
        elem[i].classList.remove(name);
    }
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                       Buttons
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

function tap(element, funcNameArr) {
    removeButtonHandle = setTimeout(removeButtonDown, 100);
    
    if (isLegitTap) {
        for (var i = 0; i < funcNameArr.length; i++) {
            funcNameArr[i](element);
        }
    }
}

function pressButton(element) {
    clearTimeout(removeButtonHandle);
    canShowPressButton = true;
    halfPressedButton = element;
    setTimeout(showPressButton, 50);
}

function showPressButton() {
    if (canShowPressButton) {
        removeButtonDown();
        halfPressedButton.classList.add("button_down");
    }
}

function removeButtonDown() {
    removeClass("button_down");
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                        Swift
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

function swift(native, data) {
    window.webkit.messageHandlers.callSwift.postMessage('{"native":"' + native + '","data":' + data + '}');
}

function playSound(name) {
    swift('Sound', '{"name":"' + name + '"}');
}

function print(message) {
    swift('Print', '{"text":"' + message + '"}');
}
