//
//  ViewController.m
//  ybxzicon
//
//  Created by Oreal51 on 2017/6/11.
//  Copyright © 2017年 Oreal51. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableview;
    NSArray *websites;
    NSMutableArray *websiteIcons;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, 365, 400)];
    tableview.dataSource = self;
    tableview.delegate = self;
    [self.view addSubview:tableview];
    //设置希望得到网站图标的网站
    websites = [NSArray arrayWithObjects:@"baidu.com",@"amazon.com",@"microsoft.com",@"apple.com", nil];
    
    websiteIcons = [[NSMutableArray alloc]init];
    
    //对于website数组中的每一个网站，插入NSNull到网站图标数组
    //当图片从网络上加载之后，这些NSNull将被替换
    for (NSString* website in websites) {
        [websiteIcons addObject:[NSNull null]];
    }
//获取一个新的队列
    NSOperationQueue *backgroundQueue = [[NSOperationQueue alloc]init];
    int websiteNumber = 0;//用于跟踪哪个索引插入了新图片
    for (NSString *website in websites) {
        [backgroundQueue addOperationWithBlock:^{
            //为网站的图标构造一个URL
            NSURL *iconURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/favicon.ico",website]];
            //为这个URL创建一个URL请求
            NSURLRequest *request = [NSURLRequest requestWithURL:iconURL];
            //加载数据
            NSData *loadedDate = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
            if (loadedDate != nil) {
                //我们得到了图像数据，将其转换为图像
                UIImage *loadedImage = [UIImage imageWithData:loadedDate];
                //如果数据不能够被转换成图像，则停止运行
                if (loadedImage == nil) {
                    return ;
                }
                //将图片插入在主队列的表视图
                [[NSOperationQueue mainQueue]addOperationWithBlock:^{
                    [websiteIcons replaceObjectAtIndex:websiteNumber withObject:loadedImage];
                    [tableview reloadData];
                }];
            }
        }];
        websiteNumber ++;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //单元格的个数等于网站的数量
    return [websites count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *IconCell = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IconCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:IconCell];
    }
//    把网站的名字赋给该单元格
    cell.textLabel.text = [websites objectAtIndex:indexPath.row];
    //如果有该网站的图标，赋给该单元格
    UIImage *websiteImage = [websiteIcons objectAtIndex:indexPath.row];
    if ((NSNull*)websiteImage != [NSNull null]) {
        cell.imageView.image = websiteImage;
    }
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
