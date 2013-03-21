//
//  AppDelegate.m
//  EasyMappingCoreDataExample
//
//  Created by Alejandro Isaza on 2013-03-14.
//
//

#import "AppDelegate.h"
#import "Car.h"
#import "EKManagedObjectMapper.h"
#import "MappingProvider.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [MagicalRecord cleanUp];
}

@end
