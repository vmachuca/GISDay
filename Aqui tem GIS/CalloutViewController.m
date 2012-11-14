//
//  CalloutViewController.m
//  GISDay
//
//  Created by Vinicius Machuca on 14/11/12.
//  Copyright (c) 2012 Imagem. All rights reserved.
//

#import "CalloutViewController.h"


@implementation CalloutViewController
{
    People* people;
}

@synthesize name;
@synthesize empresa;
@synthesize avatar = _avatar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithNibName:@"CalloutViewController" bundle:nil];
    if (self) {
        self.view.frame = frame;
        self.view.userInteractionEnabled = NO;
        self.view.alpha = .9;
    }
    return self;    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setAvatar:nil];
    [self setName:nil];
    [self setEmpresa:nil];
    [super viewDidUnload];
}

-(void) loadPeople:(People*) newPerson;
{
    people = newPerson;
    
    [self.avatar setImage:people.avatar];    
    [self.name setText:[[people.name componentsSeparatedByString: @" "] objectAtIndex:0]];
    [self.empresa setText:[[people.company componentsSeparatedByString: @" "] objectAtIndex:0]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    [self.avatar release];
    [name release];
    [empresa release];
    [super dealloc];
}
@end
