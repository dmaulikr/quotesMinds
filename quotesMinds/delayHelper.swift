//
//  delayHelper.swift
//  everyday
//
//  Created by thiagoracca on 2/1/16.
//  Copyright © 2016 vupe. All rights reserved.
//

import UIKit

class delay: NSObject {
    init(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }

}
