//
//  sky.js
//  February 3, 2017
//  Caleb Hess
//

@swift-gen@

sky.native = function (scope, action, params) {
    var data = JSON.stringify({
        scope:  scope,
        action: action,
        params: params
    })
    
    window.webkit.messageHandlers.callSwift.postMessage(data);
};

function print(msg) {
    sky.print({'msg': msg});
}
