//
//  PartieEnCours.h
//  TarotIphone
//
//  Created by Aurélien SIGNE on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PartieEnCours : NSObject {
	NSInteger idPartie;
    NSInteger preneur;
	NSInteger appele;
	NSInteger contrat;
	NSInteger poignee;
	NSInteger chelemA;
	NSInteger bouts;
	NSInteger petit;
	NSInteger chelemR;
	NSInteger score;
	NSInteger scoreTotalPartie;
}

@property (nonatomic, assign) NSInteger idPartie;
@property (nonatomic, assign) NSInteger preneur;
@property (nonatomic, assign) NSInteger appele;
@property (nonatomic, assign) NSInteger contrat;
@property (nonatomic, assign) NSInteger poignee;
@property (nonatomic, assign) NSInteger chelemA;
@property (nonatomic, assign) NSInteger bouts;
@property (nonatomic, assign) NSInteger petit;
@property (nonatomic, assign) NSInteger chelemR;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger scoreTotalPartie;

@end
