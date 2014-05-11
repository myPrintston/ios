//
//  MPSMapNavController.m
//  myPrintston
//
//  Created by Michael J Kim on 4/20/14.
//
//

#import "MPSMapNavController.h"
#import "MPSMapViewController.h"

@interface MPSMapNavController ()

@end

@implementation MPSMapNavController

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
    
    MPSListViewController *controller = self.childViewControllers[0];
    controller.printerList = self.printerList;
    controller.locationManager = self.locationManager;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
