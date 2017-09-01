//
//  SUPExploreViewController.m
//  Sup? City
//
//  Created by Greg on 12/20/16.
//  Copyright © 2016 gomez. All rights reserved.
//

#import "SUPExploreViewController.h"

#import "SUPCategoryTableViewController.h"
#import "SUPExploreCollectionViewCell.h"
#import "SUPHeaderTitleView.h"
#import "SUPStyles.h"
#import "AppDelegate.h"

@interface SUPExploreViewController () <SUPCategoryTableViewControllerDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic) BOOL isLargePhone;
@property (nonatomic, strong) SUPHeaderTitleView *headerTitleView;
@property (nonatomic, strong) UITextField *alertTextField;
@end

static NSArray *businessesToDisplay;
static NSString *const kHeaderTitleViewNib = @"SUPHeaderTitleView";
static NSString *const kCollectionViewCellNib = @"SUPExploreCollectionViewCell";
static NSString *const kShowCategorySegue = @"ShowCategory";
static NSString *const kShowSubCategorySegue = @"ShowSubCategory";

@implementation SUPExploreViewController

- (void)didTapBackWithDetails:(NSMutableDictionary *)details
{
    self.cachedDetails = details;
}

#pragma mark - View Life Cycle

- (IBAction)didTapPlusButton:(id)sender
{
//    self.headerTitleView.cityNameLabel.text = @":  San Francisco";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter a Place" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.alertTextField = textField;
        self.alertTextField.placeholder = @"Enter city, state, or zip code...";

    }];
    
    
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *city = self.alertTextField.text;
        if (city.length > 0)
        {
            kCity = city;
            self.headerTitleView.cityNameLabel.text = [NSString stringWithFormat:@":  %@", [self.alertTextField.text capitalizedString]];
        }
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    self.headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    self.headerTitleView.titleViewLabelConstraint.constant = 20.f;
    self.navigationItem.titleView = self.headerTitleView;
    self.navigationController.navigationBar.barTintColor = [SUPStyles iconBlue];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(gotCity:)
                                                 name: @"gotCity"
                                               object: nil];
}

- (void)newCityEntry
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Enter a Place to Get Started" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.alertTextField = textField;
        self.alertTextField.placeholder = @"Enter city, state, or zip code...";
    }];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *city = self.alertTextField.text;
        if (city.length > 0 && ![[city stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""])
        {
            kCity = city;
            self.headerTitleView.cityNameLabel.text = [NSString stringWithFormat:@":  %@", [self.alertTextField.text capitalizedString]];
        }
    }];
    [alertController addAction:confirmAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)gotCity:(NSNotification *)notification
{
    id obj = notification.object;
    AppDelegate *appDel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDel.city = nil;
    if ([obj isKindOfClass:[NSError class]])
    {
        if (!appDel.city)
        {
            [self newCityEntry];
        }
        else
        {
            
        }
    }
    else if (!appDel.city)
    {
        [self newCityEntry];
    }
    else
    {
        NSString *city = notification.object;
        kCity = city;
        self.headerTitleView.cityNameLabel.text = [NSString stringWithFormat:@":  %@", [city capitalizedString]];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (kCity)
    {
        self.headerTitleView.cityNameLabel.text = [NSString stringWithFormat:@":  %@", [kCity capitalizedString]];
    }
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    if ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular &&
         self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) && mainScreen.size.width == 1024.f)
    {
        [self.headerTitleView.supLabel setFont:[UIFont boldSystemFontOfSize:24]];
        [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:24]];
    }
    else
    {
        if (mainScreen.size.width > 375.f)
        {
            [self.headerTitleView.supLabel setFont:[UIFont boldSystemFontOfSize:24]];
            [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:24]];
        }
        else if (mainScreen.size.width == 375.f)
        {
            [self.headerTitleView.supLabel setFont:[UIFont boldSystemFontOfSize:21]];
            [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:21]];
        }
        else
        {
            [self.headerTitleView.supLabel setFont:[UIFont boldSystemFontOfSize:18]];
            [self.headerTitleView.cityNameLabel setFont:[UIFont boldSystemFontOfSize:18]];
            
        }
    }
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];



    
    UINib *cellNib = [UINib nibWithNibName:kCollectionViewCellNib bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"Cell"];
    
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    if ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular &&
         self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) && mainScreen.size.width == 1024.f)
    {
        self.isLargePhone = YES;
        [self.collectionView setContentInset:UIEdgeInsetsMake(120.f,10.f,0.f,10.f)];
    }
    else
    {
        if (mainScreen.size.width > 375.f)
        {
            self.isLargePhone = YES;
            [self.collectionView setContentInset:UIEdgeInsetsMake(20.f,10.f,0.f,10.f)];
        }
        else if (mainScreen.size.width == 375.f)
        {
            self.isLargePhone = NO;
            [self.collectionView setContentInset:UIEdgeInsetsMake(30.f, 5.f, 0.f, 5.f)];
        }
        else
        {
            self.isLargePhone = NO;
            [self.collectionView setContentInset:UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f)];
        }
    }
    

}

