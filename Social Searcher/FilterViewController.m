//
//  FilterViewController.m
//  Social Searcher
//
//  Created by Tasvir H Rohila on 03/09/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@property BOOL fromDateSelected;
@property BOOL pickerVisible;
@property (weak, nonatomic) IBOutlet UIToolbar *datePickerToolbar;

@end

@implementation FilterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _pickerVisible = NO;
    if (_isFilterON) {
        [_filterSwitch setOn:YES animated:YES];
        
        if(![_strStartDate isEqualToString:@""]) {
            [_fromDateSwitch setEnabled:YES];
            [_fromDateSwitch setOn:YES animated:YES];
            self.fromDateLabel.text = _strStartDate;
        }
            if(![_strEndDate isEqualToString:@""]) {
                [_toDateSwitch setEnabled:YES];
                [_toDateSwitch setOn:YES animated:YES];
                self.toDateLabel.text = _strEndDate;
            }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backbuttonTapped:(id)sender {
    [self.filterDelegate didSetFilter:[_filterSwitch isOn] startDate:_fromDateLabel.text endDate:_toDateLabel.text];
}

- (IBAction)switchStateChanges:(id)sender {
    
    NSLog(@"switchState sender: %@",sender);
    switch ([sender tag])
    {
        //Filter switch
        case 0:
            if ([sender isOn]) {
                [_fromDateSwitch setEnabled:YES];
                [_toDateSwitch setEnabled:YES];
            }
            else {
                [_fromDateSwitch setEnabled:NO];
                [_fromDateSwitch setOn:NO animated:YES];
                _fromDateLabel.text = @"";
                [_toDateSwitch setEnabled:NO];
                [_toDateSwitch setOn:NO animated:YES];
                _toDateLabel.text = @"";
            }
            break;
        //From date switch
        case 1:
            if ([sender isOn]) {
                _fromDateSelected = YES;
                //Show the date picker
                ///_datePicker.hidden = NO;
                [self showPicker];
            }
            else {
                _fromDateLabel.text = @"";
                [self hidePicker];
            }
            break;
        //To date switch
        case 2:
            if ([sender isOn]) {
                _fromDateSelected = NO;
                //Show the date picker
                ///_datePicker.hidden = NO;
                [self showPicker];
            }
            else {
                _toDateLabel.text = @"";
                [self hidePicker];
            }
            break;
    }
}

- (IBAction)pickerAction:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formatedDate = [dateFormatter stringFromDate:self.datePicker.date];
    _datePicker.hidden = YES;

    if (_fromDateSelected) {
        _fromDateLabel.text = formatedDate;
    }
    else {
        _toDateLabel.text = formatedDate;
    }
}

-(void) hidePicker
{
    [self.datePickerToolbar setHidden:YES];
    [self.datePicker setHidden:YES];
    _pickerVisible = NO;
}

- (IBAction)showPicker
{
    if(_pickerVisible == NO)
    {
        //show the toolbar with Done button
        
        [_datePickerToolbar setHidden:NO];
        // create the picker and add it to the view
        if(self.datePicker == nil) self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.datePickerToolbar.frame.origin.y + self.datePickerToolbar.frame.size.height, 320, 216)];
        [self.datePicker setMaximumDate:[NSDate date]];
        [self.datePicker setDatePickerMode:UIDatePickerModeDate];
        [self.datePicker setHidden:NO];
        [self.view addSubview:_datePicker];
        
        // the UIToolbar is referenced 'using self.datePickerToolbar'
        [UIView beginAnimations:@"showDatepicker" context:nil];
        // animate for 0.3 secs.
        [UIView setAnimationDuration:0.3];
        /*
        CGRect datepickerToolbarFrame = self.datePickerToolbar.frame;
        datepickerToolbarFrame.origin.y -= (self.datePicker.frame.size.height + self.datePickerToolbar.frame.size.height);
        self.datePickerToolbar.frame = datepickerToolbarFrame;
        */
        //DONE: Done button and date picker are visible for fromDate
        //TODO: Hide the toolbar when first time
        //Show for toDate as well.
        
        CGRect datepickerFrame = self.datePicker.frame;
        //datepickerFrame.origin.y -= (self.datePicker.frame.size.height + self.datePickerToolbar.frame.size.height);
        datepickerFrame.origin.y = self.datePickerToolbar.frame.origin.y + self.datePickerToolbar.frame.size.height;
        self.datePicker.frame = datepickerFrame;
        
        [UIView commitAnimations];
        _pickerVisible = YES;
        [_datePickerToolbar setHidden:NO];

    }
}

