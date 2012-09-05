//
//  FilterViewController.m
//
//  Created by ToKoRo on 2012-09-05.
//  Last Change: 2012-09-05.
//

#import "FilterViewController.h"

#pragma mark - Private Definition ------------------------------

@interface FilterViewController ()
@property (weak) IBOutlet UITableView *tableView;
@property (strong) NSArray *dataSource;
@property (strong) NSMutableDictionary *values;
@property (strong) UIImage *defaultImage;
@end 

#pragma mark - Main Implementation -----------------------------

@implementation FilterViewController

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil
{
  if (self = [super initWithNibName:@"FilterViewController" bundle:nibBundleOrNil]) {
    [self setupDataSource];
    self.values = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in self.dataSource) {
      [self.values setObject:[dic objectForKey:@"default"] forKey:[dic objectForKey:@"key"]];
    }
  }
  return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return ( UIInterfaceOrientationPortrait == interfaceOrientation );
}

- (void)viewDidDisappear:(BOOL)animated 
{
  [super viewDidDisappear:animated];
  if (self.defaultImage) {
    self.imageView.image = self.defaultImage;
  }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.dataSource.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  NSDictionary *dic = [self.dataSource objectAtIndex:indexPath.row];
  NSString *cellClassName = [dic objectForKey:@"cell"];
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellClassName];
  if ( nil == cell ) {
    UINib* nib = [UINib nibWithNibName:cellClassName bundle:nil];
    cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  }
  [self updateCell:cell withDictionary:dic];
  return cell;
}

#pragma mark - Protected Methods

- (void)executeFiltering
{
  if (nil == self.defaultImage) {
    self.defaultImage = self.imageView.image;
  }
  CIImage *ciImage = [CIImage imageWithCGImage:self.defaultImage.CGImage];
  CIFilter *filter = [self filterForCIImage:ciImage];
  for (id key in self.values) {
    [filter setValue:[self.values objectForKey:key] forKey:key];
  }
  CIImage *ciOutputImage = filter.outputImage;
  CIContext *context = [CIContext contextWithOptions:nil];
  CGImageRef imageRef = [context createCGImage:ciOutputImage fromRect:[ciOutputImage extent]];
  UIImage *outputImage = [UIImage imageWithCGImage:imageRef];
  self.imageView.image = outputImage;
}

#pragma mark - Override Methods

- (void)setupDataSource
{
  self.dataSource = @[];
}

- (void)updateCell:(UITableViewCell*)cell withDictionary:(NSDictionary*)dic
{
}

- (CIFilter*)filterForCIImage:(CIImage*)ciImage
{
  CIFilter *filter = [CIFilter filterWithName:self.filterName];
  [filter setValue:ciImage forKey:kCIInputImageKey];
  return filter;
}

@end
