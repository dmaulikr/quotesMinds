//
//  imagesHelper.swift
//  everyday
//
//  Created by thiagoracca on 1/24/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit
import AlamofireImage

class imageHelper {
    
    let imageDownloader = ImageDownloader(
        configuration: ImageDownloader.defaultURLSessionConfiguration(),
        downloadPrioritization: .FIFO,
        maximumActiveDownloads: 4,
        imageCache: AutoPurgingImageCache()
    )
    
    static let sharedInstance = imageHelper()
    
    var blurView : UIVisualEffectView!
    
    func addLightBlurScreen(onImageView: UIImageView){
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Light)
        blurView = UIVisualEffectView(effect: darkBlur)
        onImageView.subviews.forEach({ $0.removeFromSuperview() })
        blurView.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        blurView.alpha = 0.8
        onImageView.addSubview(blurView)
        
    }
    
    
    func removeBlurScreen(onImageView: UIImageView){
        UIView.animateWithDuration(1.0, animations: {
            self.blurView.alpha = 0
        })
    }
    
    
    func loadAuthor(var authorName: String, onImageView: UIImageView, onURL : NSURL) {
        authorName = authorName.lowercaseString;
        authorName = authorName.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
        authorName = authorName.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let bundlePath = NSBundle.mainBundle().pathForResource("\(authorName)-Thumb.jpg", ofType: nil)
        if bundlePath != nil {
            let placeholderImage = UIImage(contentsOfFile: bundlePath!)
            onImageView.af_setImageWithURL(onURL, placeholderImage: placeholderImage)
            self.addLightBlurScreen(onImageView)
        }
        
    }
    
    func loadImage(withAuthor: String, onImageView: UIImageView){
      
        var authorName = withAuthor
        authorName = authorName.lowercaseString;
        authorName = authorName.stringByReplacingOccurrencesOfString(" ", withString: "_", options: NSStringCompareOptions.LiteralSearch, range: nil)
        authorName = authorName.stringByReplacingOccurrencesOfString(".", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let URLImage = NSURL(string: "https://gator3078.hostgator.com/~racker/quotesminds/img/\(authorName).jpg")!
        let URLRequest = NSURLRequest(URL: URLImage)
        self.loadAuthor(withAuthor, onImageView: onImageView, onURL : URLImage)
   
        
       
        imageDownloader.downloadImage(URLRequest: URLRequest) { response in
            //print(response.request)
            //print(response.response)
            //debugPrint(response.result)
            
            if let image = response.result.value {
                onImageView.image = image
                self.removeBlurScreen(onImageView)
            }
        }
    }

}



extension UIImageView{
    
    func addDarkBlur(){
        let darkBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        self.subviews.forEach({ $0.removeFromSuperview() })
        self.addSubview(blurView)
        blurView.frame = CGRectMake(0, 0, self.superview!.bounds.width+1, self.superview!.bounds.height)
        
    }
    
  
    
    
    
    
}

extension UIImage{
    
    /*
    func applyBlurEffect() -> UIImage{
        let imageToBlur = UIKit.CIImage(image:self)
        let blurfilter = CIFilter(name: "CIGaussianBlur")
        blurfilter!.setValue(imageToBlur, forKey: "inputImage")
        let resultImage = blurfilter!.valueForKey("outputImage") as! UIKit.CIImage
        let blurredImage = UIImage(CIImage: resultImage)
        return blurredImage
    }
    */
    
    convenience init?(withAuthor: String) {
        var authorName = withAuthor
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
