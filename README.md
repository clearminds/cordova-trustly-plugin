## Cordova Trustly Plugin ##
Open Trustly flow in another window modally. Implements the flow discussed here: <https://trustly.com/en/developer/api#/iosandroid>.

**Platforms:**
- iOS >= 8 (uses WKWebView)
- Android (In progress)

Tested on cordova-ios >= 4.0.1. It might work on older versions though.

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

        function errorCallback(message) {
            console.log(message);
        }

        var endUrls = ['/flow/done', 'flow/cancel'];
        // The endUrls are the possible redirects that you have sent to Trustly.
        // The plugin will match each url with the next urls suffix
        // A SuccessURL of example.com/trustly/success/ would be matched with ['/trustly/success/'] for example
        // See: https://trustly.com/en/developer/api#/deposit (SuccessURL and FailURL)
        
        // If it matches one of the endUrls we will close the modal and execute the successCallback
        window.plugins.Trustly.startTrustlyFlow(
            "https://test.trustly.com/url", endUrls, 
            successCallback, errorCallback
        );
    }
}
```
