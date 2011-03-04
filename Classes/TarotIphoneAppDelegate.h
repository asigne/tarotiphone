//
//  TarotIphoneAppDelegate.h
//  TarotIphone
//
//  Created by Aurélien SIGNE on 03/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Accueil.h"
#import "SaisieParametre.h"
#import "SaisieResultat.h"
#import "Recapitulatif.h"
	//#import "Partie.h"
#import "SQLManager.h"
#import "Score.h"
#import "PartieJouee.h"
#import "PartieEnCours.h"

@interface TarotIphoneAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow *window;
	UINavigationController *navController;	
	NSInteger nbJoueursPartie;
		//NSInteger nbParties;	
	PartieEnCours *partieEnCours;
}

@property (nonatomic,retain) IBOutlet UIWindow *window;
@property (nonatomic,retain) IBOutlet PartieEnCours *partieEnCours;
@property (nonatomic,retain) IBOutlet UINavigationController *navController;
@property (nonatomic,assign) IBOutlet NSInteger nbJoueursPartie;
	//@property (nonatomic,assign) IBOutlet NSInteger nbParties;


@end


