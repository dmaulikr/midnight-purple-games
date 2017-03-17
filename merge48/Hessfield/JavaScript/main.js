
function navigateForward(element) {
    var navigation = element.getAttribute("navigation").split("-");
    var menu = navigation[0];
    var destination = navigation[1];
    document.getElementById("main_" + menu).style.display = "none";
    document.getElementById("main_" + destination).style.display = "block";
    playSound("tiny_button");
}

function removeStartAnimation(element) {
    document.getElementById("splash").classList.remove("splash_title_animation");
    document.getElementById("company").classList.remove("company_animation");
}

function focusCreate(element) {
    document.getElementById("create_err").innerHTML = "this username will be shown on the high score list";
    document.getElementById("create_err").classList.remove("danger");
    document.getElementById("create_input").focus();
}

function navigateToStats(element) {
    playSound("tiny_button");
    swift("GetStats", "");
}

function showStatScreen() {
    document.getElementById("main_menu").style.display = "none";
    document.getElementById("main_stats").style.display = "block";
}

function showNewUserScreen() {
    document.getElementById("main_menu").style.display = "none";
    document.getElementById("main_createusername").style.display = "block";
}

function showNoICloudScreen() {
    document.getElementById("main_menu").style.display = "none";
    document.getElementById("main_noicloud").style.display = "block";
}

function updateCloudDataUI() {
    document.getElementById("coins").innerHTML = coins;
    document.getElementById("high_score").innerHTML = highScore;
    document.getElementById("dash_high_score").innerHTML = dashHighScore;
}

// ----- user -----

function goodUserName(username) {
    document.getElementById("main_createusername").style.display = "none";
    document.getElementById("main_stats").style.display = "block";
    document.getElementById("company").innerHTML = "Hello " + username;
}

function badUserName() {
    document.getElementById("create_err").innerHTML = "username already taken";
    document.getElementById("create_err").classList.add("danger");
}

function saveUserName(element) {
    validateUserName();
    document.getElementById("create_input").blur();
}

function validateUserName() {
    var goodName = true;
    var error = "username not available";
    var att = document.getElementById("create_input").value.trim();
    
    // between 5 and 20 chars
    if (att.length < 5 || att.length > 20) {
        goodName = false;
        error = "must be between 5 and 20 characters";
    }
    
    // no html tag chars
    if (att.indexOf("<") != -1 || att.indexOf(">") != -1) {
        goodName = false;
        error = "cannot contain < or >";
    }
    
    if (goodName) {
        swift("SaveUserName", att);
        document.getElementById("create_err").innerHTML = "loading";
        document.getElementById("create_err").classList.remove("danger");
    } else {
        document.getElementById("create_err").innerHTML = error;
        document.getElementById("create_err").classList.add("danger");
    }
}

function showMeStats(element) {
    removeClass("selected_tab");
    element.classList.add("selected_tab");
    document.getElementById("all_stats").style.display = "none";
    document.getElementById("me_stats").style.display = "block";
}

function showAllStats(element) {
    removeClass("selected_tab");
    element.classList.add("selected_tab");
    document.getElementById("me_stats").style.display = "none";
    document.getElementById("all_stats").style.display = "block";
    swift("RefreshHighScoreList", "");
}

// ----- settings -----

function setLight(element) {
    document.getElementById("set_dark").classList.remove("settings_selected");
    element.classList.add("settings_selected");
    swift("SetTheme", "light");
    playSound("tiny_button");
}

function setDark(element) {
    document.getElementById("set_light").classList.remove("settings_selected");
    element.classList.add("settings_selected");
    swift("SetTheme", "dark");
    playSound("tiny_button");
}

function setMusicOn(element) {
    document.getElementById("set_musicoff").classList.remove("settings_selected");
    element.classList.add("settings_selected");
    swift("SetMusicOn", "");
    playSound("tiny_button");
}

function setMusicOff(element) {
    document.getElementById("set_musicon").classList.remove("settings_selected");
    element.classList.add("settings_selected");
    swift("SetMusicOff", "");
    playSound("tiny_button");
}
