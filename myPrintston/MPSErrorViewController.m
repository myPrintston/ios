//
//  MPSErrorViewController.m
//  myPrintston
//
//  Created by Michael J Kim on 4/6/14.
//
//

#import "MPSErrorViewController.h"

@interface MPSErrorViewController () {
    NSMutableArray *possibleErrors;
}


@end

@implementation MPSErrorViewController

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
    
    [self.errorList registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Error"];
    self.errorList.separatorColor = [UIColor clearColor];
    self.errorList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self->possibleErrors = self.loadPossibleErrors;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray*) loadPossibleErrors
{
    NSString *error1 = @"INK";
    NSString *error2 = @"TONER";
    NSString *error3 = @"PAPER";
    return [NSMutableArray arrayWithObjects:error1, error2, error3, nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)errorList numberOfRowsInSection:(NSInteger)section
{
    if (!self.errorList)
        self.errorList = errorList;
    
    // Return the number of rows in the section.
    return [self->possibleErrors count];
}

- (UITableViewCell *)tableView:(UITableView *)errorList cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    static NSString *CellIdentifier = @"Error";
    
    NSString *currentError = [self->possibleErrors objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [errorList dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = currentError;
    
    return cell;
}

- (void)tableView:(UITableView *)errorList didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [errorList cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    [errorList deselectRowAtIndexPath:indexPath animated:NO];
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


- (IBAction)submit {
    for (int i = 0; i < [possibleErrors count]; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.errorList cellForRowAtIndexPath:path];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (cell == nil)
            NSLog(@"hi");
    }
    
    NSString *post = [NSString stringWithFormat:@"&Username=%@&Password=%@",@"username",@"password"];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://54.186.188.121:2016/?fromios"]]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    if(conn)
        NSLog(@"Connection Successful");
    else
        NSLog(@"Connection could not be made");
    
    
    
}

@end
