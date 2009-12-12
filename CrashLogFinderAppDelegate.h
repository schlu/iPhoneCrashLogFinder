//
//  CrashLogFinderAppDelegate.h
//  CrashLogFinder
//
//  Created by Nicholas Schlueter on 11/30/09.
//  Copyright 2009 Ridecharge. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface CrashLogFinderAppDelegate : NSObject  {
  NSWindow *window;
  NSMutableArray *crashLogs;
  NSMutableArray *displayedCrashLogs;
  NSTableView *table;
  NSString *searchString;
  NSString *zippingFile;
}

-(IBAction)updateFilter:sender;
-(IBAction)zipFiles:sender;
-(void)updateDisplayedCrashLogs;


@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) NSMutableArray *crashLogs;
@property (nonatomic, retain) NSMutableArray *displayedCrashLogs;
@property (assign) IBOutlet NSTableView *table;
@property (nonatomic, retain) NSString *searchString;
@property (nonatomic, retain) NSString *zippingFile;

@end
