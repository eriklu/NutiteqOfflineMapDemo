//
//  OfflineMapViewController.h
//  OfflineMap
//
//  Created by aora on 14-12-12.
//  Copyright (c) 2014年 Erik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Nuti/Nuti.h>

@interface OfflineMapViewController : NTMapViewController

@property NSString *vectorStyleName, *vectorStyleLanguage;

@property NSDictionary *mapInfo;

@property NTTileLayer *mapLayer;
@property NTTileDataSource* tileDataSource;

@property NTMBVectorTileDecoder* vectorTileDecoder;
@property (nonatomic, assign) id viewDelegate;

@end
