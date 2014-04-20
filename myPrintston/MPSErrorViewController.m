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
    
    isAdmin = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray*) loadPossibleErrors
{
    NSURL *url = [NSURL URLWithString:@"http://54.186.188.121:2016/etypes"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    NSMutableArray *urlerrors = [[NSMutableArray alloc] init];
    for (NSDictionary *errorInfo in jsonArray) {
        if (isAdmin || errorInfo[@"fields"][@"Admin"]) {
            MPSErrorType *error = [[MPSErrorType alloc] initWithDictionary:errorInfo];
            [urlerrors addObject:error];
        }
    }
    
    return urlerrors;
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
    NSMutableArray *errorids = [[NSMutableArray alloc] init];
    BOOL needComment = NO;
    
    
    for (int i = 0; i < [possibleErrors count]; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        UITableViewCell *cell = [self.errorList cellForRowAtIndexPath:path];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            [errorids addObject:[NSNumber numberWithInt:[[self->possibleErrors objectAtIndex:i] errorid]]];
            if ([[[possibleErrors objectAtIndex:i] eType] isEqualToString:@"text"])
                needComment = YES;
        }
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if ([errorids count] > 0 && ( !needComment || [self.comment.text length] > 0)) {
        // Create the JSON to send
        NSMutableDictionary *json = [[NSMutableDictionary alloc] init];
        [json setValue:[NSString stringWithFormat:@"%d", self.printer.printerid] forKey:@"printerid"];
        [json setValue:self.netid.text forKey:@"netid" ];
        [json setValue:self.printer.building forKey:@"buildingName"];
        [json setValue:self.printer.room forKey:@"roomNumber"];
        [json setValue:self.comment.text forKey:@"errMsg"];
        [json setObject:errorids forKey:@"errors"];

        NSError *error = NULL;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];

        NSLog(@"%@", json);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL: [NSURL URLWithString:@"http://54.186.188.121:2016/error"]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:jsonData];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [jsonData length]] forHTTPHeaderField:@"Content-Length"];
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        
        if(!conn)
            NSLog(@"Connection could not be made");
        
        self.netid.text = @"";
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//-(void)dismissKeyboard {
//    [self.netid resignFirstResponder];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    
    NSLog(@"%@", self.view);
    NSLog(@"%@", [touch view]);
    
    if (![[touch view] isKindOfClass:[UITextField class]]) {
        [self.view endEditing:YES];
    }
}

@end
