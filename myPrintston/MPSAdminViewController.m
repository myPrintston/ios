//
//  MPSAdminViewController.m
//  myPrintston
//
//  Created by Michael J Kim on 5/6/14.
//
//

#import "MPSAdminViewController.h"

extern BOOL isAdmin;
extern NSString *IP;

@interface MPSAdminViewController ()

@end

@implementation MPSAdminViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

// Everytime this view appears, immediately redirect to either log in or log out view
//   based on whether the user is an admin or not.
- (void) viewDidAppear:(BOOL)animated
{
    UIAlertView *alert;
    
    // Direct the user to the log in view if the user is not logged in internally.
    if (!isAdmin) {
        [self performSegueWithIdentifier:@"LogIn" sender:nil];
        return;
    }
    
    // If the admin is logged in internally, make sure the session has not timed out.
    NSString *urlstring = [NSString stringWithFormat:@"%@/checklogin", IP];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // If there is no connection to the server tell the admin.
    if (!data) {
        isAdmin = NO;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Could not connect to the server. Logging out."
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        [self performSegueWithIdentifier:@"LogIn" sender:nil];
        return;
    }
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    // If the admin has timed out, tell the admin and tell the admin to log in again.
    if (![jsonArray[0] boolValue]) {
        isAdmin = NO;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Your admin session has timed out. Please log in again."
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        [self performSegueWithIdentifier:@"LogIn" sender:nil];
        return;
    }
    
    // If the user really is an admin, direct the admin to the log out view.
    [self performSegueWithIdentifier:@"LogOut" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
