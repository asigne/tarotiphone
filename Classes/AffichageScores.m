//
//  AffichageScores.m
//  TarotIphone
//
//  Created by Aurélien SIGNE on 04/03/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AffichageScores.h"


@implementation AffichageScores
@synthesize app;
@synthesize manager;
@synthesize tableScores;
@synthesize nouvellePartie;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	self.title = @"Scores";
	app = (TarotIphoneAppDelegate*)[[UIApplication sharedApplication] delegate];
	manager = [[SQLManager alloc] initDatabase];

	if([app partieEnCoursTerminee] == YES){
			//creation du bouton pour démarrer une nouvelle partie
		UIBarButtonItem *item = [[UIBarButtonItem alloc]   
								 initWithTitle:@"Nouvelle Partie" style:UIBarButtonItemStyleBordered
								 target:self   
								 action:@selector(nouvellePartie:)];  
		self.navigationItem.leftBarButtonItem = item; 
		[item release];
		nouvellePartie.hidden = NO;
	}
	else{
		nouvellePartie.hidden = YES;
	}
	
		//tableScores = [[UITableView alloc] initWithFrame:CGRectZero];
	tableScores = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
	[tableScores setBackgroundColor:[UIColor blackColor]];
	CGRect tableRectScore = CGRectMake(0.0, 20.0, 320.0, 230.0);
	tableScores.frame = tableRectScore;
	tableScores.dataSource = self;
	[self.view addSubview:tableScores];
	[tableScores release];
	
	
	[self.tableScores reloadData];
	
    [super viewDidLoad];
}

-(void) nouvellePartie:(id)sender{
	//retour à la vue des paramètres
	NSArray *allControleurs = [self.navigationController viewControllers];
	[self.navigationController popToViewController:[allControleurs objectAtIndex:1] animated:YES];
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

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	// Return the number of sections.
	NSInteger nbSections=0;
    if(tableView == tableScores){
		nbSections = 1;
	}
	return nbSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		// Return the number of rows in the section.
	NSInteger nbLignesParSection = 0;
	if(tableView == tableScores){
		nbLignesParSection = [app nbJoueursPartie];
	}
	return nbLignesParSection;
}

	// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    if(tableView == tableScores){
		[manager affichageScoreDepuisLaBase];
		Score *scoreTmp = [manager.scores objectAtIndex:indexPath.row];
		cell.textLabel.text =  scoreTmp.nom;
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", scoreTmp.points];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
	return cell;
}

@end
