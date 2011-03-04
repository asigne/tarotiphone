    //
	//  Accueil.m
	//  TarotIpad
	//
	//  Created by Aurélien SIGNE on 08/02/11.
	//  Copyright 2011 __MyCompanyName__. All rights reserved.
	//

#define SCROLLVIEW_CONTENT_HEIGHT 460
#define SCROLLVIEW_CONTENT_WIDTH  320


#import "Accueil.h"


@implementation Accueil
@synthesize segmentedController;
@synthesize scrollView;
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
		self.j5.hidden=NO;
		self.nomJ5.hidden=NO;
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


- (void) viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name: UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (keyboardDidHide:) name: UIKeyboardDidHideNotification object:nil];
	
	scrollView.contentSize = CGSizeMake(SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
	displayKeyboard = NO;
}

-(void) viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) keyboardDidShow: (NSNotification *)notif {
	if (displayKeyboard) {
		return;
	}
	
	NSDictionary* info = [notif userInfo];
	NSValue* aValue = [info objectForKey:UIKeyboardBoundsUserInfoKey];
	CGSize keyboardSize = [aValue CGRectValue].size;
	
	offset = scrollView.contentOffset;
	
	CGRect viewFrame = scrollView.frame;
	viewFrame.size.height -= keyboardSize.height;
	scrollView.frame = viewFrame;
	
	CGRect textFieldRect = [Field frame];
	textFieldRect.origin.y += 60;
	[scrollView scrollRectToVisible: textFieldRect animated:YES];
	displayKeyboard = YES;
}

-(void) keyboardDidHide: (NSNotification *)notif {
	if (!displayKeyboard) {
		return; 
	}
	scrollView.frame = CGRectMake(0, 0, SCROLLVIEW_CONTENT_WIDTH, SCROLLVIEW_CONTENT_HEIGHT);
	scrollView.contentOffset =offset;
	displayKeyboard = NO;
	
}

-(BOOL) textFieldShouldBeginEditing:(UITextField*)textField {
	Field = textField;
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}




@end
