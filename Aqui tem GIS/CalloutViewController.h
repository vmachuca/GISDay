//
//  CalloutViewController.h
//  GISDay
//
//  Created by Vinicius Machuca on 14/11/12.
//  Copyright (c) 2012 Imagem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "People.h"

@interface CalloutViewController : UIViewController

@property (retain, nonatomic) IBOutlet UILabel *name;
@property (retain, nonatomic) IBOutlet UILabel *empresa;
@property (retain, nonatomic) IBOutlet UIImageView *avatar;

- (id)initWithFrame:(CGRect)frame;
-(void) loadPeople:(People*) newPerson;

@end