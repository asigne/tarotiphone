    //
	//  Accueil.m
	//  TarotIpad
	//
	//  Created by Aurélien SIGNE on 08/02/11.
	//  Copyright 2011 __MyCompanyName__. All rights reserved.
	//

#import "Accueil.h"


@implementation Accueil
@synthesize segmentedController;
@synthesize j1, j2, j3, j4, j5; 
@synthesize nomJ1, nomJ2, nomJ3, nomJ4, nomJ5;
@synthesize validerNoms;
@synthesize nbJoueurs;
@synthesize manager;

- (void)viewDidLoad {	
	self.title = @"Tarot";
	self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
	
	
	manager = [[SQLManager alloc] initDatabase];
	app = (TarotIpadAppDelegate*)[[UIApplication sharedApplication] delegate];
	[app setNbJoueursPartie:4];
	
		//creation bouton segmentation
	segmentedController.selectedSegmentIndex = 0;
	[segmentedController addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	[segmentedController release]; 
	
		//Voir si on garde les parametres
	[manager viderBase];
    
	[super viewDidLoad];
}

	//action pour changer "d'onglet"
- (IBAction)segmentAction:(id)sender{
	segmentedController = (UISegmentedControl *)sender;
	if(segmentedController.selectedSegmentIndex == 0){
		j5.hidden=YES;
		nomJ5.hidden=YES;
		[app setNbJoueursPartie:4];
	}
	else if(segmentedController.selectedSegmentIndex == 1){
		j5.hidden=NO;
		nomJ5.hidden=NO;
		[app setNbJoueursPartie:5];		
	}
}

- (void) valider:(id)sender{
	NSInteger i;
	if([manager getNbLignes:@"JOUEUR"] == 0){
			//creation des joueurs avec noms et scores par défault
		for (i=0; i<[app nbJoueursPartie]; i++) {
			[manager ajouterJoueur:[NSString stringWithFormat:@"Joueur %d", i+1]:0];
		}
	}
	
		//initialisation des noms
	[manager setNomJoueur:nomJ1.text:0];
	[manager setNomJoueur:nomJ2.text:1];
	[manager setNomJoueur:nomJ3.text:2];
	[manager setNomJoueur:nomJ4.text:3];
	if([app nbJoueursPartie]==5){
		[manager setNomJoueur:nomJ5.text:4];
	}
	
		//cacher le selecteur du nombre de joueurs
	[segmentedController setHidden:YES];
	
	SaisieParametre *saisieParametre = [[SaisieParametre alloc] init];
	[[app navController] pushViewController:saisieParametre animated:YES];
	[saisieParametre release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		// Overriden to allow any orientation.
    return YES;
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
	[manager release];
    [super dealloc];
}


@end
