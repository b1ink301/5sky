#import "SkyMessage.h"

@implementation SkyMessage

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        _text = [aDecoder decodeObjectOfClass:NSString.class forKey:@"Text"];
        _name = [aDecoder decodeObjectOfClass:NSString.class forKey:@"Name"];
        _iconUrl = [aDecoder decodeObjectOfClass:NSString.class forKey:@"URL"];
        _outgoing = [[aDecoder decodeObjectOfClass:NSNumber.class forKey:@"Outgoing"]boolValue];
        _media = [aDecoder decodeObjectOfClasses:[NSSet setWithObjects:UIImage.class, NSURL.class, nil] forKey:@"Media"];
        _timestamp = [aDecoder decodeObjectOfClass:NSDate.class forKey:@"Timestamp"];
        _height = -1;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_text forKey:@"Text"];
    [aCoder encodeObject:_name forKey:@"Name"];
    [aCoder encodeObject:_iconUrl forKey:@"URL"];
    [aCoder encodeObject:@(_outgoing) forKey:@"Outgoing"];
    [aCoder encodeObject:_media forKey:@"Media"];
    [aCoder encodeObject:_timestamp forKey:@"Timestamp"];
}

+ (BOOL)supportsSecureCoding
{
    return YES;
}

@end
