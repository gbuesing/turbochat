import UIKit
import WebKit
import Turbolinks

class ApplicationController: UINavigationController {
    private let URL = NSURL(string: "http://localhost:3000")!
    private let webViewProcessPool = WKProcessPool()
    
    private var application: UIApplication {
        return UIApplication.sharedApplication()
    }
    
    private lazy var webViewConfiguration: WKWebViewConfiguration = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController.addScriptMessageHandler(self, name: "turbolinksDemo")
        configuration.processPool = self.webViewProcessPool
        configuration.applicationNameForUserAgent = "Turbochat"
        return configuration
    }()
    
    private lazy var session: Session = {
        let session = Session(webViewConfiguration: self.webViewConfiguration)
        session.delegate = self
        return session
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presentVisitableForSession(session, URL: URL)
    }
    
    private func presentVisitableForSession(session: Session, URL: NSURL, action: Action = .Advance) {
        let visitable = DemoViewController(URL: URL)
        
        if action == .Advance {
            pushViewController(visitable, animated: true)
        } else if action == .Replace {
            popViewControllerAnimated(false)
            pushViewController(visitable, animated: false)
        }
        
        session.visit(visitable)
    }
    
    private func presentNumbersViewController() {
//        let viewController = NumbersViewController()
//        pushViewController(viewController, animated: true)
    }
    
    private func presentAuthenticationController() {
        let authenticationController = AuthenticationController()
        authenticationController.delegate = self
        authenticationController.webViewConfiguration = webViewConfiguration
        authenticationController.URL = URL.URLByAppendingPathComponent("users/new")
        authenticationController.title = "Sign in"
        
        let authNavigationController = UINavigationController(rootViewController: authenticationController)
        presentViewController(authNavigationController, animated: true, completion: nil)
    }
}

extension ApplicationController: SessionDelegate {
    func session(session: Session, didProposeVisitToURL URL: NSURL, withAction action: Action) {
        if URL.path == "/numbers" {
            presentNumbersViewController()
        } else {
            presentVisitableForSession(session, URL: URL, action: action)
        }
    }
    
    func session(session: Session, didFailRequestForVisitable visitable: Visitable, withError error: NSError) {
        NSLog("ERROR: %@", error)
        guard let demoViewController = visitable as? DemoViewController, errorCode = ErrorCode(rawValue: error.code) else { return }
        
        switch errorCode {
        case .HTTPFailure:
            let statusCode = error.userInfo["statusCode"] as! Int
            switch statusCode {
            case 401:
                presentAuthenticationController()
            case 404:
                demoViewController.presentError(.HTTPNotFoundError)
            default:
                demoViewController.presentError(Error(HTTPStatusCode: statusCode))
            }
        case .NetworkFailure:
            demoViewController.presentError(.NetworkError)
        }
    }
    
    func sessionDidStartRequest(session: Session) {
        application.networkActivityIndicatorVisible = true
    }
    
    func sessionDidFinishRequest(session: Session) {
        application.networkActivityIndicatorVisible = false
    }
}

extension ApplicationController: AuthenticationControllerDelegate {
    func authenticationControllerDidAuthenticate(authenticationController: AuthenticationController) {
        print("authenticationControllerDidAuthenticate")
        session.reload()
        dismissViewControllerAnimated(true, completion: nil)
    }
}

extension ApplicationController: WKScriptMessageHandler {
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        if let message = message.body as? String {
            let alertController = UIAlertController(title: "Turbolinks", message: message, preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
        }
    }
}
