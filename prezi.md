# From `rails new` to App Store
## Building iOS and Android Apps with Rails 5 and Turbolinks

---


# Who We Are
## Geoff Buesing @gbuesing
## Trevor Turk @trevorturk

---

# How We Did It
## Rails 5
## Turbolinks
## ActionCable

---

# Overview of Turbolinks

---

# Turbolinks makes your web application faster.

"Get the performance benefits of a **single-page application** without the added complexity of a client-side JavaScript framework."

github.com/turbolinks/turbolinks

---

# Turbolinks history lesson (part one):

* **pjax**
* Turbolinks "Classic" (Rails 4.0)
* Turbolinks 5 (Rails 5.0)

---

# pjax

Jquery plugin to make GitHub's inline code browser faster.

github.com/defunkt/jquery-pjax

---

![Turbolinks](http://turbochat.s3.amazonaws.com/Screenshot%202017-03-21%2019.13.40.PNG)

---

```
<!DOCTYPE html>
<html>
<head>
  <script src="pjax.js"></script>
</head>
<body>
  <div id="file-navigation">
    <!-- links to folders, files, etc -->
  </div>
  <script>
    // enable faster browsing within the file-navigation div
    $(document).pjax('a', '#file-navigation')
  </script>
</body>
</html>

```

---

# Turbolinks history lesson (part two):

* pjax
* **Turbolinks "Classic" (Rails 4.0)**
* Turbolinks 5 (Rails 5.0)

---

# Turbolinks "Classic"

While pjax only replaces part of the page, Turbolinks operates on the entire page. When you follow a link, Turbolinks automatically fetches the page, swaps in its ```<body>```, and merges its ```<head>```, **all without incurring the cost of a full page load**."

github.com/turbolinks/turbolinks-classic

---

```
<!DOCTYPE html>
<html>
<head>
  <title>My application</title>
  <script src="turbolinks-classic.js"></script>
</head>
<body>
  <a href="/about">About us</a>
</body>
</html>
```

---

# Turbolinks history lesson (part three):

* pjax
* Turbolinks "Classic" (Rails 4.0)
* **Turbolinks 5 (Rails 5.0)**

---

# Turbolinks 5

* Ground-up rewrite with the same core idea as Turbolinks Classic
* Drops jQuery dependency
* Supports mobile apps

github.com/turbolinks/turbolinks

---

# Turbolinks adapters for iOS and Android

The native adapters automatically manage a single web view instance across multiple view controllers, giving you native navigation UI with all the client-side performance benefits of Turbolinks.

You can use native code and navigation UI progressively where needed. You're not locked into a custom app development framework.

github.com/turbolinks/turbolinks-ios
github.com/turbolinks/turbolinks-android

---

# Turbolinks adapter benefits:

* Leverage your existing web views on native platforms
* Use HTML/CSS for layouts, instead of complex storyboards etc
* Use the Safari developer mode and Chrome web tools you love
* Release native app bug fixes with a simple web deploy

---

# Communicating with your iOS and Android apps

---

# Web app sends message to iOS

```js
// js
window.webkit.messageHandlers.log.postMessage("hi");
```

...iOS app exposes "log" handler:
```java
// swift
webViewConfiguration.userContentController
  .addScriptMessageHandler(self, name: "log")

func userContentController(userContentController:
	WKUserContentController, didReceiveScriptMessage
    message: WKScriptMessage) {
    print("Logging: \(message.body)")
}
```

---


# Web app sends message to Android

Use JavaScript to send a message from your web app:

```js
// js
window.AndroidNative.log("hi")
```

...and the Android app recieves the message with data:
```java
// java
@JavascriptInterface
public void log(String value) {
	Log.d("Logging:", value)
}

webView.addJavascriptInterface(this, "AndroidNative");
```

---

# iOS calls web app function

```
// swift
let js = "(function() { return new Date() })();";

webView.evaluateJavaScript(js) { (result, error) in
  print("Date is \(result)")
}
```

---

# Android calls web app function

```
String js = "(function() { return new Date() })();";

ValueCallback callback = new ValueCallback<String>() {
    @Override
    public void onReceiveValue(String s) {
        Log.d("Date is:", s);
    }
};

webView.evaluateJavascript(js, callback);
```
---

# iOS catches a link

```
<a href="helloweather://fanclub">Join the Fan Club</a>

```

```
func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
    if navigationType == UIWebViewNavigationType.LinkClicked {
        if request.URL!.absoluteString! == "helloweather://fanclub" {
            performSegueWithIdentifier("weatherFanclubSegue", sender: self)
            return false
      }
    }
    return true
}
```

---

# Android catches a link
```
<a href="helloweather://fanclub">Join the Fan Club</a>

```
```
public boolean shouldOverrideUrlLoading(WebView view, String url)
     if (url == "helloweather://fanclub") {
        route(fanclub)
    }
}
```
---

# Example app

github.com/gbuesing/turbochat

---

# Questions?

## Geoff Buesing @gbuesing
## Trevor Turk @trevorturk

---

# Action Cable

* New in Rails 5.0, use websockets instead of polling
* Websocket server can be totally separate or a seperate thread
* Use Rails models etc on the client side

---

# Additional reading

* http://char.gd/web/the-web-is-swallowing-the-desktop/
* https://medium.com/hello-weather/strategies-for-building-a-dual-platform-mobile-app-7ee2db4f1318

---
