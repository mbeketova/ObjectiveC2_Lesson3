//
//  Animations.m
//  ObjectiveC2_Lesson3
//
//  Created by Admin on 17.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import "Animations.h"

@implementation Animations


+ (void) move_SubView:(UIView*)view Alpha:(int)alpha {
    //данный метод отодвигает вью вниз и возвращает вверх
    
    CATransition * animation = [CATransition animation];
    animation.type = kCATransitionPush; // вид анимации
    
    if (alpha == 0) {
        animation.subtype = kCATransitionFromBottom;
    }
    
    else  {
        animation.subtype = kCATransitionFromTop;
    }
    
    animation.duration = 0.35; //интервал анимации
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [animation setFillMode:kCAFillModeBoth]; //как длится анимация
    
    [view.layer addAnimation:animation forKey:@"Fade"];
    view.alpha = alpha;
    
}


+ (void) move_ViewMapTop:(UIView*)view Points:(int)points {
    
    //данный метод отодвигает Лейбл в текстовом фрейме - вверх, а так же меняет цвет текста
    
    
    CGRect newFrame = [view frame];
    newFrame.origin.y = view.frame.origin.y + points; //сдвигает лейбл по оси y
    
    //данная анимация отодвигает view мягко
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
        view.frame = newFrame;
        ino64_t delay = 10; //указываем задержку смены цвета
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_MSEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            
            CATransition * animation = [CATransition animation];
            animation.type = kCATransitionFade; // вид анимации
            animation.duration = 0.2; //интервал анимации
            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            [animation setFillMode:kCAFillModeBoth]; //как длится анимация
            
            [view.layer addAnimation:animation forKey:@"Fade"];
    
            
        });
        
        
        
    } completion:^(BOOL finished) {
        
    }];
    
}



@end
