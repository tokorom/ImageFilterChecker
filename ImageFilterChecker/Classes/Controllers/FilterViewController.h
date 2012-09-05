//
//  FilterViewController.h
//
//  Created by ToKoRo on 2012-09-05.
//  Last Change: 2012-09-05.
//

@interface FilterViewController : UIViewController
@property (weak) UIImageView *imageView;
@property (copy) NSString* filterName;
@end

@interface FilterViewController (Protected)
@property (weak, readonly) UITableView *tableView;
@property (strong) NSArray *dataSource;
@property (strong) NSMutableDictionary *values;
- (void)executeFiltering;
@end 
