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
    BOOL isAdmin;
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
    
    self.errorList.delegate = self;
    self.errorList.dataSource = self;
    
    [self.errorList registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Error"];
    self.errorList.separatorColor = [UIColor clearColor];
    self.errorList.separatorStyle = UITableViewCellSeparatorStyleNone;
    self->possibleErrors = self.loadPossibleErrors;
    self.netid.delegate = self;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
//                                   initWithTarget:self
//                                   action:@selector(dismissKeyboard)];
//    
//    [self.view addGestureRecognizer:tap];

    [self.comment.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.comment.layer setBorderWidth:2.0];
    self.comment.layer.cornerRadius = 1;
    self.comment.clipsToBounds = YES;
    
    isAdmin = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Query server and get the error types
- (NSMutableArray*) loadPossibleErrors
{
    NSURL *url = [NSURL URLWithString:@"http://54.186.188.121:2016/etypes/"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSMutableArray *urlerrors = [[NSMutableArray alloc] init];
    isAdmin = YES;
    for (NSDictionary *errorInfo in jsonArray) {
        if (isAdmin || ![errorInfo[@"fields"][@"Admin"] boolValue]) {
            MPSErrorType *error = [[MPSErrorType alloc] initWithDictionary:errorInfo];
            [urlerrors addObject:error];
        }
    }
    
    return urlerrors;
}

// Number of sections of errors = 1
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
    
    MPSErrorType *currentError = [self->possibleErrors objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [errorList dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = currentError.eMsg;
    
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
    UIAlertView *alert;
    NSMutableArray *errorids = [[NSMutableArray alloc] init];
    BOOL needComment = NO;
    
    
    for (int i = 0; i < [possibleErrors count]; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.errorList cellForRowAtIndexPath:path];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            [errorids addObject:[NSNumber numberWithInt:[self->possibleErrors[i] errorid]]];
            if ([[possibleErrors[i] eType] isEqualToString:@"text"])
                needComment = YES;
        }
    }
    
    
    // Message prompt if no errors are selected
    if ([errorids count] == 0) {
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Submission Failed"
                 message:@"You must select at least one error."
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    // Message prompt if user needs to input a message
    if (needComment && ([self.comment.text length] == 0)) {
        if ([errorids count] == 1) {
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Submission Failed"
                     message:@"The error you selected requires a comment"
                     delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
            [alert show];
        } else {
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Submission Failed"
                     message:@"One of the errors you selected requires a comment"
                     delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
            [alert show];
        }
        return;
    }
    
    
    if (YES) {
        // Prepare the JSON to send as NSData
        NSMutableDictionary *json = [self prepareJSON: errorids];
        NSError *error = NULL;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];

        // Send POST request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL: [NSURL URLWithString:@"http://54.186.188.121:2016/error/"]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]] forHTTPHeaderField:@"Content-Length"];
        
        NSURLResponse *urlResponse;
        NSError *connectionError = nil;
        NSData *result = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&connectionError];
        
        NSString *message = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        
        // If there's a rejection from the server side, let the user know.
        if (![message isEqualToString:@"Thank you for your report!"]) {
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Submission Success!"
                     message:message
                     delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
            [alert show];
            return;
        }
            
        // Create prompt that shows submission success
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Submission Failed"
                 message:message
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        
        // Segue back to beginning
        [self performSegueWithIdentifier:@"Submitted" sender:nil];
    }
}

- (NSMutableDictionary *) prepareJSON:(NSMutableArray*) errorids{
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    
    json[@"printerid"]    =  [NSString stringWithFormat:@"%d", self.printer.printerid];
    json[@"netid"]        =  self.netid.text;
    json[@"buildingName"] =  self.printer.building;
    json[@"roomNumber"]   =  self.printer.room;
    json[@"errMsg"]       =  self.comment.text;
    json[@"errors"]       =  errorids;
    
    return json;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
/*

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}
*/
 
//-(void)dismissKeyboard {
//    [self.netid resignFirstResponder];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
}

@end
