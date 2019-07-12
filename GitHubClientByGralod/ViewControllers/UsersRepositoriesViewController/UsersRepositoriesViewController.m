//
//  UsersRepositoriesViewController.m
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import "UsersRepositoriesViewController.h"

@interface UsersRepositoriesViewController ()<UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *descriptionImageView;
- (IBAction)reloadDataButtonTouchUpInsideAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *reloadDataButton;
- (IBAction)exitButtonTouchUpInsideAction:(id)sender;

@end

@implementation UsersRepositoriesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setDelegate:self.delegate];
    [self.tableView setDataSource:self.delegate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self setupDescriptionLabel];
        [self setupDescriptionImage];
    });
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateViewControllersData)
                                                 name:@"setNeedsUpdateViewControllersData"
                                               object:nil];
    [self updateViewControllersData];
}

- (void) updateViewControllersData
{
    NSLog(@"UsersRepositoriesViewController_updateViewControllersData");
    if([self.delegate respondsToSelector:@selector(getBackgroundImageForButton:inViewController:)])
    {
        [self.reloadDataButton setImage:[self.delegate getBackgroundImageForButton:self.reloadDataButton
                                                                  inViewController:self]
                               forState:UIControlStateNormal];
        [self.tableView reloadData];
    }
    else
        NSLog(@"Bad delegate for UsersRepositoriesViewController!!!!");
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
- (void)setupDescriptionImage
{
//    descriptionImageView
    if([self.delegate respondsToSelector:@selector(getImageForImageView:inViewController:)])
    {
        UIImage *contentImageForDescriptionImageView =
        [self.delegate getImageForImageView:self.descriptionImageView
                           inViewController:self];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"setupDescriptionImage");
            [self.descriptionImageView setImage:contentImageForDescriptionImageView];
            //needless, but for shure
            [self.descriptionImageView setNeedsDisplay];
        });
    }
    else
        NSLog(@"Bad delegate for UsersRepositoriesViewController!!!!");
}

- (IBAction)reloadDataButtonTouchUpInsideAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(getImageForImageView:inViewController:)])
        [self.delegate reloadDataActionInViewController:self];
    else
        NSLog(@"Bad delegate for UsersRepositoriesViewController!!!!");
}
- (IBAction)exitButtonTouchUpInsideAction:(id)sender
{
    NSLog(@"exitButtonTouchUpInsideAction");
    
    NSString *alertTitle = @"Выход";
    NSString *alertMessage = @"Вы уверены, что хотите выйти из системы?";
    
    UIAlertController *exitWarningAlert = [UIAlertController
                                           alertControllerWithTitle:alertTitle
                                           message:alertMessage
                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *positiveButton = [UIAlertAction actionWithTitle:@"Да"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
    {
        NSLog(@"exit susses");
        if([self.delegate respondsToSelector:@selector(exitActionInViewController:)])
            [self.delegate exitActionInViewController:self];
        else
            NSLog(@"Bad delegate for UsersRepositoriesViewController!!!!");
    }];
    
    UIAlertAction *negativeButton = [UIAlertAction actionWithTitle:@"Нет"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction * action)
                                     {
                                         NSLog(@"exit error");
                                     }];
    [exitWarningAlert addAction:positiveButton];
    [exitWarningAlert addAction:negativeButton];
    
    [self presentViewController:exitWarningAlert animated:true completion:nil];
}
@end
