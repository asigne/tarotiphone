//
//  SaisieResultat.m
//  Tarot2
//
//  Created by Aurélien SIGNE on 01/02/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SaisieResultat.h"


@implementation SaisieResultat
@synthesize score;
@synthesize monPickerView;
@synthesize switchChelem;
@synthesize validerResultat;
@synthesize validerScore;
@synthesize boutsArray, petitArray, joueursArray;
@synthesize appele, petitJ4, petitJ5;
@synthesize app;
@synthesize manager;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	switchChelem.on=NO;
	self.title = @"Résultat";
	app = (TarotIphoneAppDelegate*)[[UIApplication sharedApplication] delegate];
	manager = [[SQLManager alloc] initDatabase];
	
	
	//creation du bouton pour voir les scores
	UIBarButtonItem *item = [[UIBarButtonItem alloc]   
                             initWithTitle:@"Scores" style:UIBarButtonItemStyleBordered
                             target:self   
                             action:@selector(afficherScore)];  
    self.navigationItem.rightBarButtonItem = item;
	[item release];
	
	//initialisation textField score
	[score setText:@"Score de l'attaque"];
	[score setDelegate:self];
	
	//pickerView pour le nb de bouts et le petit au bout
	monPickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    CGSize pickerSize = [monPickerView sizeThatFits:CGSizeZero];
	CGRect pickerRect = CGRectMake(0.0,100.0,pickerSize.width,180);
	monPickerView.frame = pickerRect;
    monPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    monPickerView.showsSelectionIndicator = YES; // Par défaut, non
    monPickerView.delegate = self;
    monPickerView.dataSource = self;
	[self.view addSubview:monPickerView];
	[monPickerView release];
	
	NSInteger i;
	
		//creation de la liste des nb de bouts
	boutsArray = [[NSMutableArray alloc] init];	
	for (i=0; i<[manager getNbLignes:@"BOUTS"]; i++) {
		[boutsArray insertObject:(NSString *)[manager getLibelle:@"BOUTS":i] atIndex:i];
	}
	
		//creation de la liste des petit au bout
	petitArray = [[NSMutableArray alloc] init];	
	for (i=0; i<[manager getNbLignes:@"PETIT"]; i++) {
		[petitArray insertObject:(NSString *)[manager getLibelle:@"PETIT":i] atIndex:i];
	}
	
	if ([manager getNbLignes:@"JOUEUR"] == 4) {
		petitJ4.hidden=NO;		
		petitJ5.hidden=YES;
		appele.hidden=YES;
	}
	else if ([manager getNbLignes:@"JOUEUR"] == 5) {
		//creation de la liste des joueurs
		joueursArray = [[NSMutableArray alloc] init];	
		for (i=0; i<[app nbJoueursPartie]; i++) {
			[joueursArray insertObject:(NSString *)[manager getNomJoueur:i] atIndex:i];
		}
		petitJ4.hidden=YES;		
		petitJ5.hidden=NO;
		appele.hidden=NO;
	}
	
    [super viewDidLoad];
}

//cacher le bouton pour valider le score
-(void) afficherBtnValiderScore:(id)sender{
	validerScore.hidden=NO;
}

//retirer la clavier apres avoir ecrit le score
-(void) retirerClavier:(id)sender{
	NSInteger monScore = [score.text intValue];
	if(monScore < 0 || monScore > 91 || [score.text isEqualToString:@""]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Le score saisi est invalide !"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else{
		[score resignFirstResponder];	
		validerScore.hidden=YES;
	}
}

