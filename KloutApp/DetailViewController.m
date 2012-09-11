//
//  DetailViewController.m
//  KloutApp
//
//  Created by Kevin Malek on 9/10/12.
//  Copyright (c) 2012 Kevin Malek. All rights reserved.
//

#import "DetailViewController.h"
#import "UserData.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	
	// Set the userName property to be the twitter username

	[userNameLabel setText:[self userName]];
	[self setTitle:@"Details"];
	//If getKloutScore returns a value, meaning it could grab a value from the web, set ui text label to that value, else set ui label to an error
	NSNumber *ks = [self getKloutScore];
	if (ks)
	{
		[kloutScore setText:[ks stringValue]];
	}
	else
	{
		NSLog(@"Kloutscore doesnt exist!");
		[kloutScore setText:@"No score found!"];
		//Set kloutscore on screen to be an error
	}
	
}

- (void)viewDidUnload
{
	userNameLabel = nil;
	kloutScore = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSNumber *)getKloutScore
{
	NSLog(@"Getting Klout Score!");
	
	//Inserts the username entered into the url used to get kloutScore
	NSString *str = [NSString stringWithFormat:@"http://api.klout.com/1/klout.json?users=%@&key=caf5752gwrh94ahu4yau76cx",[self userName]];
	NSURL *url = [NSURL URLWithString:str];
	NSData *kloutURL = [NSData dataWithContentsOfURL:url];
	
	//Is the url valid? If so, continue...
	if (kloutURL)
	{
		NSError *error;
		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:kloutURL options:0 error:&error];
		
		//Does the kloutAPI link get parsed correctly? If so, continue...
		if (json)
		{
			NSDictionary *users = [json objectForKey:@"users"];
			NSNumber *key = [[users valueForKey:@"kscore"] objectAtIndex:0];
			
			NSLog(@"Kloutscore %@", key);
			return key;
		}
		//kloutAPI link not parsed correctly? Return nil
		else
		{
			NSLog(@"JSON Parsing didnt work!");
			return nil;
		}
	}
	//Is the kloutURL invalid? If so, return nil;
	else
	{
		NSLog(@"klout URL API doesnt exist!");
		return nil;
	}

	return nil;
}

- (IBAction)clickedTopics:(id)sender
{
	NSString *str = [NSString stringWithFormat:@"http://api.klout.com/1/users/topics.json?users=%@&key=caf5752gwrh94ahu4yau76cx", [self userName]];
	NSURL *url = [NSURL URLWithString:str];
	NSData *urlContents = [NSData dataWithContentsOfURL:url];
	//Is the URL valid? If so, continue...
	if (urlContents)
	{
		NSError *error;
		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlContents options:0 error:&error];
		
		//Does the kloutAPI link get parsed correctly? If so, continue...
		if (json)
		{
			NSDictionary *users = [json objectForKey:@"users"];
			NSArray *topics = [[users valueForKey:@"topics"] objectAtIndex:0];
			NSLog(@"Topics: \n%@ \nTopics Count: %d", topics, [topics count]);
			
			//Initialize the tableview where all the topics will be
			buttonTableView = [[ListViewController alloc] initWithListOfItems:topics];
			
			//If we're using an iPad, use the UIPopovercontroller, otherwise, use the navigation controller
			if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
			{
				 buttonPopover = [[UIPopoverController alloc] initWithContentViewController:buttonTableView];
				[buttonPopover setDelegate:self];
				
				UIButton *tappedbutton = (UIButton *) sender;
				
				[buttonPopover setPopoverContentSize:CGSizeMake(320, 480) animated:YES];
				//CGRect size = [[buttonTableView view] frame];
				[buttonPopover presentPopoverFromRect:[tappedbutton frame] inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
			}
			//iPhone uses navigationController instead of UIPopovercontroller.
			else
			{
				[[self navigationController] pushViewController:buttonTableView animated:YES];

			}
		}
		//kloutAPI link not parsed correctly?
		else
		{
			NSLog(@"JSON Parsing didnt work!");
		}

	}
	//Is the URL invalid?
	else
	{
		NSLog(@"klout URL API doesnt exist!");
	}
	
}

