//
//  SQLManager.h
//  SQlite
//
//  Created by Jérémy Lagrue on 13/07/10.
//  Copyright 2010 iPuP. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>	// Import du framework sqlite
#import "Score.h"
#import "PartieJouee.h"

@interface SQLManager : NSObject {
    // Variables de la Base de Données
    NSString *databaseName;
    NSString *databasePath;
	NSMutableArray *scores;
	NSMutableArray *partiesJouees;
}

@property (nonatomic, retain) NSMutableArray *scores;
@property (nonatomic, retain) NSMutableArray *partiesJouees;

- (id) initDatabase;
-(void) affichageScoreDepuisLaBase;
-(void) affichagePartieJoueeDepuisLaBase;

-(void) nouvellePartie:(NSInteger)preneur:(NSInteger)appele:(NSInteger)contrat:(NSInteger)
			   poignee:(NSInteger)petit:(NSInteger)chelemA:(bool)chelemR:(NSInteger)score:(NSInteger)nbBouts;

-(void) ajouterJoueur:(NSString*)nom:(NSInteger)score;

-(NSString*) getNomJoueur:(NSInteger)idJoueur;
-(void) setNomJoueur:(NSString *)nom:(NSInteger)idJoueur;

-(NSInteger) getScoreJoueur:(NSInteger)idJoueur;
-(void) setScoreJoueur:(NSInteger)score:(NSInteger)idJoueur;

-(NSInteger) getNbLignes:(NSString *)table;
-(NSString*) getLibelle:(NSString*)table:(NSInteger)idLibelle;

-(void) viderBase;

@end

