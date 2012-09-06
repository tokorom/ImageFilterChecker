//
//  ParameterCell.m
//
//  Created by ToKoRo on 2012-09-06.
//  Last Change: 2012-09-07.
//

#import "ParameterCell.h"

#pragma mark - Private Definition ------------------------------

@interface ParameterCell ()
@property (weak) IBOutlet UILabel *nameLabel;
@end 

#pragma mark - Main Implementation -----------------------------

@implementation ParameterCell

#pragma mark - Override Methods

- (void)updateCellWithDictionary:(NSDictionary*)dic
{
  self.key = [dic objectForKey:@"parameterName"];
  self.nameLabel.text = [dic objectForKey:@"labelName"];
}

- (void)updateValue:(id)value
{
}

@end
