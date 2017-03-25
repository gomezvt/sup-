//
//  BVTSurpriseShoppingCartTableViewController.m
//  bvt
//
//  Created by Greg on 2/23/17.
//  Copyright © 2017 gms. All rights reserved.
//

#import "BVTSurpriseShoppingCartTableViewController.h"

#import "BVTSurpriseCategoryTableViewController.h"
#import "BVTHeaderTitleView.h"
#import "BVTStyles.h"

@interface BVTSurpriseShoppingCartTableViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIButton *goButton;

@end

static NSString *const kHeaderTitleViewNib = @"BVTHeaderTitleView";


@implementation BVTSurpriseShoppingCartTableViewController

- (IBAction)didTapSubmit:(id)sender
{
    // WIP
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UINib *nibTitleView = [UINib nibWithNibName:kHeaderTitleViewNib bundle:nil];
    BVTHeaderTitleView *headerTitleView = [[nibTitleView instantiateWithOwner:self options:nil] objectAtIndex:0];
    headerTitleView.titleViewLabelConstraint.constant = -20.f;
    self.navigationItem.titleView = headerTitleView;
    self.navigationController.navigationBar.barTintColor = [BVTStyles iconGreen];
    
}

#pragma mark - IBActions

- (IBAction)didTapBack:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didTapBackWithCategories:)])
    {
        [self.delegate didTapBackWithCategories:self.catDict];
    }
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.goButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.catDict.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSString *key = [self.catDict allKeys][section];
    NSArray *k = [self.catDict objectForKey:key];

    return k.count;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.goButton setEnabled:[self evaluateButtonState]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSArray *array = [self.catDict allValues][section];
    if (array.count > 0)
    {
        return [self.catDict allKeys][section];
    }

        return nil;
}


- (BOOL)evaluateButtonState
{
    BOOL isEnabled = NO;
    NSArray *allValues = [self.catDict allValues];
    for (NSArray *array in allValues)
    {
        if (array.count > 0)
        {
            isEnabled = YES;
            break;
        }
    }
    
    return isEnabled;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSArray *sectionValues = [self.catDict allValues][indexPath.section];

    cell.textLabel.text = sectionValues[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.textLabel.numberOfLines = 0;

    return cell;
}

@end
