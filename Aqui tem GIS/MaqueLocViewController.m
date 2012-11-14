//
//  MaqueLocViewController.m
//  GISDay
//
//  Created by Vinicius Machuca on 14/11/12.
//  Copyright (c) 2012 Imagem. All rights reserved.
//

#import "MaqueLocViewController.h"
#import "CalloutViewController.h"
#import "DejalActivityView.h"
#import "BlockAlertView.h"
#import "People.h"

#define cbaseMap @"http://services.arcgisonline.com/ArcGIS/rest/services/NatGeo_World_Map/MapServer"
#define cFeatureLaer @"http://services.arcgis.com/qFQYQQeTXZSPY7Fs/ArcGIS/rest/services/AquitemGis/FeatureServer/0" 
#define cToken @"pA6sHqD4qFAFQ3Aw0-D3tnXlnpMAL-cCKIf_Tn89RrCO1biRG32KSW-VL7HUUl_GEKNIcEsv4_LTm8wOLHMMtg.."

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
    [DejalBezelActivityView activityViewForView:self.view withLabel:@"Salvando..." width:100].showNetworkActivityIndicator = YES;
    
    NSMutableDictionary *graphicAttributes = [[NSMutableDictionary alloc] init];
	[graphicAttributes setObject:people.name forKey:@"NAME"];
	[graphicAttributes setObject:people.company forKey:@"COMPANY"];    
	[graphicAttributes setObject:people.industry forKey:@"INDUSTRY"];
    [graphicAttributes setObject:@"" forKey:@"ROLE"];
    [graphicAttributes setObject:@"" forKey:@"EMAIL"];
        
    AGSGraphic *graphic = [AGSGraphic graphicWithGeometry:selectedMaPoint symbol:nil attributes:graphicAttributes infoTemplateDelegate:self];
    
    [self.featureLayer addFeatures:[NSArray arrayWithObject:graphic]];
    
    [self.featureLayer dataChanged];
}

- (IBAction)mostrarLocalizacao:(id)sender
{
        
    if(!self.mapView.gps.enabled)
    {
        [self.mapView.gps start];
        [self.btnGps setTitle:@"Desabiliar localização" forState:UIControlStateNormal];
    }
    else
    {
        [self.mapView.gps stop];
        [self.btnGps setTitle:@"Habilitar localização" forState:UIControlStateNormal];
    }
}

- (void) loadMap
{
    mapView.touchDelegate = self;
    mapView.calloutDelegate = self;
    
    NSURL *urlbaseMap = [NSURL URLWithString:cbaseMap];
    NSURL *urlFeatureLayer = [NSURL URLWithString:cFeatureLaer];
    AGSCredential *credential = [[AGSCredential alloc] initWithToken:cToken];
    
    AGSTiledMapServiceLayer *tiledLayer = [AGSTiledMapServiceLayer tiledMapServiceLayerWithURL: urlbaseMap];
    self.featureLayer = [AGSFeatureLayer featureServiceLayerWithURL: urlFeatureLayer mode: AGSFeatureLayerModeOnDemand credential:credential];
    
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
	
    if (!addResult.success)
    {
        [DejalActivityView removeView];
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"GIS Day"
                                                       message:@"Ocorreu um erro no envio dos dados :("];
        
        [alert setCancelButtonWithTitle:@"Ok" block:nil];
        [alert show];
        
		return;
	}
    
    NSLog(@"object ID: %d", addResult.objectId);	
	
    NSData *avatarData = UIImagePNGRepresentation(people.avatar);
        
    [self.featureLayer addAttachment:addResult.objectId data:avatarData filename:@"FOTO-GISDAY.png"];
}

-(void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation*)op didFailFeatureEditsWithError:(NSError *)error{
	
	NSLog(@"error adding feature: %@", error.description);
}

-(void)featureLayer:(AGSFeatureLayer *)featureLayer operation:(NSOperation*)op didAttachmentEditsWithResults:(AGSFeatureLayerAttachmentResults *)attachmentResults{

    [DejalBezelActivityView removeView];
    
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Sucesso"
                                                   message:@"Obrigado por participar do GISDay :)"];
    
    [alert setCancelButtonWithTitle:@"Ok" block:nil];
    [alert show];
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

