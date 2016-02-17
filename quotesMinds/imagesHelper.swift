//
//  imagesHelper.swift
//  everyday
//
//  Created by thiagoracca on 1/24/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit

extension UIImageView{
    func addDarkBlur(){
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        self.addSubview(blurView)
        blurView.frame = CGRectMake(0, 0, self.superview!.bounds.width+1, self.superview!.bounds.height)
        
    }
}

extension UIImage{
    convenience init?(withAuthor: String) {
        var authorName = withAuthor
        authorName = authorName.lowercaseString;
        authorName = authorName.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
        authorName = authorName.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let bundlePath = NSBundle.mainBundle().pathForResource(authorName, ofType: "jpg")
        if bundlePath != nil {
            self.init(contentsOfFile: bundlePath!)
        }
        else
        {
            self.init()
        }
    }
    
    convenience init?(withAuthorThumb: String) {
        var authorName = withAuthorThumb
        authorName = authorName.lowercaseString;
        authorName = authorName.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
        authorName = authorName.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let bundlePath = NSBundle.mainBundle().pathForResource("\(authorName)-Thumb.jpg", ofType: nil)
        if bundlePath != nil {
            self.init(contentsOfFile: bundlePath!)

        }
        else
        {
            self.init()
        }
    }
    
    convenience init?(namedClean: String) {
        if let bundlePath = NSBundle.mainBundle().pathForResource(namedClean, ofType: nil){
            self.init(contentsOfFile: bundlePath)
        }
        else
        {
            self.init()
        }
    }
}
