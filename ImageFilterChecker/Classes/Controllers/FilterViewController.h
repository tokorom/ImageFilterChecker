//
//  FilterViewController.h
//
//  Created by ToKoRo on 2012-09-05.
//  Last Change: 2012-09-07.
//

@interface FilterViewController : UIViewController

@property (weak) UIImageView* imageView;
@property (copy) NSString* filterName;

- (void)setParameterWithDictionary:(NSDictionary*)dic;

@end

#pragma mark - Protected

@interface FilterViewController (Protected)
@property (weak, readonly) UITableView* tableView;
@property (strong) NSArray* parameters;
@property (strong) NSMutableDictionary* values;
- (void)executeFiltering;
@end 
