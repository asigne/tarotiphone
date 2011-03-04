//
//  SQLManager.m
//  SQlite
//
//  Created by Jérémy Lagrue on 13/07/10.
//  Copyright 2010 iPuP. All rights reserved.
//
#import "SQLManager.h"

@implementation SQLManager
@synthesize scores;
@synthesize partiesJouees;


-(id) initDatabase {
	if(self = [super init]) {
		//On définit le nom de la base de données
		databaseName = @"TarotIphone.sql";
		
		// On récupère le chemin
		NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDir = [documentPaths objectAtIndex:0];
		databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
		
		// On vérifie si la BDD a déjà été sauvegardée dans l'iPhone de l'utilisateur
		BOOL success;
		
		// Crée un objet FileManagerCreate qui va servir à vérifer le statut
		// de la base de données et de la copier si nécessaire
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		// Vérifie si la BDD a déjà été créée  dans les fichiers system de l'utilisateur
		success = [fileManager fileExistsAtPath:databasePath];
		
		// Si la BDD existe déjà on ne fait pas la suite
		if(!success){
			
			// Si ce n'est pas le cas alors on copie la BDD de l'application vers les fichiers système de l'utilisateur
			
			// On récupère le chemin vers la BDD dans l'application
			NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
			
			// On copie la BDD de l'application vers le fichier systeme de l'application
			[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
			
			[fileManager release];
		}
		[databasePath retain];
		
	}
    return self;
}

-(NSInteger) getNbLignes:(NSString *)table{
	// Déclaration de l'objet database
    sqlite3 *database;
	NSInteger nbLignes;
	
    // On ouvre la BDD à partir des fichiers système
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        // Préparation de la requête SQL qui va permettre de récupérer les objets score de la BDD
        //en triant les scores dans l'ordre décroissant 
        //const char *sqlStatement = ("select * from JOUEURS where id='%d'",idJoueur);
		
		NSString *sqlStat = [NSString stringWithFormat:@"select count(*) from %@;",table];
		const char *sqlStatement = [sqlStat UTF8String];
		//création d'un objet permettant de connaître le status de l'exécution de la requête
        sqlite3_stmt *compiledStatement;
		
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// On lit les données stockées dans le fichier sql
				nbLignes = sqlite3_column_int(compiledStatement, 0);
			}
		}
	}
	return nbLignes;	
}

-(void) nouvellePartie:(NSInteger)preneur:(NSInteger)appele:(NSInteger)contrat:(NSInteger)
			   poignee:(NSInteger)petit:(NSInteger)chelemA:(bool)chelemR:(NSInteger)score:(NSInteger)nbBouts{
	// Déclaration de l'objet database
    sqlite3 *database;
    // On ouvre la BDD à partir des fichiers système
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
		
		//if(chelemR.on == YES)
		
        // Préparation de la requête SQL qui va permettre d'ajouter un score à la BDD       
        NSString *sqlStat = [NSString stringWithFormat:@"INSERT INTO PARTIE VALUES (NULL, %d, %d, %d, %d, %d, %d, %d, %i, %d);",
							 preneur+1, appele+1, contrat+1, poignee+1, chelemA+1, petit+1, nbBouts+1, chelemR, score];
		NSLog(sqlStat);
		
		//conversion en char *
		const char *sqlStatement = [sqlStat UTF8String];
		//On utilise sqlite3_exec qui permet très simplement d'exécuter une requête sur la BDD
		sqlite3_exec(database, sqlStatement,NULL,NULL,NULL);
    }
    sqlite3_close(database);
}

-(NSString*) getLibelle:(NSString*)table:(NSInteger)idLibelle{
	// Déclaration de l'objet database
    sqlite3 *database;
	NSString *libelle;
	
    // On ouvre la BDD à partir des fichiers système
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        // Préparation de la requête SQL qui va permettre de récupérer les objets score de la BDD
        //en triant les scores dans l'ordre décroissant 
        //const char *sqlStatement = ("select * from JOUEURS where id='%d'",idJoueur);
		
		
		
		NSString *sqlStat = [NSString stringWithFormat:@"select * from %@ WHERE id='%d';",table ,idLibelle+1];
		const char *sqlStatement = [sqlStat UTF8String];
		//création d'un objet permettant de connaître le status de l'exécution de la requête
        sqlite3_stmt *compiledStatement;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
            // On boucle tant que l'on trouve des objets dans la BDD
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// On lit les données stockées dans le fichier sql
				libelle = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
			}
		}
	}
	return libelle;
}

