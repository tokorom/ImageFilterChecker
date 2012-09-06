//
//  SliderCell.m
//
//  Created by ToKoRo on 2012-09-05.
//  Last Change: 2012-09-07.
//

#import "SliderCell.h"

#pragma mark - Private Definition ------------------------------

@interface SliderCell ()
@property (weak) IBOutlet UILabel* valueLabel;
@property (weak) IBOutlet UISlider* slider;
@end 

#pragma mark - Main Implementation -----------------------------

@implementation SliderCell

#pragma mark - ParameterCell Override Methods

- (void)updateCellWithDictionary:(NSDictionary*)dic
{
  [super updateCellWithDictionary:dic];
  self.slider.minimumValue = [[dic objectForKey:@"min"] floatValue];
  self.slider.maximumValue = [[dic objectForKey:@"max"] floatValue];
  [self updateValue:[dic objectForKey:@"default"]];
}

- (void)updateValue:(NSNumber*)value
{
  self.slider.value = [value floatValue];
  self.valueLabel.text = [NSString stringWithFormat:@"%0.01f", [value floatValue]];
}

#pragma mark - Private Methods

- (IBAction)sliderDidChange:(UISlider*)slider
{
  [self updateValue:@(slider.value)];
  [self.delegate parameterCell:self didChangeValue:@(slider.value) forKey:self.key];
}

@end
