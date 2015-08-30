//
//  HelpViewController.m
//  Social Searcher
//
//  Created by Tasvir H Rohila on 30/08/15.
//  Copyright (c) 2015 Tasvir H Rohila. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *BackButton;
@property (weak, nonatomic) IBOutlet UIWebView *htmlView;

@end

@implementation HelpViewController
static NSString *kHelpText = @"<h3>Search query operators</h3><p>The query can have operators that modify its behavior, the available operators are:</p><table><thead><tr><th>Operator</th><th>Finds tweets…</th></tr><tr></tr></thead><tbody><tr><td>watching now</td><td>containing both “watching” and “now”. This is the default operator.</td></tr><tr><td>“happy hour”</td><td>containing the exact phrase “happy hour”.</td></tr><tr><td>love OR hate</td><td>containing either “love” or “hate” (or both).</td></tr><tr><td>superhero since:2015-07-19</td><td>containing “superhero” and sent since date “2015-07-19” (year-month-day).</td></tr><tr><td>ftw until:2015-07-19</td><td>containing “ftw” and sent before the date “2015-07-19”.</td></tr><tr><td>beer -root</td><td>containing “beer” but not “root”.</td></tr><tr><td>#haiku</td><td>containing the hashtag “haiku”.</td></tr></tbody></table>";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [(UIWebView *)self.htmlView loadHTMLString:kHelpText baseURL:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)BackButtonClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
