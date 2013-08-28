//
//  ConfigViewController.m
//  ToDoLite
//
//  Created by Jens Alfke on 8/8/11.
//  Copyright 2011-2013 Couchbase, Inc. All rights reserved.
//

#import "ConfigViewController.h"
#import "AppDelegate.h"


// This symbol comes from ToDoLite_vers.c, generated by the versioning system.
extern double ToDoLiteVersionNumber;


@implementation ConfigViewController
{
    NSURL* _syncURL;
}


- (instancetype) initWithURL: (NSURL*)syncURL {
    self = [super initWithNibName: @"ConfigViewController" bundle: nil];
    if (self) {
        _syncURL = syncURL;

        self.navigationItem.title = @"Configure Sync";

        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done"
                                                                style:UIBarButtonItemStyleDone
                                                               target: self 
                                                               action: @selector(done:)];
        self.navigationItem.leftBarButtonItem = doneButton;
    }
    return self;
}


#pragma mark - View lifecycle


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.urlField.text = _syncURL.absoluteString;
    self.versionField.text = [NSString stringWithFormat: @"this is build #%.0lf",
                              ToDoLiteVersionNumber];
}


- (IBAction)learnMore:(id)sender {
    static NSString* const kLearnMoreURLs[] = {
        // TODO
    };
    NSURL* url = [NSURL URLWithString: kLearnMoreURLs[[sender tag]]];
    [[UIApplication sharedApplication] openURL: url];
}


- (void)pop {
    
    UINavigationController* navController = (UINavigationController*)self.parentViewController;
    [navController popViewControllerAnimated: YES];
}


- (IBAction)done:(id)sender {
    NSString* remoteURLStr = self.urlField.text;
    if (remoteURLStr.length > 0) {
        NSURL *remoteURL = [NSURL URLWithString:remoteURLStr];
        if (!remoteURL || ![remoteURL.scheme hasPrefix: @"http"]) {
            // Oops, not a valid URL:
            NSString* message = @"You entered an invalid URL. Do you want to fix it or revert back to what it was before?";
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Invalid URL"
                                                            message: message
                                                           delegate: self
                                                  cancelButtonTitle: @"Fix It"
                                                  otherButtonTitles: @"Revert", nil];
            [alert show];
            return;
        }
        
        // If user just enters the server URL, fill in a default database name:
        if ([remoteURL.path isEqual: @""] || [remoteURL.path isEqual: @"/"]) {
            remoteURL = [remoteURL URLByAppendingPathComponent: @"todo"];
        }

        // Tell the app delegate to sync with the new URL:
        gAppDelegate.syncURL = remoteURL;
    }

    [self pop];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex > 0) {
        [self pop]; // Go back to the main screen without saving the URL
    }
}


@end
