//
//  MPSLogOutViewController.m
//  myPrintston
//
//  Created by Michael J Kim on 5/6/14.
//
//

#import "MPSLogOutViewController.h"

extern BOOL isAdmin;
extern NSString *IP;

@interface MPSLogOutViewController ()

@end

@implementation MPSLogOutViewController

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
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    if (!isAdmin)
        [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)logout {
    isAdmin = NO;
    UIAlertView *alert;
    
    // Create prompt that shows submission success
    alert = [[UIAlertView alloc]
             initWithTitle:@"Logout Success!"
             message:@"You have successfully logged out!"
             delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
    [alert show];
    
    [self performSegueWithIdentifier:@"logout" sender:nil];
}

@end
