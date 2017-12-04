//
//  ViewController.m
//  RealmApp
//
//  Created by chliu.brook on 04/12/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *ipText;
@property (weak, nonatomic) IBOutlet UITextField *portText;
@property (weak, nonatomic) IBOutlet UIButton *getBtn;
- (IBAction)getBtnClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *funcText;
- (IBAction)postBtnClick:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)getBtnClick:(id)sender {
    NSString *urlStr = [NSString stringWithFormat:@"%@:%@/%@",_ipText.text,_portText.text,_funcText.text];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"请求成功%@",responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败");
    }];
}
- (IBAction)postBtnClick:(id)sender {
    NSString *urlStr = [NSString stringWithFormat:@"%@:%@/%@",_ipText.text,_portText.text,_funcText.text];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [session POST:urlStr parameters:[NSDictionary new] progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [dataTask resume];
}

@end
