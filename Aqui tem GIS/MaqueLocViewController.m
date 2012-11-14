//
//  MaqueLocViewController.m
//  GISDay
//
//  Created by Vinicius Machuca on 14/11/12.
//  Copyright (c) 2012 Imagem. All rights reserved.
//

#import "MaqueLocViewController.h"
#import "CalloutViewController.h"
#import "People.h"

#define cbaseMap @"http://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer"
#define cFeatureLaer @"http://services.arcgis.com/qFQYQQeTXZSPY7Fs/ArcGIS/rest/services/AquitemGis/FeatureServer/0?token=pA6sHqD4qFAFQ3Aw0-D3tnXlnpMAL-cCKIf_Tn89RrCO1biRG32KSW-VL7HUUl_GEKNIcEsv4_LTm8wOLHMMtg.." //tirar o token hardcode

@interface MaqueLocViewController ()

  @property (nonatomic, retain) CalloutViewController *customCallout;
  @property (nonatomic, retain) AGSFeatureLayer *featureLayer;

@end

@implementation MaqueLocViewController
{
    AGSPoint* selectedMaPoint;    
    AGSGraphicsLayer* graphicsLayer;
    CLLocationManager *locationManager;
}

@synthesize mapView;
@synthesize people;
@synthesize featureLayer = _featureLayer;
@synthesize customCallout = _customCallout;

- (void)viewDidLoad
{
    [super viewDidLoad];    
    [self loadMap];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    CGRect frame = CGRectMake(0, 0, 125, 168);
	self.customCallout = [[[CalloutViewController alloc] initWithFrame:frame] autorelease];
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setMapView:nil];
    [self setBtnGps:nil];
    [super viewDidUnload];
}

- (IBAction)voltar:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)finalizar:(id)sender
{
    AGSGraphic *graphic;
        
    NSMutableDictionary *graphicAttributes = [[NSMutableDictionary alloc] init];
	[graphicAttributes setObject:people.name forKey:@"NAME"];
	[graphicAttributes setObject:people.company forKey:@"COMPANY"];    
	[graphicAttributes setObject:people.industry forKey:@"INDUSTRY"];
    [graphicAttributes setObject:@"" forKey:@"ROLE"];
    [graphicAttributes setObject:@"" forKey:@"EMAIL"];
        
    graphic = [AGSGraphic graphicWithGeometry:selectedMaPoint symbol:nil attributes:graphicAttributes infoTemplateDelegate:self];
    
    [self.featureLayer addFeatures:[NSArray arrayWithObject:graphic]];
    
    [self.featureLayer dataChanged];
}

- (IBAction)mostrarLocalizacao:(id)sender
{
        
    if(!self.mapView.gps.enabled)
    {
        [self.mapView.gps start];
        self.btnGps.titleLabel.text = @"Desabiliar";
    }
    else
    {
        [self.mapView.gps stop];
        self.btnGps.titleLabel.text = @"Mostrar minha localização";
    }
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
        
    self.featureLayer.editingDelegate = self;
    
    [locationManager startUpdatingLocation];   
}
 
- (void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics
{
    if(self.mapView.gps.enabled)
        selectedMaPoint = self.mapView.gps.currentPoint;
    else
        selectedMaPoint = mappoint;
    
    [self.customCallout loadPeople:people];
    
    self.mapView.callout.customView = self.customCallout.view;
    
    [self.mapView.callout showCalloutAt:selectedMaPoint pixelOffset:CGPointMake(0.0, 0.0) animated:YES];
    
    [self.mapView zoomToGeometry:selectedMaPoint withPadding:1 animated:YES];
}


-(void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation*)op didQueryAttachmentInfosWithResults:(NSArray *)attachmentInfos{
		
	NSLog(@"got attachment infos...");
}

-(void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation *)op didFailQueryAttachmentInfosWithError:(NSError *)error{

    NSLog(@"error adding feature: %@", error.description);	
}

-(void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation*)op didFeatureEditsWithResults:(AGSFeatureLayerEditResults *)editResults{

	AGSEditResult *addResult = [editResults.addResults objectAtIndex:0];
	if (!addResult.success){
		return;
	}
    
    NSLog(@"object ID: %d", addResult.objectId);	
	
    NSData *avatarData = UIImagePNGRepresentation(people.avatar);
        
    [self.featureLayer addAttachment:addResult.objectId data:avatarData filename:@"avatar.png"];
}

-(void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation*)op didFailFeatureEditsWithError:(NSError *)error{
	
	NSLog(@"error adding feature: %@", error.description);
}

-(void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation*)op didAttachmentEditsWithResults:(AGSFeatureLayerAttachmentResults *)attachmentResults{

	NSLog(@"error adding feature");
}

-(void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation*)op didFailAttachmentEditsWithError:(NSError *)error{
	// falha envio anexo
	NSLog(@"error adding feature: %@", error.description);
}

-(void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation*)op didRetrieveAttachmentWithData:(NSData *)attachmentData{
	
	NSLog(@"error adding feature");
}

-(void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation*)op didFailRetrieveAttachmentWithError:(NSError *)error{

	NSLog(@"error adding feature: %@", error.description);  
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void)dealloc {
    [mapView release];
    [_btnGps release];
    [super dealloc];
    self.customCallout = nil;
}
@end

