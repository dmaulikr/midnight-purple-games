
var isWebSite = false;

function init() {
    initTouch();
    isWebSite = false;
}

function openResultsMenu() {
    document.getElementById("results_menu").style.display = "block";
}

function doAction(element) {
    swift("DoAction", element.getAttribute("action"));
    
    if (element.getAttribute("action") == "ScanAnother") {
        document.getElementById("results_menu").style.display = "none";
        document.getElementById("result").classList.remove("clickable");
        document.getElementById("result_title").innerHTML = "barcode value";
        isWebSite = false;
    }
}

function openWebsite(element) {
    if (isWebSite) {
        swift("OpenWebsite", "");
    }
}

function makeWebsiteAvailable() {
    document.getElementById("result").classList.add("clickable");
    document.getElementById("result_title").innerHTML = "website url";
    isWebSite = true;
}
