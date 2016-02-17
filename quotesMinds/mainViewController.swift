//
//  mainViewController.swift
//  everyday
//
//  Created by thiagoracca on 1/23/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit


class mainViewController: UIViewController,UIScrollViewDelegate,quotesModel,userModel,visualHelper,logHelper{
    
    var logLevel : Int = 3
    
    @IBOutlet var bg1 : UIImageView? = UIImageView()
    @IBOutlet var face : UIImageView? = UIImageView()
    @IBOutlet var faceTitle : UILabel?
    @IBOutlet var wikiButton : UIButton?
    @IBOutlet var nextTitle : UILabel?
    @IBOutlet var changeButton : UIButton?
    @IBOutlet var bgColor : UIView? = UIView()
    @IBOutlet weak var labelHeight: NSLayoutConstraint!
    @IBOutlet var navigationBackground : UIView?
    @IBOutlet var scrollView : UIScrollView?
    @IBOutlet var quoteLabel : UILabel?
    @IBOutlet var coverView : UIView?
    @IBOutlet weak var quoteMark: UIImageView?
    
    var shouldAnimate : Bool = true
    var navigationVisible : Bool = true
    var blurView : UIVisualEffectView?
    var titleLabel : UILabel = UILabel()
    var backgroundColor : UIColor = UIColor()
    var authorName : String = ""
    
    
    @IBAction func share(sender: AnyObject) {
        let quote : String = (self.quoteLabel?.attributedText?.string)!
        let authorName : String = self.authorName
        let vc = UIActivityViewController(activityItems: ["\(quote)\n\n\(authorName)"], applicationActivities: nil)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    @IBAction func showWiki(sender: AnyObject) {
        let author = self.authorName.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let svc = customSafariViewController(URL: NSURL(string: "https://en.wikipedia.org/wiki/\(author)")!)
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
    @IBAction func showTime(sender: AnyObject) {
        self.performSegueWithIdentifier("openTime", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.eraseNavigation()
        self.coverView?.backgroundColor = UIColor.blackColor()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animateWithDuration(0.1, animations: {
            self.coverView?.alpha = 1
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let myAuthors : Array = self.getSelectedAuthors();
        if(myAuthors.count != 0){
            startApplication()
            UIView.animateWithDuration(0.1, animations: {
                self.coverView?.alpha = 0
            })
        }

    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let myAuthors : Array = self.getSelectedAuthors();
        if(myAuthors.count == 0){
            self.createSlots()
            self.performSegueWithIdentifier("openStart", sender: self)
           
        }
        self.checkScrollViewContent()
        self.determineScrollViewPosition(self.scrollView!)
    }
    
    
    func startApplication(){
        let arrDate = self.getLastHistory()
        var dataDict : Dictionary<String,AnyObject>!
        if(arrDate.count == 0){
                let responseArr = self.getSelectedAuthorsPosts(1,1)
                if(responseArr.count > 0){
                   if let postDict  = responseArr[0] as? Dictionary<String,AnyObject>{
                        dataDict = postDict
                        let df = NSDateFormatter()
                        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let datefinalString = df.stringFromDate(NSDate())
                        if let postId :Int = dataDict["id"] as? Int {
                          self.insertHistoryQuote(datefinalString, postId: postId)
                        }
                    }
                   
                }
            }else{
                if let postDict  = arrDate[0] as? Dictionary<String,AnyObject>{
                        if let postId = postDict["post_id"] as? Int{
                        let dict = self.getPostAuthorDetails(postId)
                            dataDict = dict
                        }
                    
            }
        }
        if (dataDict != nil){
        self.scrollView?.delegate = self
        self.titleLabel = UILabel()
            var text :String = dataDict["text"] as! String;
            text = "\(text)"
            let arrayWords = text.componentsSeparatedByString(" ")
            let totalWords : Int = arrayWords.count
            self.println("total of words \(totalWords)", level: 1);
            
            var fontSize = 0
            if (totalWords > 15){
                fontSize = 30
            }
            else
            {
                fontSize = 40
            }
            
            let mutatedAttributes : [String:AnyObject] = self.attributedWithSize(defaultValues().titleAttributes, size: fontSize)
            let mutableString : NSAttributedString = NSAttributedString(string: text, attributes: mutatedAttributes)
            self.quoteLabel?.attributedText = mutableString
            self.quoteLabel?.ajustsSize()
            self.quoteLabel?.backgroundColor = UIColor.clearColor()
            self.labelHeight.constant = (self.quoteLabel?.frame.height)!
            
            let authorName : String = dataDict["name"] as! String;
            self.authorName = authorName
            
            let attributedTitle = NSAttributedString(string: "", attributes: mutatedAttributes)
            titleLabel.attributedText = attributedTitle
            titleLabel.sizeToFit()
            self.navigationItem.titleView = titleLabel
            
            self.bg1?.image = UIImage(withAuthor: authorName)
            self.face?.image = UIImage(withAuthor: authorName)
            self.face?.roundCorners()
            
            self.faceTitle?.text = authorName
            
            var slotId : Int!
            if let authorId = dataDict["author_id"] as? Int {
                    let checkSlotId = self.checkIfAuthorisInSomeSlot(authorId)
                    slotId = checkSlotId
                
            }
            if slotId == nil {
                slotId = Int(arc4random_uniform(6))
            }
            
            self.backgroundColor = defaultValues().colors[slotId]
            self.wikiButton?.setTitleColor(defaultValues().secondaryColors[slotId], forState: UIControlState.Normal)
            self.changeButton?.setTitleColor(defaultValues().secondaryColors[slotId], forState: UIControlState.Normal)
            self.bgColor?.backgroundColor = self.backgroundColor
            self.quoteMark?.image = UIImage(namedClean: defaultValues().quoteImg[slotId])
            self.checkScrollViewContent()
            self.determineScrollViewPosition(self.scrollView!);
        }
        
        if let timeNotification = self.getLastNotification() {
            self.println("lastNotification \(timeNotification)")
            let strTime: String? = timeNotification["date"] as? String
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = formatter.dateFromString(strTime!)
            let dateInic : NSDate = NSDate()
            let df = NSDateFormatter()
            df.dateFormat = "yyyy-MM-dd"
            let datebeginString = df.stringFromDate(dateInic)
            let dateEnd : NSDate = date!
            df.dateFormat = "HH:mm:ss"
            let datefinalString = df.stringFromDate(dateEnd)
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let finalDate = formatter.dateFromString("\(datebeginString) \(datefinalString)")
            var difference : NSTimeInterval = NSDate().timeIntervalSinceDate(finalDate!)
            difference = (abs(difference))
            self.nextTitle?.addBorderClock()
        }
        else{
       
            self.nextTitle!.text = "no notification set"
            self.nextTitle?.addBorderClock()
        }
            
        
    }
    
    func stringFromTimeInterval(interval:NSTimeInterval) -> String {
        let ti = NSInteger(interval)
        //let ms = Int((interval % 1) * 1000)
        //let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        if(hours == 0){
            return "\(minutes)min"
        }
        
        if(hours == 1){
         return "\(hours)h \(minutes)min"
        
        }
        return "\(hours)hs"
    }
    
    func checkScrollViewContent(){
        let lastView: UIView = self.scrollView!.viewWithTag(1)!
        let wd = Double((lastView.frame.origin.y));
        let ht = Double(lastView.frame.size.height);
        let sizeOfContent : CGFloat = CGFloat(wd+ht+10.0);
        self.scrollView?.contentSize = CGSizeMake((self.scrollView?.frame.size.width)!, sizeOfContent);
        if (scrollView!.contentOffset.y >= (scrollView!.contentSize.height - scrollView!.frame.size.height)) {
            self.shouldAnimate = true
        }
        else
        {
            self.shouldAnimate = true
        }
        insertTop()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        determineScrollViewPosition(scrollView);
        
    }
    
    func determineScrollViewPosition(scrollView: UIScrollView) -> Bool{
        if(self.shouldAnimate){
            if(scrollView.contentOffset.y >= 285){
                self.animateShowTop()
            }
            else if(scrollView.contentOffset.y <= 286)
            {
                self.animateHideTop()
            }
        }
        return true;
    }
    
    func determineScrollViewPositionInstant(scrollView: UIScrollView, blurView: UIVisualEffectView?) -> Bool{
        if(self.shouldAnimate){
            if(scrollView.contentOffset.y >= 285){
                blurView!.alpha = 1
            }
            else if(scrollView.contentOffset.y <= 286)
            {
                 blurView!.alpha = 0
            }
        }
        return true;
    }
    
    func insertTop(){
        let lightBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        self.blurView?.removeFromSuperview();
        self.blurView = UIVisualEffectView(effect: lightBlur)
        self.blurView!.frame = (self.navigationBackground?.bounds)!
        self.determineScrollViewPositionInstant(self.scrollView!, blurView: self.blurView!)
        self.navigationBackground?.addSubview(self.blurView!)
    }

    func animateHideTop(){
        if(self.navigationVisible){
            UIView.animateWithDuration(0.15, delay: 0.15, options: .CurveEaseOut, animations: {
                self.blurView?.alpha = 0
                }, completion: { finished in
                    self.navigationVisible = false
            })
        }
    }
    
    func animateShowTop(){
        if(self.navigationVisible == false){
            UIView.animateWithDuration(0.15, delay: 0.15, options: .CurveEaseOut, animations: {
                self.blurView?.alpha = 1
                }, completion: { finished in
                    self.navigationVisible = true
            })
            
        }
        
    }



}
