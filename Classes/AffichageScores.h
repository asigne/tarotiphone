//
//  AffichageScores.h
//  TarotIphone
//
//  Created by Aurélien SIGNE on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TarotIphoneAppDelegate.h"

@class TarotIphoneAppDelegate;
@class SQLManager;

@interface AffichageScores : UIViewController <UITableViewDataSource, UITableViewDataSource> {	
	TarotIphoneAppDelegate *app;
	SQLManager *manager;
	
	UITableView *tableScores;
	UIButton *nouvellePartie;
}

@property (nonatomic, retain) TarotIphoneAppDelegate *app;
@property (nonatomic, retain) SQLManager *manager;
@property (nonatomic, retain) IBOutlet UITableView *tableScores;
@property (nonatomic, retain) IBOutlet UIButton *nouvellePartie;

@end