- (IBAction)clickedInfluencerOf:(id)sender
{
	NSString *str = [NSString stringWithFormat:@"http://api.klout.com/1/soi/influencer_of.json?users=%@&key=caf5752gwrh94ahu4yau76cx", [self userName]];
	NSURL *url = [NSURL URLWithString:str];
	NSData *urlContents = [NSData dataWithContentsOfURL:url];

	//Is the URL valid? If so, continue...
	if (urlContents)
	{
		NSError *error;
		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlContents options:0 error:&error];
		
		//Does the kloutAPI link get parsed correctly? If so, continue...
		if (json)
		{
			
			NSArray *influencersBigList = [[json objectForKey:@"users"] valueForKey:@"influencers"];
//			NSLog(@"InfluencersBigList %@", influencersBigList);
			
			NSArray *list = [influencersBigList objectAtIndex:0];
//			NSLog(@"List %@", list);
			
			NSArray *twitter = [list mutableArrayValueForKey:@"twitter_screen_name"];
//			NSLog(@"twitter %@", twitter);

			
			//			NSArray *topics = [[users valueForKey:@"topics"] objectAtIndex:0];
			//		NSLog(@"Topics: \n%@ \nTopics Count: %d", topics, [topics count]);
			
			//Initialize the tableview where all the topics will be
			buttonTableView = [[ListViewController alloc] initWithListOfItems:twitter];
			
			//If we're using an iPad, use the UIPopovercontroller, otherwise, use the navigation controller
			if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
			{
				buttonPopover = [[UIPopoverController alloc] initWithContentViewController:buttonTableView];
				[buttonPopover setDelegate:self];
				
				UIButton *tappedbutton = (UIButton *) sender;
				
				[buttonPopover setPopoverContentSize:CGSizeMake(320, 480) animated:YES];
				//CGRect size = [[buttonTableView view] frame];
				[buttonPopover presentPopoverFromRect:[tappedbutton frame] inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
			}
			//iPhone uses navigationController instead of UIPopovercontroller.
			else
			{
				[[self navigationController] pushViewController:buttonTableView animated:YES];
				
			}
		}
		//kloutAPI link not parsed correctly?
		else
		{
			NSLog(@"JSON Parsing didnt work!");
		}
		
	}
	//Is the URL invalid?
	else
	{
		NSLog(@"klout URL API doesnt exist!");
	}
}

- (IBAction)influencedBy:(id)sender
{
	NSString *str = [NSString stringWithFormat:@"http://api.klout.com/1/soi/influenced_by.json?users=%@&key=caf5752gwrh94ahu4yau76cx", [self userName]];
	NSURL *url = [NSURL URLWithString:str];
	NSData *urlContents = [NSData dataWithContentsOfURL:url];
	
	//Is the URL valid? If so, continue...
	if (urlContents)
	{
		NSError *error;
		NSDictionary *json = [NSJSONSerialization JSONObjectWithData:urlContents options:0 error:&error];
		
		//Does the kloutAPI link get parsed correctly? If so, continue...
		if (json)
		{
			
			NSArray *influencersBigList = [[json objectForKey:@"users"] valueForKey:@"influencers"];
			//			NSLog(@"InfluencersBigList %@", influencersBigList);
			
			NSArray *list = [influencersBigList objectAtIndex:0];
			//			NSLog(@"List %@", list);
			
			NSArray *twitter = [list mutableArrayValueForKey:@"twitter_screen_name"];
			//			NSLog(@"twitter %@", twitter);
			
			
			//			NSArray *topics = [[users valueForKey:@"topics"] objectAtIndex:0];
			//		NSLog(@"Topics: \n%@ \nTopics Count: %d", topics, [topics count]);
			
			//Initialize the tableview where all the topics will be
			buttonTableView = [[ListViewController alloc] initWithListOfItems:twitter];
			
			//If we're using an iPad, use the UIPopovercontroller, otherwise, use the navigation controller
			if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
			{
				buttonPopover = [[UIPopoverController alloc] initWithContentViewController:buttonTableView];
				[buttonPopover setDelegate:self];
				
				UIButton *tappedbutton = (UIButton *) sender;
				
				[buttonPopover setPopoverContentSize:CGSizeMake(320, 480) animated:YES];
				//CGRect size = [[buttonTableView view] frame];
				[buttonPopover presentPopoverFromRect:[tappedbutton frame] inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
			}
			//iPhone uses navigationController instead of UIPopovercontroller.
			else
			{
				[[self navigationController] pushViewController:buttonTableView animated:YES];
				
			}
		}
		//kloutAPI link not parsed correctly?
		else
		{
			NSLog(@"JSON Parsing didnt work!");
		}
		
	}
	//Is the URL invalid?
	else
	{
		NSLog(@"klout URL API doesnt exist!");
	}
}


@end
