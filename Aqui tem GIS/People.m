//
//  People.m
//  GISDay
//
//  Created by Vinicius Machuca on 14/11/12.
//  Copyright (c) 2012 Imagem. All rights reserved.
//

#import "People.h"

@implementation People

@synthesize name;
@synthesize company;
@synthesize industry;
@synthesize avatar;

- (id)initWithAvatar:(UIImage*) photo
{    
    if(self = [super init]) {
        avatar = photo;
    }
    return self;    
}

@end
