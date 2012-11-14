//
//  EuViewController.m
//  GISDay
//
//  Created by Vinicius Machuca on 14/11/12.
//  Copyright (c) 2012 Imagem. All rights reserved.
//


#import "EuViewController.h"
#import "DadosViewController.h"
#import "BlockActionSheet.h"
#import "People.h"

@interface EuViewController ()

@end

@implementation EuViewController
{
    bool openCameraView;
}

@synthesize people;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void) viewDidAppear:(BOOL)animated
{
    if(!openCameraView) return;
    
    openCameraView = false;
    
    DadosViewController *dadosView = [self.storyboard instantiateViewControllerWithIdentifier:@"Dados"];
    dadosView.people = people;
    
    [self presentModalViewController:dadosView animated:YES];
}

- (IBAction)showActionSheet:(id)sender
{
    BlockActionSheet *sheet = [BlockActionSheet sheetWithTitle:@"Escolha uma forma para enviar sua foto"];
    
    [sheet addButtonWithTitle:@"Tirar uma foto" block:^{
        [self getPhoto:true];
    }];
    [sheet addButtonWithTitle:@"Selecionar na biblioteca" block:^{
        [self getPhoto:false];
    }];
    [sheet setCancelButtonWithTitle:@"Cancelar" block:nil];
    [sheet showInView:self.view];
}

- (void)getPhoto:(bool) byCamera
{    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    imagePicker.delegate = self;
        
    if(byCamera)
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    else
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    [self presentModalViewController:imagePicker animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    openCameraView = true;
    
    UIImage *image = [[self imagemWithImage:[info objectForKey:UIImagePickerControllerOriginalImage]] copy];
        
    people = [[People alloc] initWithAvatar:image];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (UIImage *) imagemWithImage:(UIImage*)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = 320.0/480.0;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = 480.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 480.0;
        }
        else{
            imgRatio = 320.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 320.0;
        }
    }
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();    
    return img;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void)dealloc {
    [people release];
    [super dealloc];
}
@end
