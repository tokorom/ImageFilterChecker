//
//  FiltersViewController.m
//
//  Created by ToKoRo on 2012-09-05.
//  Last Change: 2012-09-07.
//

#import "FiltersViewController.h"
#import "FilterViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

typedef enum {
  FiltersActionIndexSendByMail = 0,
  FiltersActionIndexRevert,
  FiltersActionIndexCancel,
} FiltersActionIndex;

#pragma mark - Private Definition ------------------------------

@interface FiltersViewController () <
  FilterViewControllerDelegate,
  UIActionSheetDelegate,
  MFMailComposeViewControllerDelegate
>
@property (weak) IBOutlet UITableView* tableView;
@property (strong) NSArray* filters;
@property (strong) UIImage* defaultImage;
@property (strong) UIImage* currentImage;
@property (strong) NSMutableArray* appliedFilters;
@end 

#pragma mark - Main Implementation -----------------------------

@implementation FiltersViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
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

  UIBarButtonItem* actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                                                                target:self
                                                                                action:@selector(actionButtonDidPush)];
  self.navigationItem.rightBarButtonItem = actionButton;

  self.appliedFilters = [NSMutableArray array];

  self.defaultImage = self.imageView.image;
  [self updateImage:self.defaultImage];

  NSString* fileName = [[NSBundle mainBundle] pathForResource:@"filters" ofType:@"plist"];
  NSDictionary* dic = [NSDictionary dictionaryWithContentsOfFile:fileName];
  self.filters = [dic objectForKey:@"filters"];
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.tableView reloadData];
  [self updateImage:self.currentImage];
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
  viewController.delegate = self;
  viewController.title = filterName;
  viewController.filterName = filterName;
  viewController.targetImage = self.imageView.image;
  [viewController setParameterWithDictionary:filter];
  [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - FilterViewControllerDelegate

- (void)filterViewController:(FilterViewController*)filterViewController
                 applyFilter:(NSString*)filterName
                  withValues:(NSArray*)values
{
  [self updateImage:self.imageView.image];
  [self.appliedFilters addObject:@{
    @"filterName": filterName,
    @"parameters": values
  }];
  NSLog( @"appliedFilters: %@", self.appliedFilters );
}

- (void)filterViewController:(FilterViewController*)filterViewController updateImage:(UIImage*)image
{
  self.imageView.image = image;
}

#pragma mark - MFMailComposeViewControllerDelegate Methods

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
  if (error) {
    UIAlertView* alert = [UIAlertView new];
    alert.message = [error localizedDescription];
    [alert addButtonWithTitle:@"OK"];
    [alert show];
  }
  [controller dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  if (actionSheet.cancelButtonIndex == buttonIndex) return;
    
  switch (buttonIndex) {
    case FiltersActionIndexSendByMail:
      [self sendByMail];
      break;
    case FiltersActionIndexRevert:
      [self revert];
      break;
    default:
      break;
  }
}

#pragma mark - Private Methods

- (void)updateImage:(UIImage*)image
{
  if (image != self.currentImage) {
    self.currentImage = image;
  }
  if (image != self.imageView.image) {
    self.imageView.image = image;
  }
}

- (void)actionButtonDidPush
{
  UIActionSheet* actionSheet = [UIActionSheet new];
  actionSheet.delegate = self;
  if (0 < self.appliedFilters.count) {
    [actionSheet addButtonWithTitle:@"Send by Mail"];
    [actionSheet addButtonWithTitle:@"Revert"];
    actionSheet.destructiveButtonIndex = 1;
  }
  [actionSheet addButtonWithTitle:@"Cancel"];
  actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
  [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
}

- (void)sendByMail
{
  MFMailComposeViewController* viewController = [MFMailComposeViewController new];
  viewController.mailComposeDelegate = self;
  [viewController setSubject:@"The original filter"];
  [viewController setMessageBody:[self.appliedFilters description] isHTML:NO];
  [self presentViewController:viewController animated:YES completion:NULL];
}

- (void)revert
{
  [self updateImage:self.defaultImage];
  [self.appliedFilters removeAllObjects];
}

@end
