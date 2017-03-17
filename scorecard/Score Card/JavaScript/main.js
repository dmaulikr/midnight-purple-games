
var holes = 0;
var currentGridId = "";

function sendText(element) {
    swift("SendText", "");
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                       Navigation
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

function backToMenu(element) {
    document.getElementById("name_entry").style.display = "none";
    document.getElementById("main_menu").style.display = "block";
}

function clearAndBackToMenu(element) {
    document.getElementById("areyousure_menu").style.display = "none";
    document.getElementById("main_menu").style.display = "block";
    clearGrid(null);
}

function backToScoreCard(element) {
    document.getElementById("areyousure_menu").style.display = "none";
    document.getElementById("nine_holes").style.display = "block";
}

function showGamesPage(element) {
    document.getElementById("main_menu").style.display = "none";
    document.getElementById("archive").style.display = "block";
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                       Name Input
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

function newScoreCard(element) {
    if (element.innerHTML.charAt(0) == "9") {
        holes = 9;
    } else {
        holes = 18;
    }
    
    document.getElementById("main_menu").style.display = "none";
    document.getElementById("name_entry").style.display = "block";
    document.querySelector(".name_entry_title").style.backgroundColor = "transparent";
    document.querySelector(".name_entry_title").innerHTML = "enter up to five player names";
    swift("Holes", holes);
}

function focusNameInput1(element) { document.getElementById("name_input_box_1").focus(); }
function focusNameInput2(element) { document.getElementById("name_input_box_2").focus(); }
function focusNameInput3(element) { document.getElementById("name_input_box_3").focus(); }
function focusNameInput4(element) { document.getElementById("name_input_box_4").focus(); }
function focusNameInput5(element) { document.getElementById("name_input_box_5").focus(); }

function nameInputKeyUp(element, event) {
    if (event.keyCode == 13) {
        var nextBoxNumber = parseInt(element.id.split("_")[3]) + 1;
        
        if (nextBoxNumber < 6) {
            document.getElementById("name_input_box_" + nextBoxNumber).focus();
        } else {
            storeNames(null);
        }
    }
}

function storeNames(element) {
    var names = "";
    
    // grab names from input boxes
    for (var i = 1; i < 6; i++) {
        if(document.getElementById("name_input_box_" + i).value.length > 0) {
            names += document.getElementById("name_input_box_" + i).value + "_";
        }
    }
    
    // add names to score card
    var namesArr = names.split("_");
    
    if (namesArr.length > 1) {
        document.getElementById("name_item_1").innerHTML = "";
        document.getElementById("name_item_2").innerHTML = "";
        document.getElementById("name_item_3").innerHTML = "";
        document.getElementById("name_item_4").innerHTML = "";
        document.getElementById("name_item_5").innerHTML = "";
        
        for (var i = 0; i < namesArr.length - 1; i++) {
            document.getElementById("name_item_" + (i + 1)).innerHTML = namesArr[i];
        }
        
        // close keyboard
        document.getElementById("name_input_box_1").blur();
        document.getElementById("name_input_box_2").blur();
        document.getElementById("name_input_box_3").blur();
        document.getElementById("name_input_box_4").blur();
        document.getElementById("name_input_box_5").blur();
        
        // show score card
        document.getElementById("name_entry").style.display = "none";
        document.getElementById("nine_holes").style.display = "block";
        
        if (holes == 9) {
            document.getElementById("eighteen_holes").style.display = "none";
        } else {
            document.getElementById("eighteen_holes").style.display = "block";
        }
        
    // change title to indicate error
    } else {
        document.querySelector(".name_entry_title").style.backgroundColor = "#e55";
        document.querySelector(".name_entry_title").innerHTML = "enter at least one player name";
    }
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                       Score Card
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

function addStroke(element) {
    var playerName = document.getElementById("name_item_" + element.id.split("_")[2]).innerHTML;
    var holeNumber = element.id.split("_")[1];
    
    if (playerName.length > 0) {
        document.getElementById("nine_holes").style.display = "none";
        document.getElementById("stroke_entry").style.display = "block";
        document.getElementById("stroke_entry_title").innerHTML = playerName + " @ hole " + holeNumber;
        currentGridId = element.id;
    }
}

function useStroke(element) {
    document.getElementById("stroke_entry").style.display = "none";
    document.getElementById("nine_holes").style.display = "block";
    document.getElementById(currentGridId).innerHTML = element.innerHTML;
    updateTotals();
}

function cancelAddStroke(element) {
    document.getElementById("stroke_entry").style.display = "none";
    document.getElementById("nine_holes").style.display = "block";
}

function updateTotals() {
    for (var i = 1; i < 6; i++) {
        if (document.getElementById("name_item_" + i).innerHTML.length > 0) {
            var sum = 0;
            
            for (var h = 1; h < holes + 1; h++) {
                if (document.getElementById("grid_" + h + "_" + i).innerHTML != "&nbsp;") {
                    sum += parseInt(document.getElementById("grid_" + h + "_" + i).innerHTML);
                }
            }
            
            document.getElementById("total_" + i).innerHTML = sum;
        } else {
            document.getElementById("total_" + i).innerHTML = "&nbsp;";
        }
    }
}

function clearGrid(element) {
    for (var i = 1; i < 6; i++) {
        for (var h = 1; h < holes + 1; h++) {
            document.getElementById("grid_" + h + "_" + i).innerHTML = "&nbsp;";
        }
            
        document.getElementById("total_" + i).innerHTML = "&nbsp;";
    }
}

function openMiniMenu(element) {
    document.getElementById("nine_holes").style.display = "none";
    document.getElementById("areyousure_menu").style.display = "block";
}

// ---------------------------------------------------------------------------------------------------------------------------------------------------------
//                                                                      Touch Events
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

var isLegitTap = true;

document.addEventListener("touchstart", touchStart, false);
document.addEventListener("touchmove", touchMove, false);
document.addEventListener("touchend", touchEnd, false);

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
    e.preventDefault();
    isLegitTap = (e.touches.length == 0);
    canShowPressButton = false;
    removeButtonDown();
}

function tap(element, funcName) {
    if (isLegitTap) {
        funcName(element);
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
//                                                                       Utils
// ---------------------------------------------------------------------------------------------------------------------------------------------------------

function log(message) {
    swift("Log", message);
}

function swift(native, data) {
    window.webkit.messageHandlers.callSwift.postMessage("{\"native\":\"" + native + "\",\"data\":\"" + data + "\"}");
}
