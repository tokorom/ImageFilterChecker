//
//  FilterViewController.m
//
//  Created by ToKoRo on 2012-09-05.
//  Last Change: 2012-09-07.
//

#import "FilterViewController.h"

#pragma mark - Private Definition ------------------------------
#import "ParameterCell.h"

@interface FilterViewController () <ParameterCellDelegate>

@property (weak) IBOutlet UITableView* tableView;
@property (strong) NSArray* parameters;
@property (strong) NSMutableDictionary* values;

@end 

#pragma mark - Main Implementation -----------------------------

@implementation FilterViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
  if (self = [super initWithNibName:@"FilterViewController" bundle:nibBundleOrNil]) {
    self.values = [NSMutableDictionary dictionary];
    for (NSDictionary* dic in self.parameters) {
      [self.values setObject:[dic objectForKey:@"default"] forKey:[dic objectForKey:@"parameterName"]];
    }
  }
  return self;
}

- (void)loadView
{
  [super loadView];

  UIBarButtonItem* applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(applyButtonDidPush)];
  self.navigationItem.rightBarButtonItem = applyButton;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return ( UIInterfaceOrientationPortrait == interfaceOrientation );
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.parameters.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  NSDictionary* dic = [self.parameters objectAtIndex:indexPath.row];
  NSString* cellClassName = [dic objectForKey:@"cellClassName"];
  ParameterCell* cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
  if ( nil == cell ) {
    UINib* nib = [UINib nibWithNibName:cellClassName bundle:nil];
    cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  cell.delegate = self;
  [cell updateCellWithDictionary:dic];
  return cell;
}

#pragma mark - Protected Methods

- (void)executeFiltering
{
  CIImage* ciImage = [CIImage imageWithCGImage:self.targetImage.CGImage];
  CIFilter* filter = [self filterForCIImage:ciImage];
  for (id key in self.values) {
    [filter setValue:[self.values objectForKey:key] forKey:key];
  }
  CIImage* ciOutputImage = filter.outputImage;
  CIContext* context = [CIContext contextWithOptions:nil];
  CGImageRef imageRef = [context createCGImage:ciOutputImage fromRect:[ciOutputImage extent]];
  UIImage* outputImage = [UIImage imageWithCGImage:imageRef];
  [self.delegate filterViewController:self updateImage:outputImage];
}

#pragma mark - ParameterCellDelegate

- (void)parameterCell:(ParameterCell*)cell didChangeValue:(id)value forKey:(NSString*)key
{
  [self.values setObject:value forKey:key];
  [self executeFiltering];
}

#pragma mark - Override Methods

- (void)setParameterWithDictionary:(NSDictionary*)dic
{
  self.parameters = [dic objectForKey:@"parameters"];
}

- (CIFilter*)filterForCIImage:(CIImage*)ciImage
{
  CIFilter* filter = [CIFilter filterWithName:self.filterName];
  [filter setValue:ciImage forKey:kCIInputImageKey];
  return filter;
}

#pragma mark - Private Methods

- (void)applyButtonDidPush
{
  [self.delegate filterViewController:self
                          applyFilter:self.filterName
                           withValues:[self.values copy]];
  [self.navigationController popViewControllerAnimated:YES];
}

@end
