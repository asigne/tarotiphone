//
//  SaisieParametre.m
//  Tarot2
//
//  Created by Aurélien SIGNE on 31/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SaisieParametre.h"

@implementation SaisieParametre
@synthesize preneur, contrat, poignee, chelem;
@synthesize segmentedControllerParam;
@synthesize pickerView1;
@synthesize pickerView2;
@synthesize btnValider;
@synthesize app;
@synthesize manager;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	app = (TarotIphoneAppDelegate*)[[UIApplication sharedApplication] delegate];
	manager = [[SQLManager alloc] initDatabase];
	self.title = @"Paramètres";
	
	//creation du bouton pour voir les scores
	UIBarButtonItem *item = [[UIBarButtonItem alloc]   
                             initWithTitle:@"Scores" style:UIBarButtonItemStyleBordered
                             target:self   
                             action:@selector(afficherScore:)];  
    self.navigationItem.rightBarButtonItem = item;  
	[item release];
	
	//pickerView pour le preneur et le contrat
	pickerView1 = [[UIPickerView alloc] initWithFrame:CGRectZero];
    CGSize pickerSize = [pickerView1 sizeThatFits:CGSizeZero];
	CGRect pickerRect = CGRectMake(0.0, 50.0, pickerSize.width, 216.0);
	pickerView1.frame = pickerRect;
    pickerView1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    pickerView1.showsSelectionIndicator = YES; // Par défaut, non
	pickerView1.delegate = self;
    pickerView1.dataSource = self;
	
	[self.view addSubview:pickerView1];
	[pickerView1 release];
	
	//pickerView pour la poignee et le chelem
	pickerView2 = [[UIPickerView alloc] initWithFrame:CGRectZero];
	CGRect pickerRectPoignee = CGRectMake( 0.0, 50, pickerSize.width, 216.0);
	pickerView2.frame = pickerRectPoignee;
    pickerView2.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    pickerView2.showsSelectionIndicator = YES; // Par défaut, non
	pickerView2.delegate = self;
    pickerView2.dataSource = self;
	[self.view addSubview:pickerView2];
	[pickerView2 release];
	//on cache pickerView2
	pickerView2.hidden=YES;
	
	NSInteger i;
	
		//creation de la liste des contrats
	contratsArray = [[NSMutableArray alloc] init];	
	for (i=0; i<[manager getNbLignes:@"CONTRAT"]; i++) {
		[contratsArray insertObject:(NSString *)[manager getLibelle:@"CONTRAT":i] atIndex:i];
	}
	
		//creation de la liste des joueurs
	joueursArray = [[NSMutableArray alloc] init];	
	for (i=0; i<[app nbJoueursPartie]; i++) {
		[joueursArray insertObject:(NSString *)[manager getNomJoueur:i] atIndex:i];
	}
	
		//creation de la liste des poignees
	poigneesArray = [[NSMutableArray alloc] init];	
	for (i=0; i<[manager getNbLignes:@"POIGNEE"]; i++) {
		[poigneesArray insertObject:(NSString *)[manager getLibelle:@"POIGNEE":i] atIndex:i];
	}
	
		//creation de la liste des chelem
	chelemsArray = [[NSMutableArray alloc] init];	
	for (i=0; i<[manager getNbLignes:@"CHELEM"]; i++) {
		[chelemsArray insertObject:(NSString *)[manager getLibelle:@"CHELEM":i] atIndex:i];
	}
	
	//creation bouton segmentation
	segmentedControllerParam.selectedSegmentIndex = 0;
	[segmentedControllerParam addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
	[segmentedControllerParam release]; 
	[super viewDidLoad];

}


