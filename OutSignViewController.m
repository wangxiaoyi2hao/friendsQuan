//
//  OutSignViewController.m
//  sportXProject
//
//  Created by lsp's mac pro on 16/4/25.
//  Copyright © 2016年 lsp's mac pro. All rights reserved.
//

#import "OutSignViewController.h"
#import "SprotRoomTableViewCell.h"
#import "DiscussViewController.h"
#import "CheckImage.h"
extern UserInfo*LoginUserInfo;
@interface OutSignViewController ()
{

    NSMutableArray*trendArrayMy;
    int pageCount;

}
@end

@implementation OutSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self requestList];
    _tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        [self requestList];
    }];
    _tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self requestListDownLoad];
    }];
    // Do any additional setup after loading the view from its nib.
}
-(void)requestListDownLoad{
    pageCount++;
    [[Tostal sharTostal]showLoadingView:@"正在加载" view:self.view];
    NSString*str=[NSString stringWithFormat:@"%@/trend/getMyFollowTrends",REQUESTURL];
    //创建参数字符串对象
    Request12002*request12002=[[Request12002 alloc]init];
    request12002.common.userid=LoginUserInfo.userId;
    request12002.common.userkey=LoginUserInfo.userKey;
    request12002.common.cmdid=12002;
    request12002.common.  timestamp=[[NSDate date]timeIntervalSince1970];
    request12002.common.platform=2;
    request12002.common.version=sportVersion;
    request12002.params.pageIndex=pageCount;
    NSData*data2=[request12002 data];
    [SendInternet httpNsynchronousRequestUrl:str postStr:data2 finshedBlock:^(NSData *dataString) {
        Response12002*response12002=[Response12002 parseFromData:dataString error:nil];
        if (response12002.common.code==0) {
            for (int i=0; i<response12002.data_p.trendsArray.count; i++) {
                Trend*mytend=[response12002.data_p.trendsArray objectAtIndex:i];
                [trendArrayMy addObject:mytend];
            }
            [[Tostal sharTostal]hiddenView];
            [_tableview.mj_footer endRefreshing];
            [_tableview reloadData];
            
        }else{
            [[Tostal sharTostal]tostalMesg:response12002.common.message tostalTime:10];
            [[Tostal sharTostal]hiddenView];
            [_tableview.mj_footer endRefreshing];
        }
    }];
}

