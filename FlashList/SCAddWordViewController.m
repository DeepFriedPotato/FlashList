//
//  SCAddWordViewController.m
//  FlashList
//
//  Created by Steven Shen on 7/20/14.
//  Copyright (c) 2014 Steven Shen. All rights reserved.
//

#import "SCAddWordViewController.h"

@interface SCAddWordViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *addWordTextField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation SCAddWordViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"TextFieldShouldReturn");
    [textField resignFirstResponder];//Dismiss the keyboard.
    [self performSegueWithIdentifier:@"saveSegue" sender:self.saveButton];
    //Add action you want to call here.
    return YES;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if (sender != self.saveButton) return;
    if (self.addWordTextField.text.length > 0){
        self.addedWord = _addWordTextField.text;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.addWordTextField becomeFirstResponder];
    self.addWordTextField.delegate=self;
    // Do any additional setup after loading the view.
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
