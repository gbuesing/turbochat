import UIKit
import WebKit

protocol AuthenticationControllerDelegate: class {
    func authenticationControllerDidAuthenticate(authenticationController: AuthenticationController)
}

class AuthenticationController: UIViewController {
    var URL: NSURL?
    var webViewConfiguration: WKWebViewConfiguration?
    weak var delegate: AuthenticationControllerDelegate?
    
    lazy var webView: WKWebView = {
        let configuration = self.webViewConfiguration ?? WKWebViewConfiguration()
        let webView = WKWebView(frame: CGRectZero, configuration: configuration)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(webView)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: [], metrics: nil, views: [ "view": webView ]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: [], metrics: nil, views: [ "view": webView ]))
        
        if let URL = self.URL {
            webView.loadRequest(NSURLRequest(URL: URL))
        }
    }
}

extension AuthenticationController: WKNavigationDelegate {
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {
        print("auth decidePolicyForNavigationAction request.URL=\(navigationAction.request.URL) URL=\(self.URL)")
        if let URL = navigationAction.request.URL where URL.path == "/" {
            decisionHandler(.Cancel)
            delegate?.authenticationControllerDidAuthenticate(self)
            return
        }
        
        decisionHandler(.Allow)
    }
}
