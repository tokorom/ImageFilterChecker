//
//  SliderCell.h
//
//  Created by ToKoRo on 2012-09-05.
//  Last Change: 2012-09-05.
//

@protocol SliderCellDelegate;

@interface SliderCell : UITableViewCell

@property (weak) id<SliderCellDelegate> delegate;
@property (copy) NSString *key;
@property (readonly) UISlider *slider;
@property (readonly) UILabel *label;
@property (readonly) UILabel *valueLabel;

- (void)updateValue:(CGFloat)value;

@end

#pragma mark - SliderCellDelegate

@protocol SliderCellDelegate
@required
- (void)sliderCell:(SliderCell*)cell didChangeValue:(NSNumber*)value forKey:(NSString*)key;
@end 
