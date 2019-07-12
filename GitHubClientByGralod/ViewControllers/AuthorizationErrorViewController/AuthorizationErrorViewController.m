//
//  AuthorizationErrorViewController.m
//  GitHubClientByGralod
//
//  Created by 1 on 07/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import "AuthorizationErrorViewController.h"

@interface AuthorizationErrorViewController ()
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
- (IBAction)ReauthorizationButtonTouchUpInside:(id)sender;
- (IBAction)ReenterAuthorizationDataButtonTouchUpInside:(id)sender;

@end

@implementation AuthorizationErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDescriptionLabel];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateViewControllersData)
                                                 name:@"setNeedsUpdateViewControllersData"
                                               object:nil];
}
- (void) updateViewControllersData
{
    
}

- (void)setupDescriptionLabel
{
    if([self.delegate respondsToSelector:@selector(getContentTextForLabel:inViewController:)])
    {
        NSString *contentTextForDescriptionLabel = [self.delegate getContentTextForLabel:self.descriptionLabel
                                                                        inViewController:self];
        [self.descriptionLabel setText:contentTextForDescriptionLabel];
    }
    else
        NSLog(@"Bad delegate for AuthorizationErrorViewController!!!!");
}

- (IBAction)ReauthorizationButtonTouchUpInside:(id)sender
{
    NSLog(@"ReauthorizationButtonTouchUpInside");
    if([self.delegate respondsToSelector:@selector(reauthorizationActionInViewController:)])
        [self.delegate reauthorizationActionInViewController:self];
    else
        NSLog(@"AuthorizationViewController delegate is wrong!!");
}

- (IBAction)ReenterAuthorizationDataButtonTouchUpInside:(id)sender
{
    NSLog(@"ReenterAuthorizationData");
    if([self.delegate respondsToSelector:@selector(reenterAuthorizationDataActionInViewController:)])
        [self.delegate reenterAuthorizationDataActionInViewController:self];
    else
        NSLog(@"AuthorizationViewController delegate is wrong!!");
}
@end
