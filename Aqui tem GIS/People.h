//
//  People.h
//  GISDay
//
//  Created by Vinicius Machuca on 14/11/12.
//  Copyright (c) 2012 Imagem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface People : NSObject

@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString *company;
@property (retain, nonatomic) NSString *industry;
@property (retain, nonatomic) UIImage  *avatar;

- (id)initWithAvatar:(UIImage*) photo;

@end
