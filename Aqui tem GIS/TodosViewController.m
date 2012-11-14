//
//  TodosViewController.m
//  GISDay
//
//  Created by Vinicius Machuca on 14/11/12.
//  Copyright (c) 2012 Imagem. All rights reserved.
//

#import "TodosViewController.h"
#import "CalloutViewController.h"
#import "People.h"

#define cbaseMap @"http://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer"
#define cFeatureLaer @"http://services.arcgis.com/qFQYQQeTXZSPY7Fs/ArcGIS/rest/services/AquitemGis/FeatureServer/0?token=BdLiaXh82zuM596QPjg4hnxCXjQPAoImo1RUrks2pb4kbdBjzYgJxexOlOt-z31I"

@interface TodosViewController ()

@property (nonatomic, retain) CalloutViewController *customCallout;
@property (nonatomic, retain) AGSFeatureLayer *featureLayer;

@end

@implementation TodosViewController
{
    AGSPoint* selectedMaPoint;
    AGSGraphicsLayer* graphicsLayer;
}

@synthesize mapView;
@synthesize people;
@synthesize featureLayer = _featureLayer;
@synthesize customCallout = _customCallout;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadMap];
    
    CGRect frame = CGRectMake(0, 0, 125, 168);
	self.customCallout = [[[CalloutViewController alloc] initWithFrame:frame] autorelease];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

- (IBAction)procurar:(id)sender
{
    
}

- (void) loadMap
{
    mapView.touchDelegate = self;
    mapView.calloutDelegate = self;
    
    NSURL *urlbaseMap = [NSURL URLWithString:cbaseMap];
    NSURL *urlFeatureLayer = [NSURL URLWithString:cFeatureLaer];
    
    AGSTiledMapServiceLayer *tiledLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL: urlbaseMap];
    self.featureLayer = [AGSFeatureLayer featureServiceLayerWithURL: urlFeatureLayer mode: AGSFeatureLayerModeOnDemand];
    
    [mapView addMapLayer:tiledLayer withName:@"EuEsriMap"];
    [mapView addMapLayer:self.featureLayer withName:@"People"];    
}

- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics
{
    selectedMaPoint = mappoint;
    
    [self.customCallout loadPeople:people];
    
    self.mapView.callout.customView = self.customCallout.view;
    
    [self.mapView.callout showCalloutAt:mappoint pixelOffset:CGPointMake(0.0, 0.0) animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void)dealloc {
    [mapView release];
    [super dealloc];
}
@end
