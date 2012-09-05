//
//  SliderCell.m
//
//  Created by ToKoRo on 2012-09-05.
//  Last Change: 2012-09-05.
//

#import "SliderCell.h"

#pragma mark - Private Definition ------------------------------

@interface SliderCell ()
@property (weak) IBOutlet UILabel *label;
@property (weak) IBOutlet UILabel *valueLabel;
@property (weak) IBOutlet UISlider *slider;
@end 

#pragma mark - Main Implementation -----------------------------

@implementation SliderCell

#pragma mark - Public Interface

- (void)updateValue:(CGFloat)value
{
  self.slider.value = value;
  self.valueLabel.text = [NSString stringWithFormat:@"%0.01f", value];
}

#pragma mark - Private Methods

- (IBAction)sliderDidChange:(UISlider*)slider
{
  [self updateValue:slider.value];
  [self.delegate sliderCell:self didChangeValue:@(slider.value) forKey:self.key];
}

@end
