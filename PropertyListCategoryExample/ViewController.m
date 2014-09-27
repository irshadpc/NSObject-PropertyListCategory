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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    /*
    NSDictionary *testDictionary = @{@"password":@"michael"};
    
    if ([self saveDictionary:testDictionary asPropertyList:@"Password"]) {
        NSLog(@"successful save");
    } else {
        NSLog(@"did not save");
    }
     */
    
    id object = [self objectFromPropertyList:@"Password" inDocumentsRoot:NO];
    if (object) {
        NSLog(@"%@",object);
    }
    
    id object2 = [self objectFromPropertyList:@"Password" inFolder:@"Password"];
    if (object2) {
        NSLog(@"%@",object2);
    } else {
        NSLog(@"see error");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
