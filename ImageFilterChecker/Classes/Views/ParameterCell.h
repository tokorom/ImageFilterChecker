//
//  ParameterCell.h
//
//  Created by ToKoRo on 2012-09-06.
//  Last Change: 2012-09-06.
//

@protocol ParameterCellDelegate;

@interface ParameterCell : UITableViewCell

@property (weak) id<ParameterCellDelegate> delegate;
@property (copy) NSString *key;

- (void)updateCellWithDictionary:(NSDictionary*)dic;
- (void)updateValue:(id)value;

@end

#pragma mark - ParameterCellDelegate

@protocol ParameterCellDelegate
@required
- (void)parameterCell:(ParameterCell*)cell didChangeValue:(id)value forKey:(NSString*)key;
@end 
