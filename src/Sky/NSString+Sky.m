#import "NSString+Sky.h"

@implementation NSString (Sky)

- (CGSize)messageTextSizeWithWidth:(CGFloat)width fontSize:(CGFloat)fontSize
{
    
//    CGSize textSize;
//    textSize = [self sizeWithFont:[UIFont systemFontOfSize:fontSize]constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)];
//    
//    return textSize;
    
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]} context:nil];
    
    return CGSizeMake(rect.size.width, rect.size.height);
}

- (CGSize)messageBackgroundSizeWithWidth:(CGFloat)width fontSize:(CGFloat)fontSize
{
    CGSize textSize = [self messageTextSizeWithWidth:width fontSize:fontSize];
    CGSize backgroundSize = CGSizeMake(textSize.width + 35, textSize.height + 12);
    return backgroundSize;
}

- (CGFloat)messageCellHeightWithWidth:(CGFloat)width fontSize:(CGFloat)fontSize
{
    CGSize backgroundSize = [self messageBackgroundSizeWithWidth:width fontSize:fontSize];
    CGFloat cellHeight = backgroundSize.height + 4;
    return cellHeight;
}

@end
