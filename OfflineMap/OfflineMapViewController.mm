//
//  OfflineMapViewController.m
//  OfflineMap
//
//  Created by aora on 14-12-12.
//  Copyright (c) 2014年 Erik. All rights reserved.
//

#import "OfflineMapViewController.h"


@implementation OfflineMapViewController

-(void)viewDidLoad
{
    [super viewDidLoad];

    NTEPSG3857* proj = [[NTEPSG3857 alloc] init];
    [[self getOptions] setBaseProjection:proj];
    
    self.vectorStyleName = @"osmbright";
    self.vectorStyleLanguage = @"en";
    [self updateBaseLayer];
    
    double x = [[self.mapInfo valueForKey:@"x"] doubleValue];
    double y = [[self.mapInfo valueForKey:@"y"] doubleValue];

    [self setFocusPos:[proj fromWgs84:[[NTMapPos alloc] initWithX:x y: y]]  durationSeconds:0];
    [self setZoom:MIN(10, self.tileDataSource.getMaxZoom) durationSeconds:0];
    
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(5, 70, [UIScreen mainScreen].bounds.size.width, 30)];
    [slider addTarget:self action:@selector(sliderValueChanded:) forControlEvents:UIControlEventValueChanged];
    slider.value = (self.getZoom - self.tileDataSource.getMinZoom) * 1.0 / (self.tileDataSource.getMaxZoom - self.tileDataSource.getMinZoom);
    [self.view addSubview:slider];
    
}

- (void)updateBaseLayer
{
    // Load vector tile styleset
    NSString* styleAssetName = [self.vectorStyleName stringByAppendingString: @".zip"];
    BOOL styleBuildings3D = NO;
    if ([self.vectorStyleName isEqualToString:@"osmbright3d"]) {
        styleAssetName = @"osmbright.zip";
        styleBuildings3D = YES;
    }
    UnsignedCharVector *vectorTileStyleSetData = [NTAssetUtils loadBytes:styleAssetName];
    NTMBVectorTileStyleSet *vectorTileStyleSet = [[NTMBVectorTileStyleSet alloc] initWithData:vectorTileStyleSetData];
    
    // Create vector tile decoder using the styleset and update style parameters
    self.vectorTileDecoder = [[NTMBVectorTileDecoder alloc] initWithStyleSet:vectorTileStyleSet];
    [self.vectorTileDecoder setStyleStringParameter:@"lang" value:self.vectorStyleLanguage];
    if ([styleAssetName isEqualToString:@"osmbright.zip"]) { // only OSM Bright style supports
        [self.vectorTileDecoder setStyleBoolParameter:@"buildings3d" value:styleBuildings3D];
    }
    
    self.tileDataSource = [self createTileDataSource];
    
    if (self.mapLayer) {
        [[self getLayers] remove:self.mapLayer];
    }
    
    int mapType = [[self.mapInfo valueForKey:@"mapType"] intValue];
    if(mapType == 0){
        self.mapLayer = [[NTRasterTileLayer alloc] initWithDataSource:self.tileDataSource];
    }else {//
        self.mapLayer = [[NTVectorTileLayer alloc] initWithDataSource:self.tileDataSource decoder:self.vectorTileDecoder];
    }
    
    [[self getLayers] add:self.mapLayer];
}

- (NTTileDataSource*)createTileDataSource
{
    NSString *mapResourceName = [self.mapInfo valueForKey:@"mapfilename"];
    NSString* fullpathVT = [[NSBundle mainBundle] pathForResource:mapResourceName ofType:@"mbtiles"];
    int mapType = [[self.mapInfo valueForKey:@"mapType"] intValue];
    
    NTTileDataSource* tileDataSource = [[NTMBTilesTileDataSource alloc] initWithMinZoom:9 maxZoom:18 path:fullpathVT scheme: (mapType==0) ? MBTILES_SCHEME_TMS : MBTILES_SCHEME_XYZ];
    return tileDataSource;
}

-(void)sliderValueChanded:(UISlider* )slider{
    float value = slider.value;
    int zoom = self.tileDataSource.getMinZoom + (int)((self.tileDataSource.getMaxZoom - self.tileDataSource.getMinZoom) * value);
    [self setZoom:zoom durationSeconds:0];
}

@end
