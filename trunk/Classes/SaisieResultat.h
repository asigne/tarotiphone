//
//  SaisieResultat.h
//  Tarot2
//
//  Created by Aurélien SIGNE on 01/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TarotIphoneAppDelegate.h"

@class TarotIphoneAppDelegate;
@class SQLManager;

@interface SaisieResultat : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>{
	UITextField *score;
	UIPickerView *monPickerView;
	NSMutableArray *boutsArray;
	NSMutableArray *petitArray;
	NSMutableArray *joueursArray;
	UISwitch *switchChelem;
	UIButton *validerResultat;
	UIButton *validerScore;
	UILabel *appele, *petitJ4, *petitJ5;

	TarotIphoneAppDelegate *app;
	SQLManager *manager;
}

@property(nonatomic, retain) IBOutlet UITextField *score;
@property(nonatomic, retain) IBOutlet UIPickerView *monPickerView;
@property(nonatomic, retain) IBOutlet UISwitch *switchChelem;
@property(nonatomic, retain) IBOutlet UIButton *validerResultat;
@property(nonatomic, retain) IBOutlet UIButton *validerScore;
@property(nonatomic, retain) IBOutlet NSMutableArray *boutsArray, *petitArray, *joueursArray;
@property(nonatomic, retain) IBOutlet UILabel *appele, *petitJ4, *petitJ5;
@property (nonatomic, retain) TarotIphoneAppDelegate *app;
@property (nonatomic, retain) SQLManager *manager;

-(void) validerResultat:(id)sender;
-(void) afficherBtnValiderScore:(id)sender;
-(void) retirerClavier:(id)sender;
-(void) afficherScore;

@end
