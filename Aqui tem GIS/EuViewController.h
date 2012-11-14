//
//  EuViewController.h
//  GISDay
//
//  Created by Vinicius Machuca on 14/11/12.
//  Copyright (c) 2012 Imagem. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "People.h"

@interface EuViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (retain, nonatomic) People *people;

- (IBAction)showActionSheet:(id)sender;

@end
