
var colorIndex = 0;

function init() {
    initTouch();
}

function focusNumberSelect(element) {
    element.focus();
}

function randomize(element) {
    var bottom = parseInt(document.getElementById("bottom_number").value);
    var top = parseInt(document.getElementById("top_number").value);
    document.getElementById("big").innerHTML = randomInt(bottom, top);
    document.getElementById("everything_holder").style.backgroundColor = randomColor();
}

function randomColor() {
    var hexValues = ["47c", "4b7", "a7b", "b44", "888"];
    return "#" + hexValues[++colorIndex % hexValues.length];
}

function randomInt(min, max) {
    return Math.floor(Math.random() * (max - min + 1)) + min;
}

function logAnswers(type, n) {
    swift(type, '{"n":"' + n + '"}');
}
