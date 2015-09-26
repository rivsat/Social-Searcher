//
//  FilterViewController.h
//  Social Searcher
//
//  Created by Tasvir H Rohila on 03/09/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FilterViewController;

@protocol FilterViewControllerDelegate <NSObject>

-(void) didSetFilter: (BOOL) isFilterON startDate: (NSString *) strStartDate endDate: (NSString *) strEndDate;

@end

@interface FilterViewController : UITableViewController

@property (nonatomic, strong) id <FilterViewControllerDelegate> filterDelegate;

@property (weak, nonatomic) IBOutlet UITableView *filterTableView;
@property (weak, nonatomic) IBOutlet UISwitch *filterSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *fromDateSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *toDateSwitch;
@property (weak, nonatomic) IBOutlet UILabel *fromDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *toDateLabel;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@property BOOL isFilterON;
@property (nonatomic, strong) NSString *strStartDate;
@property (nonatomic, strong) NSString *strEndDate;


//>Picker View and related controls
@property (nonatomic, retain) UIView *pickerContainerView;
//@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic,retain) UISegmentedControl *segmentcontrol;
@property (nonatomic,retain) UIBarButtonItem *doneButton;
@property (nonatomic, retain) UIActionSheet *pickerAction;
@property (nonatomic, retain) UIToolbar *toolbarPicker;

@end
