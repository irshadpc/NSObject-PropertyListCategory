//
//  NSObject+PropertyList.h
//  Helper Category for Property Lists
//
//  Created by Michael Thongvanh on 9/26/14.
//  Copyright (c) 2014 Chisel Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PropertyList)
/**
 @description Reads a property list contained in a folder from disk and parses it into a NSDictionary
 @param propertyListName The property list's filename without the file extension (.plist). This cannot be nil.
 @param checkInDocumentsRootFolder YES marks that it should look in the /Documents root folder and NO marks that it will look in a folder with the same name as the propertyListName
 @return An object created from a property list, or nil if the bundle does not contain a file matching the propertyListName parameter
 @see objectFromPropertyList:
 */
-(id)objectFromPropertyList:(NSString*)propertyListName inDocumentsRoot:(BOOL)checkInDocumentsRootFolder;

/**
 @description Reads a property list contained in a folder from disk and parses it into a NSDictionary.
 @param propertyListName The property list's filename without the file extension (.plist). This cannot be nil.
 @param folderName The folder in which to search for the property list.
 @return An object created from a property list, or nil if the bundle does not contain a file matching the propertyListName parameter.
 @see objectFromPropertyList:inDocumentsRoot:
 */
-(id)objectFromPropertyList:(NSString*)propertyListName inFolder:(NSString *)folderName;

/**
 @description Creates a folder that contains a property list in the Documents folder
 @param dictionary A dictionary containing the keys and values to be written to the property list
 @param propertyListToSave This parameter will serve as its filename. Do not add the extension (.plist) to the name.
 @param shouldSkipBackup Skip the folder when backing up to iTunes or iCloud.
 @return YES if it has successfully saved the data to the property list
 */
-(BOOL)saveCollection:(id)collection asPropertyList:(NSString*)propertyListToSave andSkipBackup:(BOOL)shouldSkipBackup;

@end
