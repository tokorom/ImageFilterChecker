//
//  FiltersViewController.m
//
//  Created by ToKoRo on 2012-09-05.
//  Last Change: 2012-09-07.
//

#import "FiltersViewController.h"
#import "FilterViewController.h"

#pragma mark - Private Definition ------------------------------

@interface FiltersViewController ()
@property (weak) IBOutlet UITableView* tableView;
@property (strong) NSArray* filters;
@end 

#pragma mark - Main Implementation -----------------------------

@implementation FiltersViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
  if ( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ) {
    // Custom initialization
  }
  return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return ( UIInterfaceOrientationPortrait == interfaceOrientation );
}

- (void)viewDidLoad
{
  [super viewDidLoad];

  NSString* fileName = [[NSBundle mainBundle] pathForResource:@"filters" ofType:@"plist"];
  NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:fileName];
  self.filters = [dic objectForKey:@"filters"];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.filters.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  static NSString* const kTableViewCellIdentifier = @"UITableViewCell";
  UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellIdentifier];
  if ( nil == cell ) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCellIdentifier];
  }
  NSDictionary* filter = [self.filters objectAtIndex:indexPath.row];
  cell.textLabel.text = [filter objectForKey:@"filterName"];
  return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
  NSDictionary* filter = [self.filters objectAtIndex:indexPath.row];
  NSString* filterName = [filter objectForKey:@"filterName"];
  NSString* className = [filter objectForKey:@"viewControllerName"];
  Class viewControllerClass = NSClassFromString(className);
  FilterViewController* viewController = [viewControllerClass new];
  viewController.title = filterName;
  viewController.filterName = filterName;
  viewController.imageView = self.imageView;
  [viewController setParameterWithDictionary:filter];
  [self.navigationController pushViewController:viewController animated:YES];
}

@end
