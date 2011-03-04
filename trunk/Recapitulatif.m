//
//  Recapitulatif.m
//  TarotIphone
//
//  Created by Aurélien SIGNE on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.

#import "Recapitulatif.h"

@implementation Recapitulatif

@synthesize preneur, lAppele, appele, contrat, bouts, score, chelemA, chelemR, poignee, petit;
@synthesize app;
@synthesize manager;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title = @"Récaputilatif";
	app = (TarotIphoneAppDelegate*)[[UIApplication sharedApplication] delegate];
	manager = [[SQLManager alloc] initDatabase];
	
	preneur.text = [manager getNomJoueur:[[app partieEnCours] preneur]]; 
	if([manager getNbLignes:@"JOUEUR"] == 4){
		lAppele.hidden=YES;
		appele.hidden=YES;
	}
	else if([manager getNbLignes:@"JOUEUR"] == 5){
		appele.text = [manager getNomJoueur:[[app partieEnCours] appele]];
	}
	contrat.text = [manager getLibelle:@"CONTRAT":[[app partieEnCours] contrat]];
	bouts.text = [manager getLibelle:@"BOUTS":[[app partieEnCours] bouts]];
	score.text = [NSString stringWithFormat:@"%d",[[app partieEnCours] score]];
	chelemA.text = [manager getLibelle:@"CHELEM":[[app partieEnCours] chelemA]];
	chelemR.text = [manager getLibelle:@"OUINON":[[app partieEnCours] chelemR]];
	poignee.text = [manager getLibelle:@"POIGNEE":[[app partieEnCours] poignee]];
	petit.text = [manager getLibelle:@"PETIT":[[app partieEnCours] petit]];
	
    [super viewDidLoad];
}

- (void) afficherScore:(id)sender{
	[app setPartieEnCoursTerminee:YES];
	if([manager getNbLignes:@"JOUEUR"] == 4){
		[manager nouvellePartie:[[app partieEnCours] preneur] 
							   :0 :[[app partieEnCours] contrat] 
							   :[[app partieEnCours] poignee] :[[app partieEnCours] petit]
							   :[[app partieEnCours] chelemA] :[[app partieEnCours] chelemR]
							   :[[app partieEnCours] score] :[[app partieEnCours] bouts]];
	}
	else if([manager getNbLignes:@"JOUEUR"] == 5){
		[manager nouvellePartie:[[app partieEnCours] preneur] 
							   :[[app partieEnCours] appele] :[[app partieEnCours] contrat] 
							   :[[app partieEnCours] poignee] :[[app partieEnCours] petit]
							   :[[app partieEnCours] chelemA] :[[app partieEnCours] chelemR]
							   :[[app partieEnCours] score] :[[app partieEnCours] bouts]];		}
	
		//mise a jour des scores de chaque joueur
	[self miseAJourScores:[manager getNbLignes:@"JOUEUR"]:[[app partieEnCours] scoreTotalPartie]];
	
	
	AffichageScores *affichageScores = [[AffichageScores alloc] init];//WithNibName:@"affichageScores" bundle:nil];
	[self.navigationController pushViewController:affichageScores animated:YES];
	[affichageScores release];
}

-(void) miseAJourScores:(NSInteger)nbJoueurs:(NSInteger)scoreTotal{
	NSInteger i;
	NSInteger nbJoueursPartie = [manager getNbLignes:@"JOUEUR"];
	if (nbJoueursPartie == 4) {
		for (i=0; i<nbJoueursPartie; i++) {
			if(i == [[app partieEnCours] preneur]){
					//preneur
				[manager setScoreJoueur:(scoreTotal*3):i];
			}
			else{
					//joueurs de la défense
				[manager setScoreJoueur:(-scoreTotal):i];
				
			}
		}
	}
	else if (nbJoueursPartie ==5){
		for (i=0; i<nbJoueursPartie; i++) {
			if(i == [[app partieEnCours] preneur]){
				if(i == [[app partieEnCours] appele]){
						//preneur et appelé
					[manager setScoreJoueur:(scoreTotal*4):i];
				}
				else{
						//preneur seul
					[manager setScoreJoueur:(scoreTotal*2):i];
					
				}
			}
			else if(i == [[app partieEnCours] appele]){
					//appele
				[manager setScoreJoueur:scoreTotal:i];
				
			}
			else{
					//joueurs de la défense
				[manager setScoreJoueur:(-scoreTotal):i];
			}
		}
	}
}

- (void)didReceiveMemoryWarning {
		// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
		// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
		// Release any retained subviews of the main view.
		// e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}


@end