- (void)viewWillAppear:(BOOL)animated{
	if([app partieEnCoursTerminee] == YES){
		[app setPartieEnCoursTerminee:NO]; 
		segmentedControllerParam.selectedSegmentIndex = 0;
		[pickerView1 selectRow:0 inComponent:0 animated:YES];
		[pickerView1 selectRow:0 inComponent:1 animated:YES];
		[pickerView2 selectRow:0 inComponent:0 animated:YES];
		[pickerView2 selectRow:0 inComponent:1 animated:YES];
	}
}


//action pour changer "d'onglet"
- (IBAction)segmentAction:(id)sender{
	segmentedControllerParam = (UISegmentedControl *)sender;
	if(segmentedControllerParam.selectedSegmentIndex == 0){
		pickerView2.hidden=YES;
		pickerView1.hidden=NO;
		poignee.hidden=YES;
		preneur.hidden=NO;
		chelem.hidden=YES;
		contrat.hidden=NO;
	}
	else if(segmentedControllerParam.selectedSegmentIndex == 1){
		pickerView1.hidden=YES;
		pickerView2.hidden=NO;
		preneur.hidden=YES;
		poignee.hidden=NO;
		contrat.hidden=YES;
		chelem.hidden=NO;
	}
}

//validation des parametres de la partie
-(void) validerParametres:(id)sender{
	[[app partieEnCours] setPreneur:[pickerView1 selectedRowInComponent:0]];
	[[app partieEnCours] setContrat:[pickerView1 selectedRowInComponent:1]];
	[[app partieEnCours] setPoignee:[pickerView2 selectedRowInComponent:0]];
	[[app partieEnCours] setChelemA:[pickerView2 selectedRowInComponent:1]];
	
	SaisieResultat *saisieResultat = [[SaisieResultat alloc] init];
	[self.navigationController pushViewController:saisieResultat animated:YES];
	[saisieResultat release];			
	
	
	
	/*
	[app setChelem:(NSInteger) [pickerView2 selectedRowInComponent:1]];
	[app setPoignee:[pickerView2 selectedRowInComponent:0]];
	[app setPreneur:[app.joueurs objectAtIndex:[pickerView1 selectedRowInComponent:0]]];
	[app setContrat:[pickerView1 selectedRowInComponent:1]];
	*/
}

//afficher les scores
-(void) afficherScore:(id)sender{
	AffichageScores *affichageScores = [[AffichageScores alloc] init];
	[self.navigationController pushViewController:affichageScores animated:YES];
	[affichageScores release];
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *returnStr = @"";
	if(pickerView == pickerView2){
		if (component == 0)
			returnStr = [poigneesArray objectAtIndex:row];
		else if (component == 1)
			returnStr = [chelemsArray objectAtIndex:row];
	}
	else if(pickerView == pickerView1){
		if (component == 0)
			returnStr = [joueursArray objectAtIndex:row];
		else if (component == 1)
			returnStr = [contratsArray objectAtIndex:row];
	}
    return returnStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    CGFloat componentWidth = 0.0;
    if(pickerView == pickerView2){
		if (component == 0)
			componentWidth = 158.0;
		else if (component == 1)
			componentWidth = 158.0;		
	}
	else if(pickerView == pickerView1){
		if (component == 0)
			componentWidth = 158.0;
		else if (component == 1)
			componentWidth = 158.0;
	}
    return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	NSInteger nbLignes = 0;
	if(pickerView == pickerView2){
		if(component==0)
			nbLignes = [poigneesArray count];
		else if(component==1)
			nbLignes = [chelemsArray count];		
	}
	else if(pickerView == pickerView1){
		if(component==0)
			nbLignes = [joueursArray count];
		else if(component==1)
			nbLignes = [contratsArray count];
	}
	return nbLignes;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	NSInteger nbComponents = 0;
	if(pickerView == pickerView1)
		nbComponents = 2;
	else if(pickerView == pickerView2)
		nbComponents = 2;
	return nbComponents;
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
	[joueursArray release];
	[poigneesArray release];
	[contratsArray release];
	[chelemsArray release];
    [super dealloc];
}

@end
