//
//  visualObject.m
//  everyday
//
//  Created by thiagoracca on 2/3/16.
//  Copyright © 2016 vupe. All rights reserved.
//

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

#import "visualObject.h"

@implementation visualObject

-(void)startToShake : (UIView *)itemView{
    itemView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-2));

    [UIView animateWithDuration:0.15
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse)
                     animations:^ {
                         itemView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(2));
                     }
                     completion:NULL
     ];
}

-(void)stopToShake : (UIView *)itemView {
    [UIView animateWithDuration:0.15
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear)
                     animations:^ {
                         itemView.transform = CGAffineTransformIdentity;
                     }
                     completion:NULL
     ];
}
@end
