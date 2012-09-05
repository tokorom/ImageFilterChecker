//
//  CIColorControlsViewController.m
//
//  Created by ToKoRo on 2012-09-05.
//  Last Change: 2012-09-05.
//

#import "CIColorControlsViewController.h"
#import "SliderCell.h"

#pragma mark - Private Definition ------------------------------

@interface CIColorControlsViewController () <SliderCellDelegate>
@end 

#pragma mark - Main Implementation -----------------------------

@implementation CIColorControlsViewController

#pragma mark - FilterViewController Override Methods

- (void)setupDataSource
{
  self.dataSource = @[
    @{@"key": @"inputSaturation", @"cell": @"SliderCell", @"label": @"Saturation", @"min": @0, @"max": @2, @"default": @1},
    @{@"key": @"inputBrightness", @"cell": @"SliderCell", @"label": @"Brightness", @"min": @-1, @"max": @1, @"default": @0},
    @{@"key": @"inputContrast", @"cell": @"SliderCell", @"label": @"Contrast", @"min": @0, @"max": @4, @"default": @1},
  ];
}

- (void)updateCell:(SliderCell*)cell withDictionary:(NSDictionary*)dic
{
  cell.delegate = self;
  cell.key = [dic objectForKey:@"key"];
  cell.slider.minimumValue = [[dic objectForKey:@"min"] floatValue];
  cell.slider.maximumValue = [[dic objectForKey:@"max"] floatValue];
  cell.label.text = [dic objectForKey:@"label"];
  [cell updateValue:[[dic objectForKey:@"default"] floatValue]];
}

#pragma mark - SliderCellDelegate

- (void)sliderCell:(SliderCell*)cell didChangeValue:(NSNumber*)value forKey:(NSString*)key
{
  [self.values setObject:value forKey:key];
  [self executeFiltering];
}

@end
