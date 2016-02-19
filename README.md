## Cordova Trustly Plugin ##
Open Trustly flow in another window modally. Implements the flow discussed here: <https://trustly.com/en/developer/api#/iosandroid>.

**Supported platforms:**
- iOS >= 8 (uses WKWebView)
- Android

Tested on cordova-ios >= 4.0.1 and cordova-android >= 5.1.0. It might work on older versions though.

## Installation ##
To install this plugin, follow the [Command-line Interface Guide](http://cordova.apache.org/docs/en/latest/guide/cli/index.html#add-plugin-features).

```sh
$ cordova plugin add https://github.com/5monkeys/cordova-trustly-plugin 
```

## Usage ##

```js
function onDeviceReady() {
    	
    if (window.plugins && window.plugins.Trustly) {
        function successCallback(response) {
            console.log(response.finalUrl);
        }

        function errorCallback(response) {
            // Possible codes at the moment: 'cancelled', 'error'    
            console.log(response.code, response.message);
        }

        // This is the URL you received from Trustly after
        // initiating one of their flows (deposit, selectaccount etc.)
        var trustlyFlowURL = 'https://test.trustly.com/url';
        
        // The endUrls are the possible redirects that you have sent to Trustly.
        // The plugin will match each url with the next urls suffix
        // A SuccessURL of 'https://your.site/trustly/success/' would be matched with ['/trustly/success/'] for example
        // See: https://trustly.com/en/developer/api#/deposit (SuccessURL and FailURL)
        var endUrls = ['/flow/done', '/flow/cancel'];
        
        // If it matches one of the endUrls we will close the modal and execute the successCallback
        window.plugins.Trustly.startTrustlyFlow(
            trustlyFlowURL, endUrls, 
            successCallback, errorCallback
        );
    }
}
```
