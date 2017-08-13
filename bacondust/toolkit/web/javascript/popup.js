//
//  popup.js
//  February 6, 2017
//  Caleb Hess
//

var popup = {};

popup.value = function() {
    return document.getElementById("popup-input").value;
};

popup.show = function() {
    popup.showWithId("popup-holder");
};

popup.showWithId = function(id) {
    document.getElementById(id).classList.remove("popup-leave");
    document.getElementById(id).classList.add("popup-enter");
    document.getElementById(id).style.display = "block";
};

popup.close = function() {
    popup.closeWithId("popup-holder");
};

popup.closeWithId = function(id) {
    document.getElementById(id).classList.remove("popup-enter");
    document.getElementById(id).classList.add("popup-leave");
    setTimeout(function() { popup.destroy(id); }, 250);
};

popup.destroy = function(id) {
    document.getElementById(id).innerHTML = "";
    document.getElementById(id).style.display = "none";
};
