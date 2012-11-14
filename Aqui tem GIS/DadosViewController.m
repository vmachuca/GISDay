//
//  DadosViewController.m
//  GISDay
//
//  Created by Vinicius Machuca on 14/11/12.
//  Copyright (c) 2012 Imagem. All rights reserved.
//

#import "DadosViewController.h"
#import "MaqueLocViewController.h"
#import "BlockAlertView.h"
#import "Helper.h"

@interface DadosViewController ()

@end

@implementation DadosViewController

@synthesize people;
@synthesize pickerViewContainer;
@synthesize txtSeguimento;
@synthesize dataContainer;
@synthesize lblNome;
@synthesize lblEmpresa;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self loadPicker];
    [self defineContainerStyle];
}

- (void)viewDidUnload
{
    [self setPickerViewContainer:nil];
    [self setTxtSeguimento:nil];
    [self setDataContainer:nil];
    [self setLblNome:nil];
    [self setLblEmpresa:nil];
    [super viewDidUnload];
}

- (void)loadPicker
{
    arraySeguimentos = [[NSMutableArray alloc] init];
    [arraySeguimentos addObject:@"Mineração"];
    [arraySeguimentos addObject:@"Saneamento"];
    [arraySeguimentos addObject:@"Energia Elétrica"];
    [arraySeguimentos addObject:@"Governo Municipal"];
    [arraySeguimentos addObject:@"Governo Estadual"];
    [arraySeguimentos addObject:@"Governo Federal"];
    [arraySeguimentos addObject:@"Telecom"];
    [arraySeguimentos addObject:@"Outros"];
    
    pickerViewContainer.frame = CGRectMake(0, 460, 331, 258);
}

- (void) defineContainerStyle
{
    CGColorSpaceRef rbColors = CGColorSpaceCreateDeviceRGB();
    CGFloat values[4] = {1.0, 1.0, 1.0, 0.3};
    CGColorRef white = CGColorCreate(rbColors, values);
    
    dataContainer.layer.cornerRadius = 10;
    dataContainer.layer.masksToBounds = NO;
    dataContainer.layer.shadowColor = white;
    dataContainer.layer.shadowOffset = CGSizeMake(5, 10);
    dataContainer.layer.shadowRadius = 10;
    dataContainer.layer.shadowOpacity = 0.9;
}

- (IBAction)voltar:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)proximo:(id)sender
{
    
    if([self validaForm])
    {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"GIS Day"
                                message:@"Preencha todas as informações!"];
        
        [alert setCancelButtonWithTitle:@"Ok" block:nil];
        [alert show];
        return;
    }
    
    people.name = lblNome.text;
    people.company = lblEmpresa.text;
    people.industry = txtSeguimento.text;
    
    MaqueLocViewController *marqueLocView = [self.storyboard instantiateViewControllerWithIdentifier:@"MarqueLoc"];
    marqueLocView.people = people;
    
    [self presentModalViewController:marqueLocView animated:YES];
}

- (IBAction)mostar:(id)sender
{
    [lblNome resignFirstResponder];
    [lblEmpresa resignFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerViewContainer.frame = CGRectMake(-3, 203, 328, 258);
    [UIView commitAnimations];
}

- (IBAction)fechar:(id)sender
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerViewContainer.frame = CGRectMake(0, 460, 330, 258);
    [UIView commitAnimations];
}

- (IBAction)lblNameEditBegin:(id)sender
{
    if([lblNome.text isEqualToString: @"Nome"]) lblNome.text = @"";        
}

- (IBAction)lblNameEditEnd:(id)sender
{
    if([lblNome.text isEqualToString: @""]) lblNome.text = @"Nome";
}

- (IBAction)lblEmpresaEditBegin:(id)sender
{
    if([lblEmpresa.text isEqualToString: @"Empresa"]) lblEmpresa.text = @"";
}

- (IBAction)lblEmpresaEditEnd:(id)sender
{
    if([lblEmpresa.text isEqualToString: @""]) lblEmpresa.text = @"Empresa";
}

- (IBAction)ViewTouchDown:(id)sender
{
    [lblNome resignFirstResponder];
    [lblEmpresa resignFirstResponder];
}

- (bool) validaForm
{
    return [lblNome.text isEqualToString: @"Nome"] ||
           [lblEmpresa.text isEqualToString: @"Empresa"] ||
           [txtSeguimento.text isEqualToString: @"Seguimento"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == SEGUIMENTO)
        return [arraySeguimentos count];
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == SEGUIMENTO)
        return [arraySeguimentos objectAtIndex:row];
    
    return 0;
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    txtSeguimento.text = [arraySeguimentos objectAtIndex:[pickerView selectedRowInComponent:0]];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UIImage *img = [UIImage imageNamed:[Helper getInconUrlByRowId:row]];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake(0, 15, 30, 30);  
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, pickerView.frame.size.width-125, 60)];
    label.text = [arraySeguimentos objectAtIndex:row];
    label.textAlignment = UITextAlignmentLeft;
    label.font = [UIFont boldSystemFontOfSize:17.0];
    label.backgroundColor = [UIColor clearColor];
    
    UIView *viewRow = [[UIView alloc] initWithFrame:CGRectMake(30, 0, pickerView.frame.size.width-50, 60)];
    [viewRow insertSubview:imgView atIndex:0];
    [viewRow insertSubview:label atIndex:1];
    return viewRow;
}

- (void)dealloc {
    [SeguimentoPicker release];
    [pickerViewContainer release];
    [txtSeguimento release];
    [dataContainer release];
    [lblNome release];
    [lblEmpresa release];
    [super dealloc];
}

@end
