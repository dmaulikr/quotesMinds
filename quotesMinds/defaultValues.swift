//
//  defaultValues.swift
//  everyday
//
//  Created by thiagoracca on 1/22/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit

struct defaultValues {
    
    let appLogLevel : Int = 0
    
    let colors: Array <UIColor> = [
        /*A Bg Blue*/  UIColor(red: 21/256.0, green:9/256.0, blue:255/256.0, alpha: 0.7),
        /*B Bg Green*/  UIColor(red: 0/256.0, green:150/256.0, blue:11/256.0, alpha: 0.7),
        /*C Bg Red*/  UIColor(red: 255/256.0, green:4/256.0, blue:72/256.0, alpha: 0.7),
        /*D Bg Violet*/ UIColor(red: 124/256.0, green:0/256.0, blue:127/256.0, alpha: 0.7),
        /*E Bg Yellow*/ UIColor(red: 229/256.0, green:187/256.0, blue:1/256.0, alpha: 0.7),
        /*F Bg Orange*/ UIColor(red: 255/256.0, green:129/256.0, blue:1/256.0, alpha: 0.7)
    ]
    
    let secondaryColors: Array <UIColor> = [
        /*A TxtBlue*/ UIColor(red: 150/256.0, green:255/256.0, blue:36/256.0, alpha: 1),
        /*B TxtGreen*/ UIColor(red: 255/256.0, green:236/256.0, blue:0/256.0, alpha: 1),
        /*C TxtRed*/ UIColor(red: 0/256.0, green:255/256.0, blue:108/256.0, alpha: 1),
        /*D TxtViolet*/ UIColor(red: 150/256.0, green:255/256.0, blue:36/256.0, alpha: 1),
        /*E TxtYellow*/ UIColor(red: 150/256.0, green:255/256.0, blue:36/256.0, alpha: 1),
        /*F TxtOrange*/ UIColor(red: 150/256.0, green:255/256.0, blue:36/256.0, alpha: 1)
    ]
    
    let titleAttributes = [
        NSFontAttributeName:UIFont(name: "HelveticaNeue-Bold", size: 17)!,
        NSForegroundColorAttributeName:UIColor.whiteColor(),
        NSKernAttributeName:CGFloat(1.0)
    ]
    
    let quoteImg = [
        "color-a-quotation-mark@2x.png",
        "color-b-quotation-mark@2x.png",
        "color-c-quotation-mark@2x.png",
        "color-d-quotation-mark@2x.png",
        "color-e-quotation-mark@2x.png",
        "color-f-quotation-mark@2x.png"
    ]
    
    let imagesBg = [
        "art@2x.jpg",
        "humor@2x.jpg",
        "love@2x.jpg",
        "motivational@2x.jpg",
        "wisdom@2x.jpg",
        "art@2x.jpg",
        "humor@2x.jpg",
        "love@2x.jpg",
        "motivational@2x.jpg",
        "wisdom@2x.jpg",
        "art@2x.jpg",
        "humor@2x.jpg",
        "love@2x.jpg",
        "motivational@2x.jpg",
        "wisdom@2x.jpg"
    ]
}

