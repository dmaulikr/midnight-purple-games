//
//  impress.js
//  February 3, 2017
//  Caleb Hess
//

var impress = {
    x: 0,
    y: 0,
    legit: true,
    showable: true,
    button: null,
    timer: null,
    isTouchScreen: false
};

impress.init = function() {
    if ('ontouchstart' in document.documentElement) {
        this.isTouchScreen = true;
        document.addEventListener('touchstart', function() { impress.start(event); }, false);
        document.addEventListener('touchmove', function() { impress.move(event); }, false);
        document.addEventListener('touchend', function() { impress.end(event); }, false);
    } else {
        if (document.addEventListener) {
            document.addEventListener('mousedown', function() { impress.start(event); }, false);
            document.addEventListener('mousemove', function() { impress.move(event); }, false);
            document.addEventListener('mouseup', function() { impress.end(event); }, false);
        } else if (document.attachEvent) {
            element.attachEvent('onmousedown', function() { impress.start(event); });
            element.attachEvent('onmousemove', function() { impress.move(event); });
            element.attachEvent('onmouseup', function() { impress.end(event); });
        }
    }
};

impress.start = function(e) {
    if (this.isTouchScreen) {
        if (e.touches.length > 1) {
            this.legit = false;
            this.hide();
        } else {
            this.x = e.touches[0].clientX;
            this.y = e.touches[0].clientY;
            this.press(e.target);
        }
    } else {
        this.x = e.clientX;
        this.y = e.clientY;
        this.legit = true;
        this.press(e.target);
    }
};

impress.move = function(e) {
    var cX, cY;
    
    if (this.isTouchScreen) {
        cX = e.touches[0].clientX;
        cY = e.touches[0].clientY;
    } else {
        cX = e.clientX;
        cY = e.clientY;
    }
    
    if (this.legit && (Math.abs(this.x - cX) > 7 || Math.abs(this.y - cY) > 7)) {
        this.legit = false;
        this.showable = false;
        this.hide();
    }
};

impress.end = function(e) {
    this.showable = false;
    this.unpress(e.target);
    
    if (this.isTouchScreen) {
        this.legit = (e.touches.length == 0);
    }
};

impress.press = function(target) {
    var element = this.fromTarget(target);
    
    if (element) {
        clearTimeout(this.timer);
        this.showable = true;
        this.button = element;
        setTimeout(function() { impress.show(); }, 50);
    }
};

impress.unpress = function(target) {
    this.timer = setTimeout(function() { impress.hide(); }, 100);
    
    if (this.legit) {
        var element = this.fromTarget(target);
        
        if (element) {
            var code = element.getAttribute('impress');
            eval(code.split('_this').join('impress.button'));
        }
    }
};

impress.fromTarget = function(target) {
    var element = target;
    
    while (element) {
        if (element.hasAttribute && element.hasAttribute('impress')) {
            return element;
        }
        
        element = element.parentNode;
    }
    
    return null;
};

impress.show = function() {
    if (this.showable) {
        this.button.classList.add('impress');
    }
};

impress.hide = function() {
    removeClass('impress');
};
