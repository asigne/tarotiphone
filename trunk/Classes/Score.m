//
//  Score.m
//  SQlite
//
//  Created by Jérémy Lagrue on 13/07/10.
//  Copyright 2010 iPuP. All rights reserved.
//

#import "Score.h"
@implementation Score
@synthesize nom, points, appele, prise;

-(id)initWithNom:(NSString *)n points:(NSInteger)p prise:(NSInteger)r appele:(NSInteger)a{
	nom=n;
	points=p;
	prise=r;
	appele=a;
    return self;
}

@end

