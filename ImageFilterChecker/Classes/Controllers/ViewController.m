//
//  ViewController.m
//
//  Created by ToKoRo on 2012-09-05.
//  Last Change: 2012-09-05.
//

#import "ViewController.h"
#import "FiltersViewController.h"

#pragma mark - Private Definition ------------------------------

@interface ViewController ()
@property (weak) IBOutlet UIImageView *imageView;
@property (weak) IBOutlet UIView *bottomView;
@end 

#pragma mark - Main Implementation -----------------------------

@implementation ViewController

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

- (void)loadView
{
  [super loadView];

  FiltersViewController *childViewController = [FiltersViewController new];
  childViewController.title = @"Filters";
  childViewController.imageView = self.imageView;
  UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:childViewController];
  navi.view.frame = self.bottomView.bounds;
  navi.navigationBar.barStyle = UIBarStyleBlackOpaque;
  [self addChildViewController:navi];
  [self.bottomView addSubview:navi.view];
  [navi didMoveToParentViewController:self];
}

@end