-(void) ajouterJoueur:(NSString*)nom:(NSInteger)score{
	// Déclaration de l'objet database
    sqlite3 *database;
    // On ouvre la BDD à partir des fichiers système
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        // Préparation de la requête SQL qui va permettre d'ajouter un score à la BDD       
        NSString *sqlStat = [NSString stringWithFormat:@"INSERT INTO JOUEUR VALUES (NULL, '%@', %d);", nom, score];
		//conversion en char *
		const char *sqlStatement = [sqlStat UTF8String];
		//On utilise sqlite3_exec qui permet très simplement d'exécuter une requête sur la BDD
		sqlite3_exec(database, sqlStatement,NULL,NULL,NULL);
	}
    sqlite3_close(database);	
}

-(void) viderBase{
	// Déclaration de l'objet database
    sqlite3 *database;
    // On ouvre la BDD à partir des fichiers système
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        // Préparation de la requête SQL qui va permettre d'ajouter un score à la BDD       
        NSString *sqlStat = [NSString stringWithFormat:@"DELETE FROM JOUEUR;"];
		//conversion en char *
		const char *sqlStatement = [sqlStat UTF8String];
		//On utilise sqlite3_exec qui permet très simplement d'exécuter une requête sur la BDD
		sqlite3_exec(database, sqlStatement,NULL,NULL,NULL);
		sqlStat = [NSString stringWithFormat:@"DELETE FROM PARTIE;"];
		//conversion en char *
		sqlStatement = [sqlStat UTF8String];
		//On utilise sqlite3_exec qui permet très simplement d'exécuter une requête sur la BDD
		sqlite3_exec(database, sqlStatement,NULL,NULL,NULL);
    }
    sqlite3_close(database);
}

-(NSString*) getNomJoueur:(NSInteger)idJoueur{
	// Déclaration de l'objet database
    sqlite3 *database;
	NSString *nom;
	
    // On ouvre la BDD à partir des fichiers système
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        // Préparation de la requête SQL qui va permettre de récupérer les objets score de la BDD
        //en triant les scores dans l'ordre décroissant 
        //const char *sqlStatement = ("select * from JOUEURS where id='%d'",idJoueur);
		
		NSString *sqlStat = [NSString stringWithFormat:@"select nom from JOUEUR WHERE id='%d';",idJoueur+1];
		const char *sqlStatement = [sqlStat UTF8String];
		//création d'un objet permettant de connaître le status de l'exécution de la requête
        sqlite3_stmt *compiledStatement;
		
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// On lit les données stockées dans le fichier sql
				nom = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
			}
		}
	}
	return nom;
}

-(void) setNomJoueur:(NSString *)nom:(NSInteger)idJoueur{
	// Déclaration de l'objet database
    sqlite3 *database;
    // On ouvre la BDD à partir des fichiers système
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        // Préparation de la requête SQL qui va permettre d'ajouter un score à la BDD       
        NSString *sqlStat = [NSString stringWithFormat:@"UPDATE JOUEUR SET nom='%@' WHERE id='%d';",nom,idJoueur+1];
		//conversion en char *
		const char *sqlStatement = [sqlStat UTF8String];
		//On utilise sqlite3_exec qui permet très simplement d'exécuter une requête sur la BDD
		sqlite3_exec(database, sqlStatement,NULL,NULL,NULL);
	}
	sqlite3_close(database);
}

-(NSInteger) getScoreJoueur:(NSInteger)idJoueur{
	// Déclaration de l'objet database
    sqlite3 *database;
	NSInteger score;
	
    // On ouvre la BDD à partir des fichiers système
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        // Préparation de la requête SQL qui va permettre de récupérer les objets score de la BDD
        //en triant les scores dans l'ordre décroissant 
        //const char *sqlStatement = ("select * from JOUEURS where id='%d'",idJoueur);
		
		NSString *sqlStat = [NSString stringWithFormat:@"select score from JOUEUR WHERE id=%d;",idJoueur+1];
		const char *sqlStatement = [sqlStat UTF8String];
		//création d'un objet permettant de connaître le status de l'exécution de la requête
        sqlite3_stmt *compiledStatement;
		
        if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// On lit les données stockées dans le fichier sql
				score = sqlite3_column_int(compiledStatement, 0);
			}
		}
	}
	return score;	
}

-(void) setScoreJoueur:(NSInteger)score:(NSInteger)idJoueur{
	NSInteger newScore;
	// Déclaration de l'objet database
    sqlite3 *database;
    // On ouvre la BDD à partir des fichiers système
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        // Préparation de la requête SQL qui va permettre d'ajouter un score à la BDD  
		NSInteger ancienScore=[self getScoreJoueur:idJoueur];
		newScore = score+ancienScore;
		NSString *sqlStat = [NSString stringWithFormat:@"UPDATE JOUEUR SET score=%d WHERE id=%d",newScore,idJoueur+1];
		//conversion en char *
		const char *sqlStatement = [sqlStat UTF8String];
		//On utilise sqlite3_exec qui permet très simplement d'exécuter une requête sur la BDD
		sqlite3_exec(database, sqlStatement,NULL,NULL,NULL);
    }
    sqlite3_close(database);
}

