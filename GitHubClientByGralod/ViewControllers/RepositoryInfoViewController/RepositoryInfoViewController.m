//
//  RepositoryInfoViewController.m
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import "RepositoryInfoViewController.h"

@interface RepositoryInfoViewController ()
- (IBAction)exitButtonTouchUpInsideAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *reloadDataButton;
- (IBAction)reloadDataButtonTouchUpInsideAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)backButtonTouchUpInsideAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextButtonTouchUpInsideAction:(id)sender;

@end

@implementation RepositoryInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView setDelegate:self.delegate];
    [self.tableView setDataSource:self.delegate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self setupDescriptionLabel];
    });
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateViewControllersData)
                                                 name:@"setNeedsUpdateViewControllersData"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setNextButtonUnable)
                                                 name:@"RepositoryInfoViewController_setNextButtonUnable"
                                               object:nil];
    [self updateViewControllersData];
}

- (void) updateViewControllersData
{
    NSLog(@"UsersRepositoriesViewController_updateViewControllersData");
    if([self.delegate respondsToSelector:@selector(getBackgroundImageForButton:inViewController:)]
       &&[self.delegate respondsToSelector:@selector(getEnableStateForButton:inViewController:)])
    {
        [self.reloadDataButton setImage:[self.delegate getBackgroundImageForButton:self.reloadDataButton
                                                                  inViewController:self]
                               forState:UIControlStateNormal];
        [self.backButton setHidden:![self.delegate getEnableStateForButton:self.backButton
                                                          inViewController:self]];
        [self.nextButton setHidden:![self.delegate getEnableStateForButton:self.nextButton
                                                          inViewController:self]];
        
        [self.tableView reloadData];
    }
    else
        NSLog(@"Bad delegate for UsersRepositoriesViewController!!!!");
}
- (void)setNextButtonUnable
{
    [self.nextButton setBackgroundColor:[UIColor colorWithRed:200.0/256.0
                                                        green:25.0/256.0
                                                         blue:120.0/256.0
                                                        alpha:1]];
    [self.nextButton setEnabled:false];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setNextButtonEnable)
                                                 name:@"RepositoryInfoViewController_setNextButtonEnable"
                                               object:nil];
}
- (void)setNextButtonEnable
{
    [self.nextButton setBackgroundColor:[UIColor colorWithRed:135.0/256.0
                                                        green:50.0/256.0
                                                         blue:235.0/256.0
                                                        alpha:1]];
    [self.nextButton setEnabled:true];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"RepositoryInfoViewController_setNextButtonEnable"
                                                  object:nil];
}
- (void)setupDescriptionLabel
{
    if([self.delegate respondsToSelector:@selector(getContentTextForLabel:inViewController:)])
    {
        NSString *contentTextForDescriptionLabel = [self.delegate getContentTextForLabel:self.descriptionLabel
                                                                        inViewController:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"setupDescriptionLabel, %@",contentTextForDescriptionLabel);
            [self.descriptionLabel setText:contentTextForDescriptionLabel];
        });
    }
    else
        NSLog(@"Bad delegate for UsersRepositoriesViewController!!!!");
}
- (IBAction)exitButtonTouchUpInsideAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(exitActionInViewController:)])
    {
        [self.delegate exitActionInViewController:self];
    }
    else
        NSLog(@"Bad delegate for UsersRepositoriesViewController!!!!");
}
- (IBAction)reloadDataButtonTouchUpInsideAction:(id)sender
{
    NSLog(@"RepositoryInfoViewController_reloadDataButtonTouchUpInsideAction");
    if ([self.delegate respondsToSelector:@selector(reloadDataActionInViewController:)])
    {
        [self.delegate reloadDataActionInViewController:self];
    }
    else
        NSLog(@"Bad delegate for UsersRepositoriesViewController!!!!");
}
- (IBAction)backButtonTouchUpInsideAction:(id)sender
{
    NSLog(@"RepositoryInfoViewController_backButtonTouchUpInsideAction");
    if ([self.delegate respondsToSelector:@selector(backActionInViewController:)])
    {
        [self.delegate backActionInViewController:self];
    }
    else
        NSLog(@"Bad delegate for UsersRepositoriesViewController!!!!");
}
- (IBAction)nextButtonTouchUpInsideAction:(id)sender
{
    NSLog(@"RepositoryInfoViewController_nextButtonTouchUpInsideAction");
    if ([self.delegate respondsToSelector:@selector(nextActionInViewController:)])
    {
        [self.delegate nextActionInViewController:self];
    }
    else
        NSLog(@"Bad delegate for UsersRepositoriesViewController!!!!");
}
@end
