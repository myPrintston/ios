//
//  MPSErrorViewController.m
//  myPrintston
//
//  Created by Michael J Kim on 4/6/14.
//
//

#import "MPSErrorViewController.h"

extern NSString *IP;
extern BOOL isAdmin;

@interface MPSErrorViewController () {
    NSMutableArray *possibleErrors;
    double keyboardHeight;
    UIGestureRecognizer *tap;
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
    
    // Initialize settings for the list of possible errors.
    self.errorList.delegate = self;
    self.errorList.dataSource = self;
    [self.errorList registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Error"];
    self.errorList.scrollEnabled = NO;
    self->possibleErrors = self.loadPossibleErrors;
    
    // Initialize settings for the textField and textView
    self.netid.delegate = self;
    self.comment.delegate = self;
    self.comment.enablesReturnKeyAutomatically = NO;
    
    // Initialize the style for the textView
    [self.comment.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.comment.layer setBorderWidth:2.0];
    self.comment.layer.cornerRadius = 1;
    self.comment.clipsToBounds = YES;
    
    // Set up the tap recognizer for when the user needs to dismiss the keyboard.
    tap = [[UITapGestureRecognizer alloc]
            initWithTarget:self action:@selector(dismissKeyboard)];
    
    // Register for KeyboardNotifications
    [self registerForKeyboardNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Query server and get the error types
- (NSMutableArray*) loadPossibleErrors
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/etypes/", IP]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    // If the server can't be reached, tell the user and stop loading.
    if (!data) {
        UIAlertView *alert;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Error"
                 message:@"Could not connect to the server"
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        return [[NSMutableArray alloc] init];
    }
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSMutableArray *urlerrors = [[NSMutableArray alloc] init];
    MPSErrorType *other;
    
    // Add the error types to the array. Pluck out the "other" error to ensure
    //   it's the last in the list.
    for (NSDictionary *errorInfo in jsonArray) {
        if (isAdmin || ![errorInfo[@"fields"][@"admin"] boolValue]) {
            MPSErrorType *error = [[MPSErrorType alloc] initWithDictionary:errorInfo];
            
            if ([errorInfo[@"fields"][@"eMsg"] isEqualToString:@"Other"])
                other = error;
            else
                [urlerrors addObject:error];
        }
    }
    
    // Put the "other" error at the end of the list.
    if (other)
        [urlerrors addObject:other];
    
    return urlerrors;
}

// Return the number of sections. In this case, there is always only 1 section.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// Return the number of rows in the section. This is the number of entries in the
//   errorList array.
- (NSInteger)tableView:(UITableView *)errorList numberOfRowsInSection:(NSInteger)section
{
    if (!self.errorList)
        self.errorList = errorList;
    
    // Return the number of rows in the section.
    return [self->possibleErrors count];
}

// Configure each error type cell.
- (UITableViewCell *)tableView:(UITableView *)errorList cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Error";
    
    MPSErrorType *currentError = [self->possibleErrors objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [errorList dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    // Name the cell with the error's name.
    cell.textLabel.text = currentError.eMsg;
    
    return cell;
}

// Method that checks or unchecks each cell on touch.
- (void)tableView:(UITableView *)errorList didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [errorList cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    [errorList deselectRowAtIndexPath:indexPath animated:NO];
}

// The method that gets called when the user hits the submit button.
- (IBAction)submit {
    
    UIAlertView *alert;
    NSMutableArray *errorids = [[NSMutableArray alloc] init];
    BOOL needComment = NO;
    
    // First go through the table and collect the errorids. Also check if any of
    //   the checked errors require a comment and note that.
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
    
    // Check the connection to the server.
    if (YES) {
        NSString *urlstring = [NSString stringWithFormat:@"%@/checklogin/", IP];
        NSURL *url = [NSURL URLWithString:urlstring];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        if (!data) {
            alert = [[UIAlertView alloc]
                     initWithTitle:@"Error"
                     message:@"Could not connect to the server"
                     delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        isAdmin = [jsonArray[0] boolValue];
    }
    
    // Send the user reported errors to the server
    if (YES) {
        // Prepare the JSON to send as NSData
        NSMutableDictionary *json = [self prepareJSON: errorids];
        NSError *error = NULL;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];

        // Send POST request
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL: [NSURL URLWithString:[NSString stringWithFormat:@"%@/error/", IP]]];
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
                     initWithTitle:@"Submission Failed"
                     message:message
                     delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
            [alert show];
            return;
        }
            
        // Create prompt that shows submission success
        alert = [[UIAlertView alloc]
                 initWithTitle:@"Submission Success!"
                 message:message
                 delegate:nil cancelButtonTitle:@"Got it"  otherButtonTitles:nil];
        [alert show];
        
        // Segue back to beginning
        [self performSegueWithIdentifier:@"Submitted" sender:nil];
    }
}

// Method that creates a JSON object with the current error ids.
- (NSMutableDictionary *) prepareJSON:(NSMutableArray*) errorids{
    NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
    
    json[@"printerid"]    =  [NSString stringWithFormat:@"%d", self.printer.printerid];
    json[@"netid"]        =  self.netid.text ? self.netid.text : @"";
    json[@"buildingName"] =  self.printer.building;
    json[@"roomNumber"]   =  self.printer.room;
    json[@"errMsg"]       =  self.comment.text ? self.comment.text : @"";
    json[@"errors"]       =  errorids;
    
    return json;
}

// Dismisses the keyboard when called.
-(void)dismissKeyboard {
    [self.netid resignFirstResponder];
    [self.comment resignFirstResponder];
}

// If the keyboard appears add the tap recognizer that would dismiss the keyboard.
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.view addGestureRecognizer:tap];
}

// If the keyboard appears add the tap recognizer that would dismiss the keyboard.
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view removeGestureRecognizer:tap];
}

// Dismiss the keyboard if the user hits the Return button.
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

// Dismiss the keyboard if the user hits the Return button.
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

// Make the keboard appear when the user starts editing.
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.view addGestureRecognizer:tap];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    
    self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, -keyboardHeight);
    [UIView commitAnimations];
}

// Make the keyboard disappear when the user is done editing.
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.view removeGestureRecognizer:tap];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.2];
    
    self.view.transform = CGAffineTransformTranslate(self.view.transform, 0, keyboardHeight);
    [UIView commitAnimations];
    
    [self.comment resignFirstResponder];
}

// Register for a notification when the keyboard will appear.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
        name:UIKeyboardWillShowNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent. Sets the keyboard's height
//   when it appears.
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    keyboardHeight = kbSize.height - 49;
}

@end
