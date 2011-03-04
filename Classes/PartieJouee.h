//
//  PartieJouee.h
//  TarotIpad
//
//  Created by Aurélien SIGNE on 02/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PartieJouee : NSObject {
	NSInteger idPartie;
    NSString *preneurPartie;
	NSString *appelePartie;
	NSString *contratPartie;
	NSString *poigneePartie;
	NSString *chelemAPartie;
	NSString *boutsPartie;
	NSString *petitPartie;
	NSString *chelemRPartie;
	NSInteger scorePartie;
}

@property (nonatomic, assign) NSInteger idPartie;
@property (nonatomic, retain) NSString *preneurPartie;
@property (nonatomic, retain) NSString *appelePartie;
@property (nonatomic, retain) NSString *contratPartie;
@property (nonatomic, retain) NSString *poigneePartie;
@property (nonatomic, retain) NSString *chelemAPartie;
@property (nonatomic, retain) NSString *boutsPartie;
@property (nonatomic, retain) NSString *petitPartie;
@property (nonatomic, retain) NSString *chelemRPartie;
@property (nonatomic, assign) NSInteger scorePartie;


-(id)initWithId:(NSInteger)i preneur:(NSString *)p appele:(NSString *)a contrat:(NSString *)c poignee:(NSString *)po
			 chelemA:(NSString *)chA bouts:(NSString *)b petit:(NSString *)pe chelemR:(NSString *)chR score:(NSInteger) s;
@end
