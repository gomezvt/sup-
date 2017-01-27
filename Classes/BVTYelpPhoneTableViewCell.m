//
//  BVTYelpContactTableViewCell.m
//  burlingtonian
//
//  Created by Greg on 12/23/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "BVTYelpPhoneTableViewCell.h"

@interface BVTYelpPhoneTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLabel;

@end

@implementation BVTYelpPhoneTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelectedBusiness:(YLPBusiness *)selectedBusiness
{
    _selectedBusiness = selectedBusiness;
    
    self.phoneNumberLabel.text = self.selectedBusiness.phone;
}

- (IBAction)didTapPhoneNumberButton:(id)sender
{
    NSString *phoneNumber;
    if ([self.selectedBusiness.phone hasPrefix:@"+"])
    {
        phoneNumber = [self.selectedBusiness.phone substringFromIndex:1];
    }
    else
    {
        phoneNumber = self.selectedBusiness.phone;
    }
    
    NSString *phoneString = [NSString stringWithFormat:@"telprompt:%@", phoneNumber];
    NSURL *phoneURL = [NSURL URLWithString:phoneString];
    
    [[UIApplication sharedApplication] openURL:phoneURL options:@{} completionHandler:^(BOOL success) {
        NSLog(@"");
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end