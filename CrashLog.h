#import <Cocoa/Cocoa.h>


@interface CrashLog : NSObject {
  NSString *application;
  NSString *filePath;
  NSString *fileName;
  NSDate *date;
}

@property (nonatomic, retain) NSString *application;
@property (nonatomic, retain) NSString *filePath;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, retain) NSDate *date;

@end
