//
//  APMBlueViewController.m
//  ApmDemo
//
//  Created by wakeen on 2018/4/10.
//  Copyright © 2018年 testcgd. All rights reserved.
//

#import "RMTableViewExampleViewController.h"

@interface RMTableViewExampleViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataList;

@end

@implementation RMTableViewExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [NSThread sleepForTimeInterval:0.3];
    
    self.dataList = @[
        @"🙈", @"🙉", @"🙊", @"💥", @"💫", @"💦", @"💨", @"🐵", @"🐒", @"🦍", @"🦧", @"🐶", @"🐕",
        @"🦮", @"🐕‍🦺", @"🐩", @"🐺", @"🦊", @"🦝", @"🐱", @"🐈", @"🐈‍⬛", @"🦁", @"🐯", @"🐅", @"🐆",
        @"🐴", @"🐎", @"🦄", @"🦓", @"🦌", @"🦬", @"🐮", @"🐂", @"🐃", @"🐄", @"🐷", @"🐖", @"🐗",
        @"🐽", @"🐏", @"🐑", @"🐐", @"🐪", @"🐫", @"🦙", @"🦒", @"🐘", @"🦣", @"🦏", @"🦛", @"🐭",
        @"🐁", @"🐀", @"🐹", @"🐰", @"🐇", @"🐿️", @"🦫", @"🦔", @"🦇", @"🐻", @"🐻‍❄️", @"🐨", @"🐼",
        @"🦥", @"🦦", @"🦨", @"🦘", @"🦡", @"🐾", @"🦃", @"🐔", @"🐓", @"🐣", @"🐤", @"🐥", @"🐦",
        @"🐧", @"🕊️", @"🦅", @"🦆", @"🦢", @"🦉", @"🦤", @"🪶", @"🦩", @"🦚", @"🦜", @"🐸", @"🐊",
        @"🐢", @"🦎", @"🐍", @"🐲", @"🐉", @"🦕", @"🦖", @"🐳", @"🐋", @"🐬", @"🦭", @"🐟", @"🐠",
        @"🐡", @"🦈", @"🐙", @"🐚", @"🐌", @"🦋", @"🐛", @"🐜", @"🐝", @"🪲", @"🐞", @"🦗", @"🪳",
        @"🕷️", @"🕸️", @"🦂", @"🦟", @"🪰", @"🪱", @"🦠", @"💐", @"🌸", @"💮", @"🏵️", @"🌹", @"🥀",
        @"🌺", @"🌻", @"🌼", @"🌷", @"🌱", @"🪴", @"🌲", @"🌳", @"🌴", @"🌵", @"🌾", @"🌿", @"☘️",
        @"🍀", @"🍁", @"🍂", @"🍃", @"🍄", @"🌰", @"🦀", @"⚽️", @"🏀", @"⚾️", @"🥏", @"🏓", @"🎱"
    ];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
}

- (IBAction)autoScroll:(id)sender {
    [self scrollDown];
}

- (void)scrollDown {
    CGSize size = self.tableView.frame.size;
    CGPoint offset = self.tableView.contentOffset;
    offset.y += 500;
    if (offset.y >= self.tableView.contentSize.height - size.height) {
        [self scrollUp];
    } else {
        [self.tableView scrollRectToVisible:CGRectMake(offset.x, offset.y, size.width, size.height) animated:YES];
        [self performSelector:@selector(scrollDown) withObject:nil afterDelay:1.0];
    }
}

- (void)scrollUp {
    CGSize size = self.tableView.frame.size;
    CGPoint offset = self.tableView.contentOffset;
    offset.y -= 500;
    if (offset.y <= size.height) {
        [self scrollDown];
    } else {
        [self.tableView scrollRectToVisible:CGRectMake(offset.x, offset.y, size.width, size.height) animated:YES];
        [self performSelector:@selector(scrollUp) withObject:nil afterDelay:1.0];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BOOL hitch = arc4random() % 5;
    if (hitch) {
        [NSThread sleepForTimeInterval:0.02];
    }
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultcell"];
    cell.textLabel.text = [self.dataList objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:80];

    BOOL hitch = arc4random() % 5;
    if (hitch) {
        [NSThread sleepForTimeInterval:0.02];
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL hitch = arc4random() % 5;
    if (hitch) {
        [NSThread sleepForTimeInterval:0.02];
    }
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

@end
