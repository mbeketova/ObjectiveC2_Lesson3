//
//  Animations.h
//  ObjectiveC2_Lesson3
//
//  Created by Admin on 17.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Animations : NSObject

+ (void) move_SubView:(UIView*)view Alpha:(int)alpha;
+ (void) move_ViewMapTop:(UIView*)view Points:(int)points;

@end
