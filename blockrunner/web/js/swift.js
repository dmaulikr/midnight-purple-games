
function swift(native, data) {
    window.webkit.messageHandlers.callSwift.postMessage('{"native":"' + native + '","data":' + data + '}');
}

function print(message) {
    swift('Log', '{"log":"' + message + '"}');
}