-(void) affichageScoreDepuisLaBase {
	// Déclaration de l'objet database
	sqlite3 *database;
	
	// Initialisation du tableau de score
	if(scores == nil){
		scores = [[NSMutableArray alloc] init];
	}
	else {
		[scores removeAllObjects];
	}
	
	// On ouvre la BDD à partir des fichiers système
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
		// Préparation de la requête SQL qui va permettre de récupérer les objets score de la BDD
		//en triant les scores dans l'ordre décroissant 
		const char *sqlStatement = "select * from JOUEUR ORDER BY score DESC";
		
		//création d'un objet permettant de connaître le status de l'exécution de la requête
		sqlite3_stmt *compiledStatement;
//		NSLog(@"data %@", databasePath);
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// On boucle tant que l'on trouve des objets dans la BDD
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				// On lit les données stockées dans le fichier sql
				// Dans la première colonne on trouve du texte que l'on place dans un NSString
				NSString *nom = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
				// Dans la deuxième colonne on récupère le score dans un NSInteger
				NSInteger points = sqlite3_column_int(compiledStatement, 2);
				
				// On crée un objet Score avec les pramètres récupérés dans la BDD
				Score *score = [[Score alloc] initWithNom:nom points:points prise:0 appele:0];
				
				// On ajoute le score au tableau
				if(![scores containsObject:score])
					[scores addObject:score];
				[score release];
			}
		}
		// On libère le compiledStamenent de la mémoire
		sqlite3_finalize(compiledStatement);
	}
	//On ferme la bdd
	sqlite3_close(database);
}

-(void) affichagePartieJoueeDepuisLaBase{
	// Déclaration de l'objet database
	sqlite3 *database;
	
	// Initialisation du tableau de score
	if(partiesJouees == nil){
		partiesJouees = [[NSMutableArray alloc] init];
	}
	else {
		[partiesJouees removeAllObjects];
	}
	
	// On ouvre la BDD à partir des fichiers système
	if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
		// Préparation de la requête SQL qui va permettre de récupérer les objets score de la BDD
		//en triant les scores dans l'ordre décroissant 
		const char *sqlStatement = "select preneur.nom as preneur, appele.nom as appele, c.libelleContrat, po.libellePoignee, chA.libelleChelem, b.libelleBouts, pe.libellePetit, chR.libelleOuiNon, p.score from PARTIE p, JOUEUR preneur, JOUEUR appele, CONTRAT c, POIGNEE po, CHELEM chA, BOUTS b, PETIT pe, OUINON chR WHERE p.preneur=preneur.id AND p.contrat=c.id AND p.appele = appele.id AND p.poignee = po.id AND p.chelemA = chA.id AND p.nbBouts = b.id AND p.petit = pe.id AND p.chelemR = chR.id;";
		//création d'un objet permettant de connaître le status de l'exécution de la requête
		sqlite3_stmt *compiledStatement;
//		NSLog(@"data %@", databasePath);
		
		NSInteger cptPartie=0;
		
		if(sqlite3_prepare_v2(database, sqlStatement, -1, &compiledStatement, NULL) == SQLITE_OK) {
			// On boucle tant que l'on trouve des objets dans la BDD
			while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
				cptPartie=cptPartie+1;
				NSString *preneur = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 0)];
				NSString *appele = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];				
				NSString *contrat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
				NSString *poignee = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];				
				NSString *chelemA = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
				NSString *bouts = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];				
				NSString *petit = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 6)];
				NSString *chelemR = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 7)];				
				NSInteger score = sqlite3_column_int(compiledStatement, 8);
				
				// On crée un objet Score avec les pramètres récupérés dans la BDD
				PartieJouee *partieJouee = [[PartieJouee alloc] initWithId:cptPartie preneur:preneur appele:appele contrat:contrat
																		poignee:poignee chelemA:chelemA bouts:bouts petit:petit 
																		chelemR:chelemR score:score];
				 
				// On ajoute le score au tableau
				if(![partiesJouees containsObject:partieJouee])
					[partiesJouees insertObject :partieJouee atIndex:0];
				[partieJouee release];
			}
		}
		// On libère le compiledStamenent de la mémoire
		sqlite3_finalize(compiledStatement);
	}
	//On ferme la bdd
	sqlite3_close(database);
}

- (void) dealloc {
	[databasePath release];
	[databaseName release];
	[scores release];
	[super dealloc];
}

@end