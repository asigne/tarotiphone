//
//  Score.h
//  SQlite
//
//  Created by Jérémy Lagrue on 13/07/10.
//  Copyright 2010 iPuP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Score : NSObject {
    NSString *nom;
	NSInteger points;
	NSInteger prise;
	NSInteger appele;
}

@property (nonatomic, retain) NSString *nom;
@property (nonatomic, assign) NSInteger points;
@property (nonatomic, assign) NSInteger prise;
@property (nonatomic, assign) NSInteger appele;


-(id)initWithNom:(NSString *)n points:(NSInteger)p prise:(NSInteger)r appele:(NSInteger)a;

@end

