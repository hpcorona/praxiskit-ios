//
//  UIPlaceHolderTextView.h
//  PraxisKit
//
//  Created by Hilario Perez Corona on 7/28/12.
//
//

#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>


@interface UIPlaceHolderTextView : UITextView {
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;

@end
