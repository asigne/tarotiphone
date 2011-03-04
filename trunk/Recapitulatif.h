//
//  Recapitulatif.h
//  TarotIphone
//
//  Created by Aurélien SIGNE on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import <UIKit/UIKit.h>
#import "TarotIphoneAppDelegate.h"

@class TarotIphoneAppDelegate;
@class SQLManager;


@interface Recapitulatif : UIViewController {
	UILabel *preneur;
	UILabel *lAppele, *appele;
	UILabel *contrat;
	UILabel *bouts;
	UILabel *score;
	UILabel *chelemA;
	UILabel *chelemR;
	UILabel *poignee;
	UILabel *petit;
	
	TarotIphoneAppDelegate *app;
	SQLManager *manager;
}

@property (nonatomic,retain) IBOutlet UILabel *preneur, *lAppele, *appele, *contrat, *bouts, *score, *chelemA, *chelemR, *poignee, *petit;
@property (nonatomic, retain) TarotIphoneAppDelegate *app;
@property (nonatomic, retain) SQLManager *manager;

- (void) afficherScore:(id)sender;
	//-(void) revenirParametre:(id)sender;


@end
