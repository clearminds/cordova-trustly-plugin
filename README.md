## Cordova Trustly Plugin ##
Open Trustly flow in another window modally. 

**Platforms:**
- iOS >= 8 (uses WKWebView)
- Android (In progress)

Tested on cordova-ios >= 4.0.1. It might work on older version though.

## How to use? ##
To install this plugin, follow the [Command-line Interface Guide](http://cordova.apache.org/docs/en/latest/guide/cli/index.html#add-plugin-features).

```sh
$ cordova plugin add https://github.com/5monkeys/cordova-trustly-plugin 
```

## How to use it in javascript ##

```js
function onDeviceReady() {
    	
    if (window.plugins && window.plugins.Trustly) {
        function successCallback(response) {
            console.log(response.finalUrl);
        }

        function errorCallback(response) {
            console.log(response.message);
        }

        var endUrls = ['/flow/done', 'flow/cancel'];
        // The endUrls are the possible redirects that you have sent to Trustly.
        // The plugin will match each url with the next urls suffix
        // If it matches it will send a 
        // Trustly will send the user there when the flow is done, and we 
        // will close the modal.
        window.plugins.Trustly.startTrustlyFlow(
            "https://test.trustly.com/url", endUrls, 
            successCallback, errorCallback
        );
    }
}
```