-(void)requestList{
    pageCount=0;
    [[Tostal sharTostal]showLoadingView:@"正在加载" view:self.view];
    
    trendArrayMy=nil;
    trendArrayMy=[NSMutableArray array];
    NSString*str=[NSString stringWithFormat:@"%@/trend/getMyFollowTrends",REQUESTURL];
    //创建参数字符串对象
    Request12002*request12002=[[Request12002 alloc]init];
    request12002.common.userid=LoginUserInfo.userId;
    request12002.common.userkey=LoginUserInfo.userKey;
    request12002.common.cmdid=12002;
    request12002.common.  timestamp=[[NSDate date]timeIntervalSince1970];
    request12002.common.platform=2;
    request12002.common.version=sportVersion;
    request12002.params.pageIndex=pageCount;
    NSData*data2=[request12002 data];
    [SendInternet httpNsynchronousRequestUrl:str postStr:data2 finshedBlock:^(NSData *dataString) {
        Response12002*response12002=[Response12002 parseFromData:dataString error:nil];
        if (response12002.common.code==0) {
            for (int i=0; i<response12002.data_p.trendsArray.count; i++) {
                Trend*mytend=[response12002.data_p.trendsArray objectAtIndex:i];
                [trendArrayMy addObject:mytend];
            }
            [[Tostal sharTostal]hiddenView];
            [_tableview.mj_header endRefreshing];
            [_tableview reloadData];
         
        }else{
            [[Tostal sharTostal]tostalMesg:response12002.common.message tostalTime:10];
             [[Tostal sharTostal]hiddenView];
            [_tableview.mj_header endRefreshing];
        
        }
     }];
}
-(void)viewWillAppear:(BOOL)animated{
    
  self.tabBarController.title=@"关注";
     [self.tabBarController.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Trend*tableTrend=[trendArrayMy objectAtIndex:indexPath.row];
    if (tableTrend.imgsArray.count==1) {
        UIFont *font=[UIFont systemFontOfSize:12];
         CGSize sizefromUrl=   [CheckImage downloadImageSizeWithURL:[tableTrend.imgsArray objectAtIndex:0]];
        CGRect rect=[tableTrend.content boundingRectWithSize:CGSizeMake(277, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        
        float height=rect.size.height+sizefromUrl.height/10+100;
        NSLog(@"%.2f",rect.size.height);
        return height;
    }
    if (tableTrend.imgsArray.count>1){
        if (tableTrend.imgsArray.count>1&&tableTrend.imgsArray.count<6) {
            UIFont *font=[UIFont systemFontOfSize:12];
            CGRect rect=[tableTrend.content boundingRectWithSize:CGSizeMake(277, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
            
            float height=rect.size.height+30+169;
            NSLog(@"%.2f",rect.size.height);
            return height;
        }else{
        
        
            UIFont *font=[UIFont systemFontOfSize:12];
            CGRect rect=[tableTrend.content boundingRectWithSize:CGSizeMake(277, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
            
            float height=rect.size.height+30+73+169+30+70;
            NSLog(@"%.2f",rect.size.height);
            return height;
        }
        
        
    }else{
      
        UIFont *font=[UIFont systemFontOfSize:12];
        CGRect rect=[tableTrend.content boundingRectWithSize:CGSizeMake(277, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        
        float height=rect.size.height+30+73;
        NSLog(@"%.2f",rect.size.height);
        
        return height;
    }

  

    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return trendArrayMy.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static   NSString *str=@"cell";
    //使用闲置池
    SprotRoomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        NSArray*arry=[[NSBundle mainBundle]loadNibNamed:@"SprotRoomTableViewCell" owner:self options:nil];
        cell=[arry objectAtIndex:0];
    }
    Trend*tableTrend=[trendArrayMy objectAtIndex:indexPath.row];
    if (tableTrend.isLiked==YES) {
        [cell.imageZan setImage:[UIImage imageNamed:@"liked.png"]];
    }else{
    
        [cell.imageZan setImage:[UIImage imageNamed:@"like.png"]];
    }
 
    [cell._imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",tableTrend.briefUser.userAvatar]] placeholderImage:[UIImage imageNamed:@"feedback_bg.png"]];
    cell.lbDes1.text=tableTrend.content;
    cell.lbName.text=tableTrend.briefUser.userName;
    cell.labelZan.text=[NSString stringWithFormat:@"%i",tableTrend.likeCount];
    cell.labelPing.text=[NSString stringWithFormat:@"%i",tableTrend.commentCount];
    cell.buttonZan.tag=indexPath.row;
    [cell.buttonZan addTarget:self action:@selector(zanClick:) forControlEvents:UIControlEventTouchUpInside];
    //获取评论内容的高度
    UIFont *font=[UIFont systemFontOfSize:12];
    CGRect rect=[tableTrend.content boundingRectWithSize:CGSizeMake(277, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    NSLog(@"%@",tableTrend.content);
    NSLog(@"%.2f",rect.size.height);
    if (tableTrend.imgsArray.count==1) {
   
        NSLog(@"%@",NSStringFromCGSize(sizefromUrl));
        cell.bigImageP.hidden=NO;
        cell.collectionView.hidden=YES;
        [cell.lbDes1 setFrame:CGRectMake(73, 37, 285, rect.size.height)];
        [cell.bigImageP sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[tableTrend.imgsArray objectAtIndex:0]]] placeholderImage:[UIImage imageNamed:@""]];
        [cell .bigImageP setFrame:CGRectMake(73, rect.size.height+cell.lbDes1.frame.origin.y+5, sizefromUrl.width/10, sizefromUrl.height/10)];
         [cell.downView setFrame:CGRectMake(0, cell.lbDes1.frame.origin.y+5+sizefromUrl.height/10+30, KScreenWidth, 39)];
      
    }else{
        
        
        if (tableTrend.imgsArray.count>1&&tableTrend.imgsArray.count<6) {
            cell.collectionView.hidden=NO;
            cell.bigImageP.hidden=YES;
            cell.picturArray=tableTrend.imgsArray;
            [cell.lbDes1 setFrame:CGRectMake(73, 37, 285, rect.size.height)];
            [cell .collectionView setFrame:CGRectMake(73, rect.size.height+cell.lbDes1.frame.origin.y+5, KScreenWidth-125, KScreenHeight-KScreenWidth)];
            [cell.downView setFrame:CGRectMake(0, rect.size.height+cell.lbDes1.frame.origin.y+5+cell.collectionView.frame.origin.y+60, KScreenWidth, 39)];
            
            
        }else{
            if (tableTrend.imgsArray.count>6) {
                cell.collectionView.hidden=NO;
                cell.bigImageP.hidden=YES;
                cell.picturArray=tableTrend.imgsArray;
                [cell.lbDes1 setFrame:CGRectMake(73, 37, 285, rect.size.height)];
                [cell .collectionView setFrame:CGRectMake(73, rect.size.height+cell.lbDes1.frame.origin.y+5, KScreenWidth-125, KScreenHeight-KScreenWidth)];
                [cell.downView setFrame:CGRectMake(0, cell.lbDes1.frame.origin.y+5+cell.collectionView.frame.origin.y+60+150, KScreenWidth, 39)];
            }else{
                cell.collectionView.hidden=YES;
                cell.bigImageP.hidden=YES;
                [cell.lbDes1 setFrame:CGRectMake(73, 37, 285, rect.size.height)];
                [cell.downView setFrame:CGRectMake(0, rect.size.height+cell.lbDes1.frame.origin.y+5, KScreenWidth, 39)];
                
            
            }
           
        }
        
      
     
    }


   
    return  cell;

}
//点击赞事件
-(void)zanClick:(UIButton*)sender{

    Trend*tableTrend=[trendArrayMy objectAtIndex:sender.tag];
    if (tableTrend.isLiked==YES) {
        //取消赞
        [GiveZan dontSendsend:tableTrend.id_p];
        tableTrend.isLiked=NO;
        tableTrend.likeCount--;

    }else{
    //点赞
        [GiveZan sendsend:tableTrend.id_p];
        tableTrend.isLiked=YES;
           tableTrend.likeCount++;
    }
    [_tableview reloadData];
}
- (CGFloat)heightForImage:(UIImage *)image
{
    //(2)获取图片的大小
    CGSize size = image.size;
    //(3)求出缩放比例
    CGFloat scale = KScreenWidth / size.width;
    CGFloat imageHeight = size.height * scale;
    return imageHeight;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Trend*tableTrend1=[trendArrayMy objectAtIndex:indexPath.row];
    DiscussViewController*controller=[[DiscussViewController alloc]init];
    controller.fromTrendID=tableTrend1.id_p;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