- (IBAction)done
{
    if(_pickerVisible == YES)
    {
        [UIView beginAnimations:@"hideDatepicker" context:nil];
        [UIView setAnimationDuration:0.3];
        
        /*
        CGRect datepickerToolbarFrame = self.datePickerToolbar.frame;
        datepickerToolbarFrame.origin.y += (self.datePicker.frame.size.height + self.datePickerToolbar.frame.size.height);
        self.datePickerToolbar.frame = datepickerToolbarFrame;
        */
        CGRect datepickerFrame = self.datePicker.frame;
        datepickerFrame.origin.y += (self.datePicker.frame.size.height + self.datePickerToolbar.frame.size.height);
        self.datePicker.frame = datepickerFrame;
        [UIView commitAnimations];
        
        // remove the picker after the animation is finished
        [self.datePicker performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:0.3];
        
        //format date
        NSDateFormatter *FormatDate = [[NSDateFormatter alloc] init];
        [FormatDate setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
        
        //set date format
        [FormatDate setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [FormatDate stringFromDate:[_datePicker date]];
        
        //update date textfield
        if (_fromDateSelected) {
            _fromDateLabel.text = strDate;
        }
        else {
            _toDateLabel.text = strDate;
        }
        _pickerVisible = NO;
    }
    [_datePickerToolbar setHidden:YES];
}

/*
-(void)ChooseDP:(int)sender{
    _pickerAction = [[UIActionSheet alloc] initWithTitle:@"Date"
                                               delegate:nil
                                      cancelButtonTitle:nil
                                 destructiveButtonTitle:nil
                                      otherButtonTitles:nil];
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake ( 0.0, 44.0, 0.0, 0.0)];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    //format datePicker mode. in this example time is used
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //calls dateChanged when value of picker is changed
    [_datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    _toolbarPicker = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _toolbarPicker.barStyle=UIBarStyleBlackOpaque;
    [_toolbarPicker sizeToFit];
    
    NSMutableArray *itemsBar = [[NSMutableArray alloc] init];
    //calls DoneClicked
    UIBarButtonItem *bbitem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DoneClicked)];
    [itemsBar addObject:bbitem];
    [_toolbarPicker setItems:itemsBar animated:YES];
    [_pickerAction addSubview:_toolbarPicker];
    [_pickerAction addSubview:_datePicker];
    [_pickerAction showInView:self.view];
    [_pickerAction setBounds:CGRectMake(0,0,320, 464)];
}

-(IBAction)dateChanged{
    //format date
    NSDateFormatter *FormatDate = [[NSDateFormatter alloc] init];
    [FormatDate setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"] ];
    
    //set date format
    [FormatDate setDateFormat:@"yyyy-MM-dd"];
    //update date textfield
    _fromDateLabel.text = [FormatDate stringFromDate:[_datePicker date]];
    
}


-(BOOL)closeDatePicker:(id)sender{
    [_pickerAction dismissWithClickedButtonIndex:0 animated:YES];
    //[date resignFirstResponder];
    
    return YES;
}

//action when done button is clicked
-(IBAction)DoneClicked{
    [self closeDatePicker:self];
    _datePicker.frame=CGRectMake(0, 44, 320, 416);
    
}

//returns number of components in pickerview
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

//returns number of rows in date picker
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 10;
}

-(void) showActionSheet
{
    UIActionSheet *aac = [[UIActionSheet alloc] initWithTitle:@"How many?"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                       destructiveButtonTitle:nil
                                            otherButtonTitles:nil];
    
    UIDatePicker *theDatePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 44.0, 0.0, 0.0)];
    
    theDatePicker.datePickerMode = UIDatePickerModeDate;
    theDatePicker.maximumDate=[NSDate date];
    
    _datePicker = theDatePicker;

    [_datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    
    _toolbarPicker = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    _toolbarPicker.barStyle = UIBarStyleBlackOpaque;
    [_toolbarPicker sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(DatePickerDoneClick)];
    [barItems addObject:doneBtn];
    
    [_toolbarPicker setItems:barItems animated:YES];
    
    [aac addSubview:_toolbarPicker];
    [aac addSubview:_datePicker];
    [aac showInView:self.view];
    [aac setBounds:CGRectMake(0,0,320, 464)];
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