#pragma mark - CollectionView Delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return kSUPCategories.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
{
    CGFloat spacing;
    CGRect mainScreen = [[UIScreen mainScreen] bounds];
    if ((self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular &&
         self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular) && mainScreen.size.width == 1024.f)
    {
        spacing = 100.f;
    }
    else
    {
        spacing = 20.f;
    }
    
    return spacing;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size;
    if (self.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular &&
        self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular)
    {
        CGRect mainScreen = [[UIScreen mainScreen] bounds];
        if (mainScreen.size.width == 1024.f)
        {
            return CGSizeMake(200.f, 150.f);
        }
        else
        {
            return CGSizeMake(150.f, 150.f);
        }
    }
    else
    {
        if (self.isLargePhone)
        {
            size = CGSizeMake(100, 150);
        }
        else
        {
            size = CGSizeMake(80, 120);
        }
    }

    return size;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SUPExploreCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.titleLabel.text = [kSUPCategories objectAtIndex:indexPath.row];
    

    if (self.isLargePhone)
    {
        cell.imageWidth.constant = 84.f;
        cell.imageHeight.constant = 84.f;
        cell.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [cell.titleLabel sizeToFit];
        
        if (indexPath.row == 0)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iMuseum"];
        }
        else if (indexPath.row == 1)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iCoffee"];
        }
//        else if (indexPath.row == 2)
//        {
//            cell.menuItemView.image = [UIImage imageNamed:@"iMusic"];
//        }
        else if (indexPath.row == 2)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iHotels"];
        }
        else if (indexPath.row == 3)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iRecreation"];
        }
        else if (indexPath.row == 4)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iBars"];
        }
        else if (indexPath.row == 5)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iEat"];
        }
        else if (indexPath.row == 6)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iShopping"];
        }
        else if (indexPath.row == 7)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iTours"];
        }
        else if (indexPath.row == 8)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"iTravel"];
        }
    }
    else
    {
        cell.imageWidth.constant = 64.f;
        cell.imageHeight.constant = 64.f;
        cell.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [cell.titleLabel sizeToFit];
        
        if (indexPath.row == 0)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isMuseum"];
        }
        else if (indexPath.row == 1)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isCoffee"];
        }
//        else if (indexPath.row == 2)
//        {
//            cell.menuItemView.image = [UIImage imageNamed:@"isMusic"];
//        }
        else if (indexPath.row == 2)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isHotels"];
        }
        else if (indexPath.row == 3)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isRecreation"];
        }
        else if (indexPath.row == 4)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isBars"];
        }
        else if (indexPath.row == 5)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isEat"];
        }
        else if (indexPath.row == 6)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isShopping"];
        }
        else if (indexPath.row == 7)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isTours"];
        }
        else if (indexPath.row == 8)
        {
            cell.menuItemView.image = [UIImage imageNamed:@"isTravel"];
        }
    }

    
    
    return cell;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(CGRectGetWidth(collectionView.frame), (CGRectGetHeight(collectionView.frame)));
//}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SUPExploreCollectionViewCell *cell = (SUPExploreCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *selectionTitle = cell.titleLabel.text;
    
    [self performSegueWithIdentifier:kShowCategorySegue sender:selectionTitle];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SUPCategoryTableViewController *vc = [segue destinationViewController];
    vc.categoryTitle = sender;
    vc.delegate = self;
    vc.cachedDetails = self.cachedDetails;
}

@end
