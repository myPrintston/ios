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
    // Do any additional setup after loading the view.
}

- (void) viewDidAppear:(BOOL)animated
{
    UIAlertView *alert;
    
    if (!isAdmin)
        [self performSegueWithIdentifier:@"LogIn" sender:nil];
        

    NSString *urlstring = [NSString stringWithFormat:@"%@/checklogin", IP];
    NSURL *url = [NSURL URLWithString:urlstring];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (!data) {
        isAdmin = NO;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Could not connect to the server. Logging out."
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        [self performSegueWithIdentifier:@"LogIn" sender:nil];
    }
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if (![jsonArray[0] boolValue]) {
        isAdmin = NO;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Your admin session has timed out. Please log in again."
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        [self performSegueWithIdentifier:@"LogIn" sender:nil];
    }
    
    [self performSegueWithIdentifier:@"LogOut" sender:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
