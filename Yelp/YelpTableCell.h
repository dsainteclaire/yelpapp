//
//  YelpTableCell.h
//  Yelp
//
//  Created by David Sainte-Claire on 6/23/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YelpTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterImage;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end
