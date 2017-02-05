//
//  ViewController.m
//  ToDo List
//
//  Created by Jackson on 30/01/2017.
//  Copyright © 2017 Jackson. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *buttonSave;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if (self.isDetail) {
        
        self.textField.text = self.eventInfo;
        self.textField.userInteractionEnabled = NO;
        self.datePicker.userInteractionEnabled = NO;
        self.buttonSave.alpha = 0;
        [self performSelector:@selector(setDatePickerValueWithAnimation) withObject:nil afterDelay:0.5];
    }
    else {
    self.buttonSave.userInteractionEnabled = NO;
    self.datePicker.minimumDate = [NSDate date];
    
    [self.datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    
    [self.buttonSave addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer * hadleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action: @selector(handleEndEditing)];
    
    [self.view addGestureRecognizer:hadleTap];
    }
}

- (void) setDatePickerValueWithAnimation {
    [self.datePicker setDate:self.eventDate animated:YES];
}

- (void) datePickerValueChanged {
    
    self.eventDate = self.datePicker.date;
    
    NSLog(@"eventDate is %@", self.eventDate);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) handleEndEditing {
    if ([self.textField.text length] != 0) {
        [self.view endEditing:YES];
        self.buttonSave.userInteractionEnabled = YES;
    }
    else {
        [self showAlerWithMessage: @"Для созранения события введите значение в текстовое поле"];
    }

}

-(void) save {
 
    if (self.eventDate) {
    
        if ([self.eventDate compare:[NSDate date]] == NSOrderedSame) {
            [self showAlerWithMessage: @"Дата будущего события не может совпадать с текущей датой"];

        }
        else if ([self.eventDate compare:[NSDate date]] == NSOrderedAscending) {
            [self showAlerWithMessage: @"Дата будущего события не может быть ранее текущей даты"];

        }
        else{
            [self setNotification];
        }
    }
    else {
        [self showAlerWithMessage: @"Для созранения события измените значение даты на более позднее"];
    }
}


- (void)setNotification {
    NSString * eventInfo = self.textField.text;
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm dd.MMMM.yyyy";
    
    NSString * eventDate = [formatter stringFromDate:self.eventDate];
    
    NSDictionary * dict = [[NSDictionary alloc] initWithObjectsAndKeys: eventInfo, @"eventInfo", eventDate, @"eventDate", nil];
    
    UILocalNotification * notification = [[UILocalNotification alloc] init];
    notification.userInfo = dict;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.fireDate = self.eventDate;
    notification.alertBody = eventInfo;
    notification.applicationIconBadgeNumber = 1;
    notification.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] scheduleLocalNotification: notification];
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NewEvent" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.textField]) {
        [self.textField resignFirstResponder];
        self.buttonSave.userInteractionEnabled = YES;
        return YES;
    }
    else {
        [self showAlerWithMessage: @"Для созранения события введите значение в текстовое поле"];
    }
    return NO;
}

- (void) showAlerWithMessage: (NSString * ) message {
    UIAlertController * alert= [UIAlertController alertControllerWithTitle:@"Attention!" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}






@end
