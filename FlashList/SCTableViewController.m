//
//  SCTableViewController.m
//  FlashList
//
//  Created by Steven Shen on 7/14/14.
//  Copyright (c) 2014 Steven Shen. All rights reserved.
//

#import "SCTableViewController.h"
#import "MCSwipeTableViewCell.h"
#import "SCAddWordViewController.h"
#import "SCWordObject.h"

@interface SCTableViewController () <MCSwipeTableViewCellDelegate>

@property (nonatomic, unsafe_unretained) NSInteger numItems;
@property (nonatomic, strong) NSMutableArray *words;



@end

@implementation SCTableViewController
{
    NSOperationQueue *cellLoadQueue;
    NSMutableDictionary *cellDToLoadOperation;
    NSMutableDictionary *cellDToViewController;
}

- (IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    [cellLoadQueue setSuspended:YES];
}

- (IBAction)unwindToTable:(UIStoryboardSegue *)segue{
    SCAddWordViewController *source = [segue sourceViewController];
    if (source.addedWord.length > 0){
        SCWordObject *newWord = [[SCWordObject alloc] initWithWordTitle:source.addedWord];
        [self.words insertObject:newWord atIndex:0];
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
    [cellLoadQueue setSuspended:NO];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"red flag");
    [self.tableView setBackgroundColor:[UIColor colorWithRed:227.0 / 255.0 green:227.0 / 255.0 blue:227.0 / 255.0 alpha:1]];
    self.words = [NSMutableArray new];
    
    SCWordObject *presets[11];
    presets[0] = [[SCWordObject alloc] initWithWordTitle:@"zero"];
    presets[1] = [[SCWordObject alloc] initWithWordTitle:@"one"];
    presets[2] = [[SCWordObject alloc] initWithWordTitle:@"two"];
    presets[3] = [[SCWordObject alloc] initWithWordTitle:@"three"];
    presets[4] = [[SCWordObject alloc] initWithWordTitle:@"four"];
    presets[5] = [[SCWordObject alloc] initWithWordTitle:@"five"];
    presets[6] = [[SCWordObject alloc] initWithWordTitle:@"six"];
    presets[7] = [[SCWordObject alloc] initWithWordTitle:@"seven"];
    presets[8] = [[SCWordObject alloc] initWithWordTitle:@"eight"];
    presets[9] = [[SCWordObject alloc] initWithWordTitle:@"nine"];
    presets[10] = [[SCWordObject alloc] initWithWordTitle:@"ten"];
    self.words = [NSMutableArray arrayWithObjects:presets count:11];
    

    //self.words = [NSMutableArray arrayWithObjects:@"apple",@"banana",@"cat",@"dog",@"egg",@"false",@"gut",@"hello",@"illness",@"jacket",@"ThisIsNotAWord",@"apple",@"banana",@"cat",@"dog",@"egg",@"false",@"gut",@"hello",@"illness",@"jacket",@"ThisIsNotAWord",@"apple",@"banana",@"cat",@"dog",@"egg",@"false",@"gut",@"hello",@"illness",@"jacket",@"ThisIsNotAWord",@"apple",@"banana",@"cat",@"dog",@"egg",@"false",@"gut",@"hello",@"illness",@"jacket",@"ThisIsNotAWord",@"apple",@"banana",@"cat",@"dog",@"egg",@"false",@"gut",@"hello",@"illness",@"jacket",@"ThisIsNotAWord",@"apple",@"banana",@"cat",@"dog",@"egg",@"false",@"gut",@"hello",@"illness",@"jacket",@"ThisIsNotAWord",@"apple",@"banana",@"cat",@"dog",@"egg",@"false",@"gut",@"hello",@"illness",@"jacket",@"ThisIsNotAWord",@"apple",@"banana",@"cat",@"dog",@"egg",@"false",@"gut",@"hello",@"illness",@"jacket",@"ThisIsNotAWord",@"apple",@"banana",@"cat",@"dog",@"egg",@"false",@"gut",@"hello",@"illness",@"jacket",@"ThisIsNotAWord",@"apple",@"banana",@"cat",@"dog",@"egg",@"false",@"gut",@"hello",@"illness",@"jacket",@"ThisIsNotAWord",@"apple",@"banana",@"cat",@"dog",@"egg",@"false",@"gut",@"hello",@"illness",@"jacket",@"ThisIsNotAWord",@"apple",@"banana",@"cat",@"dog",@"egg",@"false",@"gut",@"hello",@"illness",@"jacket",@"ThisIsNotAWord", nil];
    
    
    UIReferenceLibraryViewController *test = [[UIReferenceLibraryViewController alloc] initWithTerm:@""];//Does not work without this nonsense
    cellLoadQueue = [[NSOperationQueue alloc] init];
    [cellLoadQueue setMaxConcurrentOperationCount:1];
    cellDToLoadOperation = [NSMutableDictionary new];
    cellDToViewController = [NSMutableDictionary new];
    

    //NSLog(@"view did load");
            // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"endDisplay index:%d for word: %@",(int)indexPath.row, cell.textLabel.text);
    NSBlockOperation *cellLoadOperationToKill = [cellDToLoadOperation objectForKey:[NSString stringWithFormat:@"%p", cell]];
    [cellLoadOperationToKill cancel];
    [cellDToLoadOperation removeObjectForKey:[NSString stringWithFormat:@"%p", cell]];
    [cellDToViewController removeObjectForKey:[NSString stringWithFormat:@"%p", cell]];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.words.count;
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cell";
    
    MCSwipeTableViewCell *cell = nil;//testing only, un-comment following line.
    //MCSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (!cell){
        cell = [[MCSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        //NSLog(@"cellForRow %@, indexPath: %d" ,[(SCWordObject *)self.words[indexPath.row] wordTitle], (int)indexPath.row);
    }else{
        //NSLog(@"reuse warning");
    }
    
    
    
    UIView *checkView = [self viewWithImageName:@"check"];
    UIColor *greenColor = [UIColor colorWithRed:85.0 / 255.0 green:213.0 / 255.0 blue:80.0 / 255.0 alpha:1.0];
    
    
    UIView *questionView = [self viewWithImageName:@"QuestionMark"];
    UIColor *redColor = [UIColor colorWithRed:232.0 / 255.0 green:61.0 / 255.0 blue:14.0 / 255.0 alpha:1.0];

    [cell.textLabel setText:[(SCWordObject *)self.words[indexPath.row] wordTitle]];
    [cell setDefaultColor:self.view.backgroundColor];
    [cell setFirstTrigger:0.15];
    
    
    
    
    
    
    
    
    
    //Loading!!!!!!
    
    
    NSBlockOperation *cellLoadOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        NSLog(@"startLoading cellText:%@ indexPath:%d", cell.textLabel.text, (int)[tableView indexPathForCell:cell].row);
        //NSLog(@"%@", dispatch_get_current_queue());
        
        
        if ([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:cell.textLabel.text]) {
            
            cellDToViewController[[NSString stringWithFormat:@"%p", cell]] = [[UIReferenceLibraryViewController alloc] initWithTerm:cell.textLabel.text];
            NSLog(@"BLUE FLAG ViewController:%@, cellText:%@, indexPath:%d", cellDToViewController[[NSString stringWithFormat:@"%p", cell]], cell.textLabel.text, (int)[tableView indexPathForCell:cell].row);
            
            

        }
        else{//No Definition found in Dictionary
            NSLog(@"No definition found for cellText:%@, indexPath:%d", cell.textLabel.text, (int)[tableView indexPathForCell:cell].row);
        }
        
    }];
    
    
    if (![[cellLoadQueue operations] containsObject:cellDToLoadOperation[[NSString stringWithFormat:@"%p",cell]]]){
        [cellDToLoadOperation setObject:cellLoadOperation forKey:[NSString stringWithFormat:@"%p", cell]];
        [cellLoadQueue addOperation:cellDToLoadOperation[[NSString stringWithFormat:@"%p", cell]]];
    }else{
        NSLog(@"Warning operation already exist in cellLoadQueue");
    }
    //end of loading code
   
    
    SCTableViewController * __weak weakSelf = self;
    MCSwipeTableViewCell * __weak weakCell = cell;
    
    //CHECK
    [cell setSwipeGestureWithView:checkView color:greenColor mode:MCSwipeTableViewCellModeExit state:MCSwipeTableViewCellState1 completionBlock:^(MCSwipeTableViewCell *cell_block, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        
        //NSLog(@"Did swipe \"Checkmark\" cell at index %d for word: %@", (int)[tableView indexPathForCell:weakCell].row, [(SCWordObject *)self.words[indexPath.row] wordTitle]);
        
        [weakSelf moveCellAtIndex:[tableView indexPathForCell:weakCell] toIndex:[NSIndexPath indexPathForRow:[self.tableView numberOfRowsInSection:0]-1 inSection:0]]; //Moving to the end of the array. Minus one due to first deletion
        
    }];
    
    
    //QUESTION
    
    [cell setSwipeGestureWithView:questionView color:redColor mode:MCSwipeTableViewCellModeSwitch state:MCSwipeTableViewCellState3 completionBlock:^(MCSwipeTableViewCell *cell_block, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
        
        
        NSLog(@"Did swipe \"Question\" cell at index %d for word %@", (int)[tableView indexPathForCell:weakCell].row, [(SCWordObject *)self.words[[tableView indexPathForCell:weakCell].row] wordTitle]);
        //NSLog(@"Current cell.description %@", [NSString stringWithFormat:@"%p", weakCell]);
        //*******rewrite starts here
        
        NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc] init];
        [backgroundQueue addOperation:[NSBlockOperation blockOperationWithBlock:^{
            
            if ([cellDToViewController objectForKey:[NSString stringWithFormat:@"%p", weakCell]]){
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [weakSelf presentViewController: [cellDToViewController objectForKey:[NSString stringWithFormat:@"%p", weakCell]] animated:YES completion:nil];
                }];
                
            }else{
                UIView *loading = [[UIView alloc] initWithFrame:weakSelf.view.bounds];
                UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    loading.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                    [activityView startAnimating];
                    [loading addSubview:activityView];
                    activityView.center = self.view.center;
                    
                    [weakSelf.view addSubview:loading];
                    [weakSelf.view setNeedsDisplay];
                    weakSelf.view.userInteractionEnabled = NO;
                }];
                
                
                NSOperationQueue *prioritize = [[NSOperationQueue alloc] init];
                [prioritize addOperationWithBlock:^{
                    NSLog(@"Prioritizing definition for %@", weakCell.textLabel.text);
                    if ([[cellLoadQueue operations] containsObject:cellDToLoadOperation[[NSString stringWithFormat:@"%p",weakCell]]]){
                        [cellDToLoadOperation[[NSString stringWithFormat:@"%p",weakCell]] setQueuePriority:NSOperationQueuePriorityVeryHigh];
                    }else{
                        NSLog(@"Warning: Prioritizing failed");
                    }
                    if ([UIReferenceLibraryViewController dictionaryHasDefinitionForTerm:weakCell.textLabel.text]) {
                        NSBlockOperation *presentOperation = [NSBlockOperation blockOperationWithBlock:^{
                            NSLog(@"[PRIORITIZED]Presenting dictionary for term:@%@",weakCell.textLabel.text);
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [weakSelf presentViewController:[cellDToViewController objectForKey:[NSString stringWithFormat:@"%p",weakCell]] animated:YES completion:nil];
                                [loading removeFromSuperview];
                                [self.view setNeedsDisplay];
                                self.view.userInteractionEnabled = YES;
                            }];
                            NSLog(@"[PRIORITIZED View Finish]");
                        }];
                        NSLog(@"cellLoadQueue operations:%@", [cellLoadQueue operations]);
                        if ([[cellLoadQueue operations] containsObject:cellDToLoadOperation[[NSString stringWithFormat:@"%p",weakCell]]]){
                            [cellDToLoadOperation[[NSString stringWithFormat:@"%p",weakCell]] setCompletionBlock:^{
                                [[NSOperationQueue new] addOperation:presentOperation];
                            }];
                        }else if ([(NSOperation *)cellDToLoadOperation[[NSString stringWithFormat:@"%p",weakCell]] isFinished]){
                            [[NSOperationQueue new] addOperation:presentOperation];
                            
                        }else{
                            NSLog(@"*******WARNING! Extremely unlikely event happening! HAHA Turns out not the case*******");
                            NSLog(@"cellLoadQueue operations:%@", [cellLoadQueue operations]);
                            NSLog(@"cellDToLoadOperation isFinished:%d", [(NSOperation *)cellDToLoadOperation[[NSString stringWithFormat:@"%p",weakCell]] isFinished]);
                            int loopCount = 0;
                            while (![[cellLoadQueue operations] containsObject:cellDToLoadOperation[[NSString stringWithFormat:@"%p",weakCell]]] && ![(NSOperation *)cellDToLoadOperation[[NSString stringWithFormat:@"%p",weakCell]] isFinished]) {
                                sleep(1);
                                loopCount +=1;
                                if (loopCount == 20) {
                                    NSLog(@"FATAL ERROR: NO LOAD OPERATION FOUND AFTER 20 SECONDS.");
                                }
                            }
                            [cellDToLoadOperation[[NSString stringWithFormat:@"%p",weakCell]] setCompletionBlock:^{
                                [[NSOperationQueue new] addOperation:presentOperation];
                            }];
                            
                            
                        }
                        
                    }else{
                        //NSLog(@"Showing No Word Found Page");
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            activityView.hidesWhenStopped = NO;
                            [activityView stopAnimating];
                            UILabel *NoDefinitionFoundLabel = [[UILabel alloc] initWithFrame:loading.bounds];
                            NoDefinitionFoundLabel.frame = CGRectMake(NoDefinitionFoundLabel.frame.origin.x, NoDefinitionFoundLabel.frame.origin.y+40, NoDefinitionFoundLabel.frame.size.width, NoDefinitionFoundLabel.frame.size.height);
                            NoDefinitionFoundLabel.textColor = [UIColor whiteColor];
                            NoDefinitionFoundLabel.textAlignment = NSTextAlignmentCenter;
                            NoDefinitionFoundLabel.text = @"No Definition Found -_-";
                            [loading addSubview:NoDefinitionFoundLabel];
                        }];
                        
                        [[NSOperationQueue new] addOperationWithBlock:^{
                            sleep(1);
                            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                [loading removeFromSuperview];
                                [self.view setNeedsDisplay];
                                self.view.userInteractionEnabled = YES;
                            }];
                            
                        }];
                    }
                    
                
                }];
                
                    
            }
            
            NSIndexPath *smallerToIndex = [NSIndexPath indexPathForRow:MIN([self.tableView numberOfRowsInSection:0]-1, [tableView indexPathForCell:weakCell].row + 5 ) inSection:0];
            
            [self moveCellAtIndex:[tableView indexPathForCell:weakCell] toIndex:smallerToIndex]; //Moving to the end of the array. Minus one due to first deletion
        
        }]];
        
    }];
        
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)moveCellAtIndex:(NSIndexPath *)fromIndex toIndex:(NSIndexPath *)toIndex
{
    [cellLoadQueue setSuspended:YES];
    
    //MCSwipeTableViewCell *cellToDelete = (MCSwipeTableViewCell *)[self.tableView cellForRowAtIndexPath:fromIndex];
    SCWordObject *movedCell = [self.words objectAtIndex:fromIndex.row];
    
    [self.words insertObject:movedCell atIndex:toIndex.row+1];
    [self.words removeObjectAtIndex:fromIndex.row];
    
    [UIView beginAnimations:@"myAnimationId" context:nil];
    [UIView setAnimationDuration:0.2];
    [CATransaction begin];
    
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[fromIndex] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView insertRowsAtIndexPaths:@[toIndex] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    
    [CATransaction commit];
    [UIView commitAnimations];
    
    [cellLoadQueue setSuspended:NO];
    //dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //    [self.tableView reloadData];
    
    //});
    
    
}

- (UIView *)viewWithImageName:(NSString *)imageName {
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.contentMode = UIViewContentModeCenter;
    return imageView;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
