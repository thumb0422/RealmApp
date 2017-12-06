//
//  ViewController.m
//  RealmApp
//
//  Created by chliu.brook on 04/12/2017.
//  Copyright © 2017 chliu.brook. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <objc/runtime.h>

@interface OrderMain:NSObject
@property (nonatomic,copy) NSString *orderId;
@property (nonatomic,assign) float sumAmount;
@property (nonatomic,assign) int   sumCount;
@property (nonatomic,copy) NSString *states;
- (NSDictionary *)properties_aps;
@end

@implementation OrderMain

- (NSDictionary *)properties_aps
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        if (propertyValue)
            [props setObject:propertyValue forKey:propertyName];
    }
    free(properties);
    return props;
}

@end

@interface ViewController (){
    OrderMain *orderMain;
}
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
    orderMain = [[OrderMain alloc] init];
    orderMain.sumCount = arc4random() % 100;
    orderMain.states = @"Y";
    orderMain.sumAmount  = (arc4random() % 501) + 1500;
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
    
    NSDictionary *params = [orderMain properties_aps];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.responseSerializer = [AFJSONResponseSerializer serializer];
    session.requestSerializer=[AFJSONRequestSerializer serializer];
    session.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/json",@"application/json",nil];
    
    [session POST:urlStr parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
    }];
    /**
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
    **/
}

@end
