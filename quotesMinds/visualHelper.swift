//
//  visualHelper.swift
//  everyday
//
//  Created by thiagoracca on 1/23/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit
import SafariServices

protocol visualHelper {
    func println(str: String);
    func println(str: String, level: Int);

}

extension visualHelper {
    func attributedWithSize(attributed : [String:AnyObject], size: Int) -> [String:AnyObject] {
        var attr = attributed
        if let font : UIFont = attr[NSFontAttributeName] as? UIFont {
            attr[NSFontAttributeName] = UIFont(name: "\((font.fontName))", size: CGFloat(size))
        }
        return attr
    }
}

class customSafariViewController: SFSafariViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UINavigationBar.appearance().barStyle = .Black
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.setNeedsStatusBarAppearanceUpdate()
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        UINavigationBar.appearance().barStyle = .Black
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        self.setNeedsStatusBarAppearanceUpdate()
        return UIStatusBarStyle.LightContent
    }
}

extension NSDate {
    var formatted: String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm:ss Z"
        return  formatter.stringFromDate(self)
    }
}

extension UILabel {
    func ajustsSize(){
        self.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        self.numberOfLines = 0;
        self.adjustsFontSizeToFitWidth = true
        self.minimumScaleFactor=0.5;
        self.sizeToFit()
    }
    
    func addBorderClock(){
        var stringCopy : String = ""
        if let attributedText : NSAttributedString = self.attributedText! {
            if(attributedText.string != ""){
                stringCopy = attributedText.string
            }
        }
        
        if (self.text != nil) {
            if self.text != "" {
            stringCopy = self.text!
            }
        }
        
        let attributedString = NSMutableAttributedString(string:" \(stringCopy)")
        let attachment : NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: "icon-timer")
        let mutableString : NSMutableAttributedString = NSMutableAttributedString()
        mutableString.appendAttributedString(NSAttributedString(attachment: attachment))
        mutableString.appendAttributedString(attributedString)
        self.attributedText = mutableString
    }
}

extension UIButton{
    func roundWhiteBorderCorners(){
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 7
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.whiteColor().CGColor
        let attributedText : NSAttributedString = self.attributedTitleForState(UIControlState.Normal)!
        
        var finalString : String = ""
        var string : String = "\(attributedText.string)"
        let removedChar = string.removeAtIndex(string.startIndex.successor())
        if(removedChar == " "){
            print("removeChar \(removedChar)");
            finalString = string
        }
        else
        {
            finalString = attributedText.string
        }
        
        let range : NSRange = NSMakeRange(0, finalString.characters.count)
        let attributedString = NSMutableAttributedString(string:finalString)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor() , range: range)
        let attachment : NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage()
        let mutableString : NSMutableAttributedString = NSMutableAttributedString()
        mutableString.appendAttributedString(NSAttributedString(attachment: attachment))
        mutableString.appendAttributedString(attributedString)
        self.setAttributedTitle(mutableString, forState: UIControlState.Normal)
    }
    
    func roundSelectedBorderCorners(){
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 7
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.whiteColor().CGColor
        let attributedText : NSAttributedString = self.attributedTitleForState(UIControlState.Normal)!
        let attributedString = NSMutableAttributedString(string:" \(attributedText.string)")
        let range : NSRange = NSMakeRange(0, attributedString.length)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor() , range: range)
        let attachment : NSTextAttachment = NSTextAttachment()
        attachment.image = UIImage(named: "check")
        let mutableString : NSMutableAttributedString = NSMutableAttributedString()
        mutableString.appendAttributedString(NSAttributedString(attachment: attachment))
        mutableString.appendAttributedString(attributedString)
        self.setAttributedTitle(mutableString, forState: UIControlState.Normal)
    }
}

extension UIView {
    func roundCorners(){
        self.layer.cornerRadius = self.bounds.height/2
        self.layer.masksToBounds = true;
    }
}


extension UINavigationController {
    func eraseNavigation(){
        self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.shadowImage = UIImage()
    }
    func showNavigation(){
        self.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        self.navigationBar.shadowImage = nil
    }
}
