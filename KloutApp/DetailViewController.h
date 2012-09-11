//
//  DetailViewController.h
//  KloutApp
//
//  Created by Kevin Malek on 9/10/12.
//  Copyright (c) 2012 Kevin Malek. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController.h"


@interface DetailViewController : UIViewController <UIPopoverControllerDelegate>
{
	__weak IBOutlet UILabel *userNameLabel;
	__weak IBOutlet UILabel *kloutScore;
	
	UIPopoverController *buttonPopover;
	ListViewController *buttonTableView;
	
}
@property (nonatomic, strong) NSString *userName;

-(NSNumber *) getKloutScore;
- (IBAction)clickedTopics:(id)sender;
- (IBAction)clickedInfluencerOf:(id)sender;
- (IBAction)influencedBy:(id)sender;

@end
