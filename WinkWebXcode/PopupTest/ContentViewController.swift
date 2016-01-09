import AppKit
import WebKit

class ContentViewController : NSViewController {
    var webView: WKWebView?
    var closeButton: NSButton?
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func loadView() {
        
        view = NSView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint(NSLayoutConstraint(
            item: view, attribute: .Width, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 400))
        view.addConstraint(NSLayoutConstraint(
            item: view, attribute: .Height, relatedBy: .Equal,
            toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 600))

        webView = WKWebView()
        
        webView!.translatesAutoresizingMaskIntoConstraints = false
        webView!.focusRingType = .None
        view.addSubview(webView!)
        view.setFrameSize(NSSize(width: Int(400),
            height: Int(600)))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-(0)-[webView]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["webView":webView!]))
        
        closeButton = NSButton()
        closeButton!.translatesAutoresizingMaskIntoConstraints = false
        closeButton!.focusRingType = .None
        closeButton!.title = "X";
        closeButton!.action = "quitapp"
        view.addSubview(closeButton!)
        
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[closeButton(==20)]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["closeButton":closeButton!]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-(0)-[webView(==580)]-[closeButton(==20)]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["closeButton":closeButton!, "webView":webView!]))
    
        
        
    }
    
    func quitapp() {
        exit(0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fileURL = NSURL(fileURLWithPath:NSBundle.mainBundle().pathForResource("index", ofType:"html")!)

        if webView!.respondsToSelector("loadFileURL:allowingReadAccessToURL:") {
            // iOS9. One year later things are OK.
            if #available(OSX 10.11, *) {
                
                webView!.loadFileURL(fileURL, allowingReadAccessToURL: fileURL)
            } else {
                let url = NSURL(string:"https://wink.blainemiller.xyz/")
                let req = NSURLRequest(URL:url!)
                self.webView!.loadRequest(req)
                // Fallback on earlier versions
            }
        }
    }
}