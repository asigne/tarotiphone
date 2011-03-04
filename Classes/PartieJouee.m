//
//  PartieJouee.m
//  TarotIpad
//
//  Created by Aurélien SIGNE on 02/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PartieJouee.h"


@implementation PartieJouee
@synthesize idPartie;
@synthesize preneurPartie;
@synthesize appelePartie;
@synthesize contratPartie;
@synthesize poigneePartie;
@synthesize chelemAPartie;
@synthesize boutsPartie;
@synthesize petitPartie;
@synthesize chelemRPartie;
@synthesize scorePartie;



-(id)initWithId:(NSInteger)i preneur:(NSString *)p appele:(NSString *)a contrat:(NSString *)c poignee:(NSString *)po
			 chelemA:(NSString *)chA bouts:(NSString *)b petit:(NSString *)pe chelemR:(NSString *)chR score:(NSInteger) s{
	idPartie=i;
	preneurPartie=p;
	appelePartie=a;
	contratPartie=c;
	poigneePartie=po;
	chelemAPartie=chA;
	boutsPartie=b;
	petitPartie=pe;
	chelemRPartie=chR;
	scorePartie=s;
    return self;
}
@end
