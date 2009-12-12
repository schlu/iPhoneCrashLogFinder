#import "CrashLogFinderAppDelegate.h"
#import "CrashLog.h"

@implementation CrashLogFinderAppDelegate

@synthesize window;
@synthesize crashLogs;
@synthesize displayedCrashLogs;
@synthesize table;
@synthesize searchString;
@synthesize zippingFile;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskFinished:) name:NSTaskDidTerminateNotification object:nil];
  [self setSearchString:@""];
  [self setCrashLogs:[[[NSMutableArray alloc] init] autorelease]];
  [self setDisplayedCrashLogs:[[[NSMutableArray alloc] init] autorelease]];
  BOOL isDir=YES;
  NSArray *subpaths;
  NSString *crashLogPath = [@"~/Library/Logs/CrashReporter/MobileDevice/" stringByExpandingTildeInPath];
  NSFileManager *fileManager = [NSFileManager defaultManager];
  if ([fileManager fileExistsAtPath:crashLogPath isDirectory:&isDir] && isDir) {
    subpaths = [fileManager contentsOfDirectoryAtPath:crashLogPath error:nil];
    for (NSString *path in subpaths) {
      NSString *deviceCrashLogPath = [crashLogPath stringByAppendingPathComponent:path];
      if ([fileManager fileExistsAtPath:deviceCrashLogPath isDirectory:&isDir]) {
        if ([path rangeOfString:@"symbolicated"].location == NSNotFound && [path rangeOfString:@".DS_Store"].location == NSNotFound) {
          for (NSString *crashFile in [fileManager contentsOfDirectoryAtPath:deviceCrashLogPath error:nil]) {
            if([crashFile rangeOfString:@".crash"].location != NSNotFound) {
              CrashLog *crashLog = [[[CrashLog alloc] init] autorelease];
              [crashLog setFilePath:[deviceCrashLogPath stringByAppendingPathComponent:crashFile]];
              NSDictionary *attributes = [fileManager attributesOfItemAtPath:[crashLog filePath] error:nil];
              if([crashFile rangeOfString:@"_20"].location != NSNotFound) {
                [crashLog setApplication:[crashFile substringToIndex:([crashFile rangeOfString:@"_20"].location)]];
              } else if ([crashFile rangeOfString:@"-20"].location != NSNotFound) {
                [crashLog setApplication:[crashFile substringToIndex:([crashFile rangeOfString:@"-20"].location)]];
              } else {
                continue;
              }
              [crashLog setFileName:crashFile];

              [crashLog setDate:[attributes objectForKey:NSFileModificationDate]];
              [crashLogs addObject:crashLog];
            }
          }
        }
      }
    }
  }
  [self updateDisplayedCrashLogs];
	// Insert code here to initialize your application 
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView {
  return [displayedCrashLogs count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex {
  if ([@"application" isEqualToString:[tableColumn identifier]]) {
    return [(CrashLog *)[displayedCrashLogs objectAtIndex:rowIndex] application];
  } else {
    return [[(CrashLog *)[displayedCrashLogs objectAtIndex:rowIndex] date] description];
  }

}

-(void)updateDisplayedCrashLogs {
  [displayedCrashLogs removeAllObjects];
  for (CrashLog *crashLog in crashLogs) {
    if ([searchString isEqualToString:@""] || [[crashLog application] rangeOfString:searchString].location != NSNotFound) {
      [displayedCrashLogs addObject:crashLog];
    }
  }
  [table reloadData];
}

- (IBAction)updateFilter:sender {
  [self setSearchString: [sender stringValue]];
  [self updateDisplayedCrashLogs];
}

-(IBAction)zipFiles:sender {
  if ([displayedCrashLogs count] > 0) {
    BOOL isDir=YES;
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [formatter setDateFormat:@"yyyyMMddHHmm"];
    NSString *zipDirectory = [@"~/Documents" stringByExpandingTildeInPath];
    NSString *directoryName = [@"CrashLogs" stringByAppendingString:[formatter stringFromDate:[NSDate date]]];
    zipDirectory = [zipDirectory stringByAppendingPathComponent:directoryName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:zipDirectory isDirectory:&isDir]) {
      [fileManager removeItemAtPath:zipDirectory error:nil];
    }
    [fileManager createDirectoryAtPath:zipDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    for (CrashLog *crashLog in displayedCrashLogs) {
      [fileManager copyItemAtPath:[crashLog filePath] toPath:[zipDirectory stringByAppendingPathComponent:[crashLog fileName]] error:nil];
    }
    [self setZippingFile:[zipDirectory stringByAppendingPathExtension:@"zip"]];
    NSTask *zipTask = [[NSTask alloc] init];
    [zipTask setArguments:[NSArray arrayWithObjects:@"-r", zippingFile, directoryName, nil]];
    [zipTask setCurrentDirectoryPath:[@"~/Documents" stringByExpandingTildeInPath]];
    [zipTask setLaunchPath:@"/usr/bin/zip"];
    [zipTask launch];
    [zipTask release];
  }
}

-(void)taskFinished:(NSNotification *)notification {
  [[NSWorkspace sharedWorkspace] selectFile:zippingFile inFileViewerRootedAtPath:nil];
}

@end

