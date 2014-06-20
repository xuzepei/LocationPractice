//
//  RCRootTableViewController.m
//  LocationPractice
//
//  Created by xuzepei on 6/19/14.
//  Copyright (c) 2014 TapGuilt Inc. All rights reserved.
//

#import "RCRootTableViewController.h"

@interface RCRootTableViewController ()

@end

@implementation RCRootTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(nil == _itemArray)
        _itemArray = [[NSMutableArray alloc] initWithArray:@[@"Reverse Geocoding",@"item1"]];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (id)getCellData:(NSIndexPath*)indexPath
{
    if(indexPath.row < [self.itemArray count])
    {
        return [self.itemArray objectAtIndex:indexPath.row];
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.itemArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    if(cell)
    {
        NSString* data = (NSString*)[self getCellData:indexPath];
        cell.textLabel.text = data;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(0 == indexPath.row)
    {
        [self performSegueWithIdentifier:@"si_to_rg" sender:nil];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
