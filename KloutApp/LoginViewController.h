//
//  LoginViewController.h
//  KloutApp
//
//  Created by Kevin Malek on 9/10/12.
//  Copyright (c) 2012 Kevin Malek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewController.h"
@class UserData;

@interface LoginViewController : UIViewController
{
	__weak IBOutlet UITextField *twitterTextField;

}

@property (nonatomic, copy) NSString *twitterUserName;
@property (nonatomic, strong) UserData *userData;

- (IBAction)getScore:(id)sender;
@end
