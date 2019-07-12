//
//  EnterAuthorizationDataViewController.m
//  GitHubClientByGralod
//
//  Created by 1 on 06/07/2019.
//  Copyright © 2019 OdinokovG. All rights reserved.
//

#import "EnterAuthorizationDataViewController.h"

@interface EnterAuthorizationDataViewController ()
@property (weak, nonatomic) IBOutlet UITextField *loginTextField_;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField_;
@property (weak, nonatomic) IBOutlet UIButton *enterButton;
- (IBAction)enterButtonTouchUpInside:(id)sender;
- (IBAction)loginTextFieldNextButtonAction:(id)sender;
- (IBAction)passwordTextFieldGoButtonAction:(id)sender;

@end

@implementation EnterAuthorizationDataViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateViewControllersData)
                                                 name:@"setNeedsUpdateViewControllersData"
                                               object:nil];
}
- (void) updateViewControllersData
{
    
}

- (IBAction)enterButtonTouchUpInside:(id)sender
{
    NSLog(@"enterButtonTouchUpInside");
    
    [self dataDidEnterAction];
}

- (IBAction)loginTextFieldNextButtonAction:(id)sender
{
    NSLog(@"loginTextFieldNextButtonAction");
    [_loginTextField_ resignFirstResponder];
    [_passwordTextField_ becomeFirstResponder];
}

- (IBAction)passwordTextFieldGoButtonAction:(id)sender
{
    [_passwordTextField_ resignFirstResponder];
    [self dataDidEnterAction];
}

-(void)dataDidEnterAction
{
    NSString *login = _loginTextField_.text;
    NSString *password = _passwordTextField_.text;
    NSLog(@"login: %@, password: %@", login, password);
    
    NSDictionary *outDictionary = @{
                                    @"login" : login,
                                    @"password" : password,
                                    };
    
    if([self.delegate respondsToSelector:@selector(data:didEnterActionInViewController:)])
       [self.delegate data:outDictionary didEnterActionInViewController:self];
    else
        NSLog(@"AuthorizationViewController delegate is wrong!!");
}

@end
