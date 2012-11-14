//
//  MaqueLocViewController.h
//  GISDay
//
//  Created by Vinicius Machuca on 14/11/12.
//  Copyright (c) 2012 Imagem. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "CalloutViewController.h"
#import "People.h"

@interface MaqueLocViewController : UIViewController<CLLocationManagerDelegate, AGSMapViewCalloutDelegate, AGSInfoTemplateDelegate, AGSMapViewTouchDelegate, AGSFeatureLayerEditingDelegate>


@property (retain, nonatomic) People *people;
@property (retain, nonatomic) IBOutlet UIButton *btnGps;
@property (retain, nonatomic) IBOutlet AGSMapView *mapView;


- (IBAction)voltar:(id)sender;
- (IBAction)finalizar:(id)sender;
- (IBAction)mostrarLocalizacao:(id)sender;

@end
