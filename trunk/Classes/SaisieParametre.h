//
//  SaisieParametre.h
//  Tarot2
//
//  Created by Aurélien SIGNE on 31/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TarotIphoneAppDelegate.h"
	
@class TarotIphoneAppDelegate;
@class SQLManager;

@interface SaisieParametre : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>{
	UISegmentedControl* segmentedControllerParam;
	UILabel *preneur, *contrat, *poignee, *chelem;
	
	UIPickerView *pickerView1;
	NSMutableArray *joueursArray;
	NSMutableArray *contratsArray;
	
	UIPickerView *pickerView2;
	NSMutableArray *poigneesArray;
	NSMutableArray *chelemsArray;

	UIButton *btnValider;
	
	TarotIphoneAppDelegate *app;
	SQLManager *manager;
}

@property (nonatomic, retain) IBOutlet UILabel *preneur, *contrat, *poignee, *chelem;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControllerParam;
@property (nonatomic, retain) IBOutlet UIPickerView* pickerView1;
@property (nonatomic, retain) IBOutlet UIPickerView* pickerView2;

@property (nonatomic, retain) IBOutlet UIButton* btnValider;
@property (nonatomic, retain) TarotIphoneAppDelegate *app;
@property (nonatomic, retain) SQLManager *manager;


-(void) validerParametres:(id)sender;

@end
