//
//  ListViewController.h
//  KloutApp
//
//  Created by Kevin Malek on 9/10/12.
//  Copyright (c) 2012 Kevin Malek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UITableViewController
{
	NSArray *list;
}


-(id) initWithListOfItems:(NSArray *)items;

@end
