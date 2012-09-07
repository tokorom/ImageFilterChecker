//
//  FilterViewController.h
//
//  Created by ToKoRo on 2012-09-05.
//  Last Change: 2012-09-07.
//

@protocol FilterViewControllerDelegate;

@interface FilterViewController : UIViewController

@property (weak) id<FilterViewControllerDelegate> delegate;
@property (weak) UIImage* targetImage;
@property (copy) NSString* filterName;

- (void)setParameterWithDictionary:(NSDictionary*)dic;
- (void)setMergeInfoWithDictionary:(NSDictionary*)dic;

@end

#pragma mark - FilterViewControllerDelegate

@protocol FilterViewControllerDelegate
@required

- (void)filterViewController:(FilterViewController*)filterViewController
                 applyFilter:(NSString*)filterName
                  withValues:(NSArray*)values;

- (void)filterViewController:(FilterViewController*)filterViewController updateImage:(UIImage*)image;

@end 

#pragma mark - Protected

@interface FilterViewController (Protected)
@property (weak, readonly) UITableView* tableView;
@property (strong) NSArray* parameters;
@property (strong) NSMutableDictionary* values;
- (void)executeFiltering;
@end 
