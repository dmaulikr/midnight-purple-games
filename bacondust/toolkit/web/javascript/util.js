
function init() {
    window.onerror = function (msg, url, line, col) {
        print("JavaScript error (window.onerror)");
        return false;
    }
    
    impress.init();
}

function focusChild(element) {
    element.childNodes[1].focus();
}

// -----------------------------------------------------------------------------------------------------------------------------
//                                                            Math
// -----------------------------------------------------------------------------------------------------------------------------

function rand(max) {
    return Math.floor(Math.random() * max);
}

// -----------------------------------------------------------------------------------------------------------------------------
//                                                            Class
// -----------------------------------------------------------------------------------------------------------------------------

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
