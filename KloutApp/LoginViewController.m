//
//  LoginViewController.m
//  KloutApp
//
//  Created by Kevin Malek on 9/10/12.
//  Copyright (c) 2012 Kevin Malek. All rights reserved.
//

#import "LoginViewController.h"
#import "UserData.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize twitterUserName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
	{
		// Custom initialization
		_userData = [[UserData alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:@"KloutScout"];
}

- (void)viewDidUnload
{
    twitterUserName = nil;
	twitterTextField = nil;
	[self setTwitterUserName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)getScore:(id)sender
{
	
	[[self userData] setUserName:[twitterTextField text]];
	
	DetailViewController *dvc = [[DetailViewController alloc] init];

//	[dvc setUserName:[twitterTextField text]];
	[dvc setUserName:[[self userData] userName]];
	
//	NSString *str = [NSString stringWithFormat:@"http://api.twitter.com/1/users/show.json?screen_name=%@", [twitterTextField text]];
	NSString *str = [NSString stringWithFormat:@"http://api.twitter.com/1/users/show.json?screen_name=%@", [[self userData] userName]];
	
	NSURL *url = [NSURL URLWithString:str];
	NSData *urlContents = [NSData dataWithContentsOfURL:url];
	//Is the URL valid? If so, continue...
	if (urlContents)
	{
		[[self navigationController] pushViewController:dvc animated:YES];
	}
	else
	{
		NSLog(@"Invalid TwitterName");
		UIAlertView *twitterError = [[UIAlertView alloc] initWithTitle:@"Bad Username" message:@"This twitter account doesn't exist. Double check that it was typed correctly." delegate:nil cancelButtonTitle:@"Thanks, I'll try again" otherButtonTitles: nil];
		[twitterError show];
	}
	
	
}
@end
