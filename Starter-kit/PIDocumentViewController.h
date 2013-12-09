//
//  PIDocumentViewController.h
//  Starter-kit
//
//  Created by Étienne VALLETTE d'OSIA on 04/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PIAPI/PIAPI.h"

@interface PIDocumentViewController : UIViewController

@property PIAPI *api;
@property PIDocument *document;

@end
