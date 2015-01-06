//
//  ViewController.m
//  OfflineMap
//
//  Created by aora on 14-12-12.
//  Copyright (c) 2014年 Erik. All rights reserved.
//

#import "ViewController.h"
#import "OfflineMapViewController.h"

@interface ViewController ()
{
    NSArray *_maps;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _maps = @[
              @{@"mapname" : @"香港", @"mapfilename" : @"hongkong", @"x" : @114.18307, @"y" : @22.302439, @"mapType" : @0, },
              @{@"mapname" : @"台北", @"mapfilename" : @"taipei", @"x" : @121.50, @"y" : @25.05, @"mapType" : @0, },
              @{@"mapname" : @"广东", @"mapfilename" : @"guangdong", @"x" : @114.06667, @"y" : @22.61667, @"mapType" : @0, },
              @{@"mapname" : @"柏林", @"mapfilename" : @"berlin_ntvt", @"x" : @13.38933 , @"y" : @52.51704, @"mapType" : @1, },
              ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _maps.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellMapName"];
    cell.textLabel.text = [_maps[indexPath.row] valueForKey:@"mapname"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OfflineMapViewController *vc = [[OfflineMapViewController alloc] init];
    vc.mapInfo = _maps[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
