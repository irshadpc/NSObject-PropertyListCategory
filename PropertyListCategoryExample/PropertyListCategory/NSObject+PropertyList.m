//
//  NSObject+PropertyList.m
//  Helper Category for Property Lists
//
//  Created by Michael Thongvanh on 9/26/14.
//  Copyright (c) 2014 Chisel Apps. All rights reserved.
//

#import "NSObject+PropertyList.h"
#import <UIKit/UIDevice.h>


@implementation NSObject (PropertyList)

- (id)objectFromPropertyList:(NSString *)propertyListName inDocumentsRoot:(BOOL)checkInDocumentsRootFolder {
    if (checkInDocumentsRootFolder) {
        return [self objectFromPropertyList:propertyListName inFolder:nil];
    } else {
        return [self objectFromPropertyList:propertyListName inFolder:propertyListName];
    }
}

- (id)objectFromPropertyList:(NSString*)propertyListName inFolder:(NSString *)folderName {
    if (propertyListName.length == 0) {
        NSLog(@"\n[NSObject+PropertyList objectFromPropertyList:inFolder:] Error creating property list data from disk: propertyListName cannot be an empty string");
        return nil;
    } else if ([propertyListName characterAtIndex:0] == 32 || [propertyListName characterAtIndex:(propertyListName.length-1)] == 32) {
        NSLog(@"\n[NSObject+PropertyList objectFromPropertyList:inFolder:] Error creating property list data from disk: propertyListName cannot start or end with a space");
        return nil;
    } else if ([folderName characterAtIndex:0] == 32 || [folderName characterAtIndex:(folderName.length-1)] == 32) {
        NSLog(@"\n[NSObject+PropertyList objectFromPropertyList:inFolder:] Error creating property list data from disk: folderName cannot start or end with a space");
        return nil;
    }
    
    NSError *errorDescription = nil;
    NSPropertyListFormat format;
    
    NSString *filenameWithExtension = [NSString stringWithFormat:@"%@.plist",propertyListName];
    
    NSString *rootPath = [self documentsSaveDirectory];
    rootPath = folderName.length > 0 ? [rootPath stringByAppendingPathComponent:folderName] : rootPath;
    
    NSString *plistPath = [rootPath stringByAppendingPathComponent:filenameWithExtension];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:propertyListName ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    if (!plistXML) {
        NSLog(@"\n[NSObject+PropertyList objectFromPropertyList:inFolder:] Error creating property list data from disk: [NSFileManager contentsAtPath:] is nil");
        return nil;
    }
    
    id temp = [NSPropertyListSerialization propertyListWithData:plistXML
                                                        options:NSPropertyListMutableContainersAndLeaves
                                                         format:&format
                                                          error:&errorDescription];
    if (!temp) {
        NSLog(@"\n[NSObject+PropertyList objectFromPropertyList:inFolder:] Error reading plist: %@, format: %lu", errorDescription, format);
    }
    
    return temp;
}

- (BOOL)saveCollection:(id)collection asPropertyList:(NSString *)propertyListToSave andSkipBackup:(BOOL)shouldSkipBackup {
    NSError *error = nil;
    NSString *errorDescription = nil;
    
    NSString *rootSavePath = [self documentsSaveDirectory];
    rootSavePath = [rootSavePath stringByAppendingPathComponent:propertyListToSave];
    [self createDirectory:rootSavePath andSkipBackup:shouldSkipBackup];
    
    NSString *filenameWithExtension = [NSString stringWithFormat:@"%@.plist",propertyListToSave];
    
    NSString *propertyListPath = [rootSavePath stringByAppendingPathComponent:filenameWithExtension];
    NSData *propertyListData;
    
    // enable support for iOS 7 and below
    if ([self iOS8orAbove]) {
        propertyListData = [NSPropertyListSerialization dataWithPropertyList:collection format:NSPropertyListXMLFormat_v1_0 options:NSPropertyListMutableContainersAndLeaves error:&error];
    } else {
        propertyListData = [NSPropertyListSerialization dataFromPropertyList:collection format:NSPropertyListXMLFormat_v1_0 errorDescription:&errorDescription];
    }
    
    if (propertyListData) {
        [propertyListData writeToFile:propertyListPath atomically:YES];
        return YES;
    } else {
        NSString *errorMessage = errorDescription ? errorDescription : error.localizedDescription;
        NSLog(@"\n[NSObject+PropertyList saveCollection:asPropertyList:] Error %@", errorMessage);
        return NO;
    }
}

- (void)createDirectory:(NSString*)directorySavePath andSkipBackup:(BOOL)shouldSkipBackup {
    NSError *error = nil;
    BOOL directoryExists = [[NSFileManager defaultManager] fileExistsAtPath:directorySavePath];
    if (!directoryExists) {
        if ([[NSFileManager defaultManager] createDirectoryAtPath:directorySavePath withIntermediateDirectories:NO attributes:nil error:&error]) {
            NSURL *directorySavePathUrl = [NSURL fileURLWithPath:directorySavePath];
            if (shouldSkipBackup) {
                if(![directorySavePathUrl setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:&error]){
                    NSLog(@"[NSObject+PropertyList createDirectory:andSkipBackup:] Error excluding %@ from backup %@", [directorySavePathUrl lastPathComponent], error);
                }
            }
        } else {
            NSLog(@"\n[NSObject+PropertyList createDirectory:andSkipBackup:] Error creating directory at path: %@", error);
        }
    } else {
        NSLog(@"[NSObject+PropertyList createDirectory:andSkipBackup:] Did not create directory: Directory already exists");
    }
}

- (BOOL)iOS8orAbove {
    NSString *currentVersion = [[UIDevice currentDevice] systemVersion];
    NSComparisonResult result = [currentVersion compare:@"8.0" options:0];
    if (result == NSOrderedDescending || result == NSOrderedSame) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString*)documentsSaveDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}


@end
