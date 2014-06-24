//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpTableCell.h"
#import "YelpClient.h"
#import "AFHTTPRequestOperation.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UITableView *searchResultsTable;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) NSArray *restaurantsArray;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {
            self.restaurantsArray = response[@"businesses"];
            [self.searchResultsTable reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchResultsTable.delegate = self;
    self.searchResultsTable.dataSource = self;
    
    [self.searchResultsTable registerNib:[UINib nibWithNibName:@"YelpTableCell" bundle:nil] forCellReuseIdentifier:@"YelpTableCell"];
    
    NSArray *xib = [[NSBundle mainBundle] loadNibNamed:@"ResultsTableHeaderView" owner:self options:nil];
    UIView *header = [xib lastObject];
    

    self.searchResultsTable.tableHeaderView = header;
    self.searchResultsTable.rowHeight = 120;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma meta table methods
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.restaurantsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YelpTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YelpTableCell"];
    NSDictionary *restaurant = self.restaurantsArray[indexPath.row];
    NSDictionary *address = restaurant[@"location"];
    NSArray *categories = restaurant[@"categories"][0];

    cell.nameLabel.text = restaurant[@"name"];
    cell.addressLabel.text = address[@"address"][0];
    cell.categoryLabel.text = categories[0];
    NSLog(@"restaurant: %@", restaurant);
    
    
    NSString *poster = restaurant[@"image_url"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:poster]];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        cell.posterImage.image = responseObject;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
    }];
    [requestOperation start];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)refresh
{

}

@end