//validation du resultat et affichage des scores
-(void) validerResultat:(id)sender{
	if([score.text isEqualToString:@"Score de l'attaque"]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"Le score saisi est invalide !"
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	else{
		[[app partieEnCours] setScore:[score.text integerValue]];
		if([manager getNbLignes:@"JOUEUR"] == 4){
			[[app partieEnCours] setBouts:[monPickerView selectedRowInComponent:0]];
			[[app partieEnCours] setPetit:[monPickerView selectedRowInComponent:1]];
		}
		else if([manager getNbLignes:@"JOUEUR"] == 5){
			[[app partieEnCours] setAppele:[monPickerView selectedRowInComponent:0]];
			[[app partieEnCours] setBouts:[monPickerView selectedRowInComponent:1]];
			[[app partieEnCours] setPetit:[monPickerView selectedRowInComponent:2]];
		}
		[[app partieEnCours] setChelemR:switchChelem.on];
	
			//initialisation des variables à 0
		NSInteger scoreAObtenir = 0;
		NSInteger coeffMulti = 0;
		NSInteger primeChelem = 0;
		NSInteger primePetitAuBout = 0;
		NSInteger primePoignee = 0;
		NSInteger scoreTotal = 0;
		
			//recuperation du score saisi
		NSInteger scoreObtenu = [score.text integerValue];
		
			//determination du score a obtenir en fonction du nombre de bouts
		switch ([[app partieEnCours] bouts]) {
			case 0://aucun bout
				scoreAObtenir=56;
				break;
			case 1://1 bout
				scoreAObtenir=51;
				break;
			case 2://2 bouts
				scoreAObtenir=41;
				break;
			case 3://3 bouts
				scoreAObtenir=36;
				break;
			default:
				break;
		}
		
			//determination de 25 ou -25
		if((scoreObtenu - scoreAObtenir)>=0){
				//attaque gagne
			scoreTotal = 25;
		}
		else {
				//attaque perd
			scoreTotal = -25;
		}
		
			//determination du coeff multiplicateur en fonction du contrat
		switch ([[app partieEnCours] contrat]) {
			case 0://petite
				coeffMulti=1;
				break;
			case 1://garde
				coeffMulti=2;
				break;
			case 2://garde sans
				coeffMulti=4;
				break;
			case 3://garde contre
				coeffMulti=6;
				break;
			default:
				break;
		}
		
			//determination de la prime pour le petit au bout
		switch ([[app partieEnCours] petit]){
			case 0:
					//personne
				break;
			case 1:
					//dernier pli pour l'attaque
				primePetitAuBout = 10*coeffMulti;
				break;
			case 2:
					//dernier pli pour la défense
				if((scoreObtenu - scoreAObtenir)>=0){
						//attaque gagne
					primePetitAuBout = -10*coeffMulti;
				}
				else {
						//attaque perd
					primePetitAuBout = 10*coeffMulti;
				}
				break;
			default:
				break;
		}
		
			//determination de la prime pour le chelem
		switch ([[app partieEnCours] chelemA]) {
			case 0:
					//aucun
				if(switchChelem.on){
						//aucun chelem annoncé
					if((scoreObtenu - scoreAObtenir)>=0){
							//si chelem réussi pour l'attaque
						primeChelem=200;
					}
					else {
							//si chelem réussi pour la défense
						primeChelem=-200;
					}
				}
				else {
					primeChelem=0;
				}
				break;
			case 1:
					//chelem attaque
				if(switchChelem.on){
						//si chelem reussi par l'attaque
					primeChelem=400;
				}
				else {
						//si chelem raté par l'attaque
					primeChelem=-200;
				}
				break;
			case 2:
					//chelem defense
				if(switchChelem.on){
						//si chelem reussi par la defense
					primeChelem=-400;
				}
				else {
						//si chelem raté par la defense
					primeChelem=200;
				}
				break;
			default:
				break;
		}
		
			//determination de la prime pour la poignée
		switch ([[app partieEnCours] poignee]){
			case 1:
					//Simple attaque
				primePoignee = 20;
				break;
			case 2:
					//Double attaque
				primePoignee = 30;
				break;
			case 3:
					//Triple attaque
				primePoignee = 40;
				break;
			default:
				break;
		}
		if((scoreObtenu - scoreAObtenir)<0){
				//dans le cas d'une victoire de la défense 	
			primePoignee = -primePoignee;
		}
		
			//score calcule pour le preneur (attaque)
		/*scoreTotal =	+ ou - 25 
		 + (difference entre le score obtenu et le score à obtenir) * le coeff multiplicateur
		 + prime de la poignee
		 + prime du petit au bout
		 + prime du chelem
		 */
		
		scoreTotal = (scoreTotal+(scoreObtenu - scoreAObtenir))*coeffMulti+ primePoignee + primePetitAuBout + primeChelem;
		
		[[app partieEnCours] setScoreTotalPartie:scoreTotal];
							
		//app.nouvellePartie=YES;
	
		Recapitulatif *recapitulatif = [[Recapitulatif alloc] init];//WithNibName:@"affichageScores" bundle:nil];
		[self.navigationController pushViewController:recapitulatif animated:YES];
		[recapitulatif release];
	}
}

/*- (void) afficherScores{
	[self.tableScores reloadData];
	[self.tableParties reloadData];
	
	[pickerView1 selectRow:0 inComponent:0 animated:YES];
	[pickerView1 selectRow:0 inComponent:1 animated:YES];
	if ([app nbJoueursPartie] == 5) {
		[pickerView1 selectRow:0 inComponent:2 animated:YES];
	}
	[pickerView2 selectRow:0 inComponent:0 animated:YES];
	[pickerView2 selectRow:0 inComponent:1 animated:YES];
	[pickerView3 selectRow:0 inComponent:0 animated:YES];
	[pickerView3 selectRow:0 inComponent:1 animated:YES];
	[switchChelem setOn:NO];
	score.text = @"Score de l'attaque";
}*/

-(void) afficherScore{
	AffichageScores *affichageScores = [[AffichageScores alloc] init];
	[self.navigationController pushViewController:affichageScores animated:YES];
	[affichageScores release];
}

#pragma mark -
#pragma mark UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
		//Tarot2AppDelegate *app = (Tarot2AppDelegate*)[[UIApplication sharedApplication] delegate];
		//[app setNbBouts:([monPickerView selectedRowInComponent:1]+1)];
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *returnStr = @"";
	if ([manager getNbLignes:@"JOUEUR"] == 4) {
		if (component == 0)
			returnStr = [boutsArray objectAtIndex:row];
		else if (component == 1)
			returnStr = [petitArray objectAtIndex:row];
	}
	else if ([manager getNbLignes:@"JOUEUR"] == 5) {
		if (component == 0)
			returnStr = [joueursArray objectAtIndex:row];
		else if (component == 1)
			returnStr = [boutsArray objectAtIndex:row];
		else if (component == 2)
			returnStr = [petitArray objectAtIndex:row];
	}	
	return returnStr;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    CGFloat componentWidth = 0.0;
    if ([manager getNbLignes:@"JOUEUR"] == 4) {
		if (component == 0)
			componentWidth = 160.0;
		else if (component == 1)
			componentWidth = 160.0;
	}
	else if ([manager getNbLignes:@"JOUEUR"] == 5) {
		if (component == 0)
			componentWidth = 107;
		else if (component == 1)
			componentWidth = 90;
		else if (component == 2)
			componentWidth = 113;
	}
    return componentWidth;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	NSInteger nbLignes = 0;
	if ([manager getNbLignes:@"JOUEUR"] == 4) {
		if(component==0)
			nbLignes = [boutsArray count];
		else if(component==1)
			nbLignes = [petitArray count];
	}
	else if ([manager getNbLignes:@"JOUEUR"] == 5) {
		if(component==0)
			nbLignes = [joueursArray count];
		else if(component==1)
			nbLignes = [boutsArray count];
		else if(component==2)
			nbLignes = [petitArray count];
	}
	return nbLignes;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	NSInteger nbComponents = 0;
	if ([manager getNbLignes:@"JOUEUR"] == 4) {
		nbComponents = 2;
	}
	else if ([manager getNbLignes:@"JOUEUR"] == 5) {
		nbComponents = 3;
	}
	return nbComponents;
}


/*
 // Override to allow orientations other than the default portrait orientation.
 - (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
 // Return YES for supported orientations.
 return (interfaceOrientation == UIInterfaceOrientationPortrait);
 }
 */

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
	[boutsArray release];
	[petitArray release];
    [super dealloc];
}


@end
