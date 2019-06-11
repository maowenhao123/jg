#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    UILabelCountingMethodEaseInOut,
    UILabelCountingMethodEaseIn,
    UILabelCountingMethodEaseOut,
    UILabelCountingMethodLinear
} UILabelCountingMethod;

typedef NSString* (^UICountingLabelFormatBlock)(float value);


@interface UICountingLabel : UILabel

@property (nonatomic, strong) NSString *format;
@property (nonatomic, strong) NSDictionary *attDict;//属性字典
@property (nonatomic, assign) UILabelCountingMethod method;

@property (nonatomic, copy) UICountingLabelFormatBlock formatBlock;
@property (nonatomic, copy) void (^completionBlock)();


//-(void)countFrom:(float)startValue to:(float)endValue;
//-(void)countFrom:(float)startValue to:(float)endValue withDuration:(NSTimeInterval)duration;

-(void)countFrom:(float)startValue to:(float)endValue attDict:(NSDictionary *)attDict withPrefix:(NSString *)prefix withDuration:(NSTimeInterval)duration;
@end

