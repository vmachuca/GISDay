//
//  TodosViewController.h
//  GISDay
//
//  Created by Vinicius Machuca on 14/11/12.
//  Copyright (c) 2012 Imagem. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "People.h"

@interface TodosViewController : UIViewController<AGSMapViewCalloutDelegate, AGSInfoTemplateDelegate, AGSMapViewTouchDelegate>

@property (retain, nonatomic) People *people;
@property (retain, nonatomic) IBOutlet AGSMapView *mapView;

- (IBAction)procurar:(id)sender;

@end
