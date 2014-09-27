//
//  ViewController.m
//  PropertyListCategoryExample
//
//  Created by Michael Thongvanh on 9/27/14.
//  Copyright (c) 2014 Chisel Apps. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+PropertyList.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *saveStatusLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSString *nameOfPropertyListFile = @"FavoriteWords";
    
    
     // Example: Save a collection as a property list
    NSDictionary *testDictionary = @{@"myFavoriteWords":@[@"bungalow",@"antediluvian",@"uncowed",@"debelo"]};
    
    if ([self saveCollection:testDictionary asPropertyList:nameOfPropertyListFile andSkipBackup:NO]) {
        self.saveStatusLabel.text = @"successful save";
    } else {
        self.saveStatusLabel.text = @"did not save";
    }
    
    
    /*
     // Example: Loading a collection from a property list
    id object = [self objectFromPropertyList:nameOfPropertyListFile inDocumentsRoot:NO];
    if (object) {
        self.saveStatusLabel.text = [NSString stringWithFormat:@"Test Loading Property List #1: %@",object];
    }
    */
    
    /*
     // Example: Loading a collection from a property list in a specific Documents sub-folder
    id object2 = [self objectFromPropertyList:nameOfPropertyListFile inFolder:@"Non-Existant Folder"];
    if (object2) {
        self.saveStatusLabel.text = [NSString stringWithFormat:@"Test Loading Property List #2: %@",object2];
    } else {
        self.saveStatusLabel.text = @"object is nil, so there was an error. check the debugger console.";
    }
    */

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
