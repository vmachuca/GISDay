//
//  DadosViewController.h
//  GISDay
//
//  Created by Vinicius Machuca on 14/11/12.
//  Copyright (c) 2012 Imagem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "People.h"

#define SEGUIMENTO 0

@interface DadosViewController : UIViewController

<UIPickerViewDataSource, UIPickerViewDelegate>
{
    NSMutableArray *arraySeguimentos;
    IBOutlet UIPickerView *SeguimentoPicker;
}

@property (retain, nonatomic) People *people;
@property (retain, nonatomic) IBOutlet UIView *pickerViewContainer;
@property (retain, nonatomic) IBOutlet UILabel *txtSeguimento;
@property (retain, nonatomic) IBOutlet UIView *dataContainer;
@property (retain, nonatomic) IBOutlet UITextField *lblNome;
@property (retain, nonatomic) IBOutlet UITextField *lblEmpresa;

- (IBAction)voltar:(id)sender;
- (IBAction)proximo:(id)sender;
- (IBAction)mostar:(id)sender;
- (IBAction)fechar:(id)sender;
- (IBAction)ViewTouchDown:(id)sender;
- (IBAction)lblNameEditBegin:(id)sender;
- (IBAction)lblNameEditEnd:(id)sender;
- (IBAction)lblEmpresaEditBegin:(id)sender;
- (IBAction)lblEmpresaEditEnd:(id)sender;

@end

