//
//  Helper.m
//  GISDay
//
//  Created by Vinicius Machuca on 14/11/12.
//  Copyright (c) 2012 Imagem. All rights reserved.
//

#import "Helper.h"
#import <UIKit/UIKit.h>

@implementation Helper

+ (NSString*) getInconUrlByRowId:(NSInteger) row
{
    switch (row) {
        case 0:
            return @"mineracao.png";
        case 1:
            return @"saneamento.png";
        case 2:
            return @"eletrica.png";
        case 3:
            return @"govmunicipal.png";
        case 4:
            return @"govestadual.png";
        case 5:
            return @"govfederal.png";
        case 6:
            return @"telecom.png";
        default:
            return @"outros.png";
    }
}

@end
