//
//  CustomTableViewCell.h
//  ObjectiveC2_Lesson3
//
//  Created by Admin on 13.05.15.
//  Copyright (c) 2015 Mariya Beketova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *label_City;
@property (strong, nonatomic) IBOutlet UILabel *label_Street;
@property (strong, nonatomic) IBOutlet UILabel *label_ZIP;


@end
