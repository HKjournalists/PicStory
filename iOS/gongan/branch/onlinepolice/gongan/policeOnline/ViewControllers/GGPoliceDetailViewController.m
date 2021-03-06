//
//  GGPoliceDetailViewController.m
//  policeOnline
//
//  Created by towne on 13-4-30.
//  Copyright (c) 2013年 tmd. All rights reserved.
//

#import "GGPoliceDetailViewController.h"
#import "GGAPIService.h"

#define RELOADGGPOLICEMAN  @"RELOADGGPOLICEMAN"

@interface GGPoliceDetailViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *svContent;
@property (weak, nonatomic) IBOutlet UIImageView *ivPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnAddFavor;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblNumber;
@property (weak, nonatomic) IBOutlet UILabel *lblStation;
@property (weak, nonatomic) IBOutlet UIButton *btnPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnStationPhone;
@property (weak, nonatomic) IBOutlet UIButton *btnSuperviserPhone;

@end

@implementation GGPoliceDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)getMyfavorite:(id)sender
{
    DLog(@"getMyfavorite");
    if (self.keep == YES) {
        [[GGAPIService sharedInstance] insertPolicemanToDB:_policeman aCompletion:^(BOOL success){
            if (success == YES) {
                [self showError:@"收藏成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:RELOADGGPOLICEMAN object:nil];
            }
            else
            {
                [self showError:@"您已经收藏，无需重复收藏"];
            }
        }];
    }
    else
    {
        [[GGAPIService sharedInstance] delPolicemanFromDB:_policeman aCompletion:^(BOOL success){
            if (success == YES) {
                [self showError:@"取消成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:RELOADGGPOLICEMAN object:nil];
            }
        }];
        
    }
    
}

-(IBAction)CALL:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton * btn = sender;
        if (btn.tag == 101) {
            [GGUtils call:_policeman.phone];
        }
        if (btn.tag == 102) {
            [GGUtils call:_policeman.stationPhone];
        }
        if (btn.tag == 103) {
            [GGUtils call:_policeman.superviserPhone];
        }
    }
}

-(void)showError:(NSString *)error
{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:error delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alertView show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = _naviTitleString;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.ivPhoto.layer.borderColor = GGSharedColor.lightGray.CGColor;
    self.ivPhoto.layer.borderWidth = 2.f;
    self.ivPhoto.layer.cornerRadius = 2.f;
    
    NSURL *nsurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", GGN_STR_PRODUCTION_SERVER_URL,_policeman.photo]];
    [self.ivPhoto setImageWithURL:nsurl];
    
    [self.lblName setText:_policeman.name];
    [self.lblNumber setText:_policeman.number];
    [self.lblStation setText:_policeman.stationName];
    [self.btnPhone setTitle:_policeman.phone forState:UIControlStateNormal];
    [self.btnStationPhone setTitle:_policeman.stationPhone forState:UIControlStateNormal];
    [self.btnSuperviserPhone setTitle:_policeman.superviserPhone forState:UIControlStateNormal];
    
    if (self.keep == YES)
        [self.btnAddFavor setTitle:@"收藏" forState:UIControlStateNormal];
    else
        [self.btnAddFavor setTitle:@"取消收藏" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setPoliceman:nil];
    [self setSvContent:nil];
    [self setIvPhoto:nil];
    [self setBtnAddFavor:nil];
    [self setLblName:nil];
    [self setLblNumber:nil];
    [self setLblStation:nil];
    [self setBtnPhone:nil];
    [self setBtnStationPhone:nil];
    [self setBtnSuperviserPhone:nil];
    [super viewDidUnload];
}
@end
