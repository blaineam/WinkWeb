import AppKit
import WebKit

class ContentViewController : NSViewController, NSTextFieldDelegate {
    var webView: WKWebView?
    var closeButton: NSButton?
    var textfield: NSTextField?
    var demo: String = "https://wink.blainemiller.xyz/"
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    func checkURL(url : String!) -> Bool {
        
        let req = NSMutableURLRequest(URL: NSURL(string: url)!)
        req.HTTPMethod = "HEAD"
        req.timeoutInterval = 1.0 // Adjust to your needs
        
        var response : NSURLResponse?
            
        do{
           try NSURLConnection.sendSynchronousRequest(req, returningResponse: &response)
        }catch{
            
        }
        
        return ((response as? NSHTTPURLResponse)?.statusCode ?? -1) == 200
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
        
        textfield = NSTextField()
        textfield!.translatesAutoresizingMaskIntoConstraints = false
        textfield!.focusRingType = .None
        textfield?.action = "loadnewurl"
        textfield!.placeholderString = demo;
        view.addSubview(textfield!)
        
  
        closeButton = NSButton()
        closeButton!.translatesAutoresizingMaskIntoConstraints = false
        closeButton!.focusRingType = .None
        closeButton!.title = "X";
        closeButton!.action = "quitapp"
        view.addSubview(closeButton!)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[textfield(==360)]-[closeButton(==20)]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["textfield":textfield!, "closeButton":closeButton!]))

        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|-(0)-[webView(==580)]-[closeButton(==20)]-(0)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["closeButton":closeButton!, "webView":webView!]))
    
        
        
    }
    
    func quitapp() {
        exit(0)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        textfield!.delegate = self
        loadUrl()
        
    }
    func loadUrl(){
        let defaults = NSUserDefaults.standardUserDefaults()
        if let curl = defaults.stringForKey("url")
        {
            if(checkURL(curl)){
                let url = NSURL(string:curl)
                let req = NSURLRequest(URL:url!)
                self.webView!.loadRequest(req)
                
                textfield!.stringValue = curl;
            }else{
                loaddefaulturl()
            }
        }else{
            loaddefaulturl()
        }
    }
    func loadnewurl(){
        NSLog("fired")
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(textfield!.stringValue, forKey: "url")
        loadUrl()
    }
    func loaddefaulturl(){
        if(checkURL(demo)){
            let url = NSURL(string:demo)
            let req = NSURLRequest(URL:url!)
            self.webView!.loadRequest(req)
            
            textfield!.stringValue = demo;
        }
    }
    func textDidEndEditing(_notification: NSNotification){
        NSLog("fired")
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(textfield!.stringValue, forKey: "url")
        loadUrl()
    }
}