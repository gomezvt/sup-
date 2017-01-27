//
//  BVTThumbNailTableViewCell.m
//  burlingtonian
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTThumbNailTableViewCell.h"

#import "YLPLocation.h"

@implementation BVTThumbNailTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    // Initialization code
}

- (void)setBusiness:(YLPBusiness *)business
{
    _business = business;
    
    NSData *imageData = [NSData dataWithContentsOfURL:business.imageURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    self.thumbNailView.image = image;
    self.titleLabel.text = business.name;
    
    YLPLocation *location = business.location;
    if (location.address.count > 0)
    {
        self.addressLabel.text = location.address[0];
        self.addressLabel2.text = [NSString stringWithFormat:@"%@, %@ %@", location.city, location.stateCode, location.postalCode];
    }
    else
    {
        self.addressLabel.text = nil;
        self.addressLabel2.text = [NSString stringWithFormat:@"%@, %@ %@", location.city, location.stateCode, location.postalCode];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
