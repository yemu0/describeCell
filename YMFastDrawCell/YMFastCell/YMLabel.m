//
//  YMComment.m
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/27.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMLabel.h"
#import "YMCellManager.h"

@interface YMLabel()

@property (nonatomic,strong) NSArray *rangeArray;
@property (nonatomic,strong) void (^active)(NSString *);

//保存展开后的全文
@property (nonatomic,strong) NSString *fullText;

//传递的类型是字符串 还是精确。 精确为YES
@property (nonatomic,assign) BOOL isSetupType;


@property (nonatomic,strong) ym_changeType changeTypeBlock;



@end
@implementation YMLabel
#pragma mark  重写

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.numberOfLines = 0;
        self.lineBreakMode = NSLineBreakByCharWrapping;
        self.userInteractionEnabled = YES;
        self.isShowTapBackgouradColor = YES;
        self.touchBackgouradColor = [UIColor colorWithRed:150/255.0  green:221/255.0  blue:254/255.0 alpha:1];
        self.normalColor = [UIColor colorWithRed:5/255.0  green:110/255.0  blue:253/255.0 alpha:1];
    }
    return self;
}

-(NSString *)packupString{
    
    if(_packupString.length==0)
        return @"收起";
    return _packupString;
}

-(NSString *)unfoldString{
    if(_unfoldString.length==0)
        return @"展开";

    return _unfoldString;
}
-(void)setLimitLine:(NSInteger)limitLine{
    
    self.numberOfLines = limitLine;
    _limitLine = limitLine;
}

#pragma mark 设置点击长按背景颜色
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    if(self.isShowTapBackgouradColor == NO&&self.active)
        return;
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    NSRange range = [self stringContainsPoint:point];
    if(range.length>0){
        //设置背景颜色
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];

        [attributedString addAttribute:NSBackgroundColorAttributeName value:self.touchBackgouradColor range:range];
        
        self.attributedText = attributedString;
    }
}
-(void)removeBackgroundAttribute{
    
    if(self.isShowTapBackgouradColor == NO && self.active)
        return;
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    [attributedString removeAttribute:NSBackgroundColorAttributeName range:NSMakeRange(0, self.text.length)];
    
    self.attributedText = attributedString;
    
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self removeBackgroundAttribute];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self removeBackgroundAttribute];
}



-(void)ym_setupAttributeColorWithRange:(NSRange)range{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:self.normalColor range:range];
    

    NSString *str = NSStringFromRange(range);
    self.rangeArray = @[str];
    self.attributedText = attributedString;
    self.isSetupType = YES;
}

-(void)ym_setupAttributeColorWithArray:(NSArray<NSString *> *)array{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    for (NSString *str in array) {
        NSRange range = NSRangeFromString(str);
        [attributedString addAttribute:NSForegroundColorAttributeName value:self.normalColor range:range];
    }
    self.rangeArray = array;
    self.attributedText = attributedString;
     self.isSetupType = YES;
}
-(void)ym_setupAttributeColorWithTextArray:(NSArray<NSString *> *)array{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    for (NSString *str in array) {
        
        NSArray *rangeArr = [self rangeArrayWithString:str];
        
        for (int i=0; i<rangeArr.count;i++) {
            NSRange range =  NSRangeFromString(rangeArr[i]);
            
            [attributedString addAttribute:NSForegroundColorAttributeName value:self.normalColor range:range];
        }
        
    }
    self.rangeArray = array;
    self.attributedText = attributedString;
    
}

-(NSArray *)rangeArrayWithString:(NSString *)string{
    
    NSMutableArray *arr = [NSMutableArray array];
    
    NSRange range = NSMakeRange(0, self.text.length);
    
    while (1) {
        
        range = [self.text rangeOfString:string options:NSCaseInsensitiveSearch range:range];
        
        if(range.length==0){
            return arr;
        }
        [arr addObject:NSStringFromRange(range)];
        range.location = range.location + range.length;
        range.length = self.text.length - range.location;
    }
    
}

//点击label block
-(void)ym_clickActive:(void (^)(NSString *))active{
    
    self.active = active;
    
    for (UIGestureRecognizer *gest in self.gestureRecognizers) {
        if([gest isKindOfClass:[UITapGestureRecognizer class]]){
            return;
        }
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickLable:)];
    [self addGestureRecognizer:tap];
    
}
-(UITableView *) ym_getTableView{
    
    UITableViewCell *cell = [[YMCellManager defaultManager] ym_getCellWithView:self superIsTableView:YES];
    return (UITableView*)cell.superview.superview;
}
-(void)clickLable:(UIGestureRecognizer *)gest{
    
    CGPoint point = [gest locationInView:gest.view];
    NSRange range = [self stringContainsPoint:point];
    
    if(range.length>0){
        NSString *text = [self.text substringWithRange:range];
        [self removeBackgroundAttribute];
        
        if(self.limitLine>0){
            //点击展开
            if([text isEqualToString:self.unfoldString]){
                if(self.changeTypeBlock)
                    self.changeTypeBlock(YMLabelShowTypeUnfold);
                return;
            }
            //点击收起
            if([text isEqualToString:self.packupString]){
                if(self.changeTypeBlock)
                    self.changeTypeBlock(YMLabelShowTypePackup);
                return;
            }
        }
        self.active(text);
    }
    
}
//添加尾部文字
-(void)ym_addSternTextWithString:(NSString *)text length:(NSInteger)length{
    
    NSMutableAttributedString *arrStr = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
  
    //展开
    if(length>0){
        NSString *str = [NSString stringWithFormat:@"... %@",text];
        [arrStr replaceCharactersInRange:NSMakeRange(length-str.length,str.length) withString:str];

        [arrStr deleteCharactersInRange:NSMakeRange(length,arrStr.length-length)];

    }else{
        //收起
        [arrStr appendAttributedString:[[NSAttributedString alloc] initWithString:text]];
        length = arrStr.length;
      
    }
      [arrStr addAttribute:NSForegroundColorAttributeName value:self.normalColor range:NSMakeRange(length-2,2)];

    self.attributedText = arrStr;

}

//传递showTypw
-(void)ym_changeShowType:(ym_changeType)changeType{
    
    self.changeTypeBlock = changeType;
}
#pragma mark 计算
-(void)ym_countSize{

    //当前状态为展开,显示收起
    if(self.ym_showtype == YMLabelShowTypeUnfold){
        self.numberOfLines = 0;
        [self ym_addSternTextWithString:self.packupString length:0];
    }
    if(self.ym_showtype == YMLabelShowTypePackup)
        self.numberOfLines = self.limitLine;
    
    CGSize expectSize = [self sizeThatFits:CGSizeMake(self.ym_width,MAXFLOAT)];
    
    if(self.limitLine>0){
        CGSize size = [self.text boundingRectWithSize:CGSizeMake(self.ym_width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
        
        //判断是否超出最大行
        if(expectSize.height < size.height){
            //添加展开字符串
            self.ym_showtype = YMLabelShowTypePackup;
            NSMutableString *strM = [NSMutableString string];
            NSArray *arr = [self rowTextArrayWithNumber:self.numberOfLines];
            
            for (int i=0; i<self.numberOfLines; i++) {
                [strM appendString:arr[i]];
            }
            self.fullText = self.text;
            [self ym_addSternTextWithString:self.unfoldString length:strM.length];
        }
    }
    //循环利用 每次完设置类型为None
    if(self.changeTypeBlock)
        self.changeTypeBlock(YMLabelShowTypeNone);
    
    self.ym_showtype = YMLabelShowTypeNone;

    self.ym_height = expectSize.height;
    self.ym_width = self.ym_width;

}

//根据字符串长度获取字符串大小
-(CGSize)getSizeWithtext:(NSString *)text{
    
   
    NSDictionary *dict = @{
                           NSFontAttributeName:self.font
                           };
    return [text sizeWithAttributes:dict];
    
}

//返回一个lable每行文本数组 number = 返回的最大行
-(NSArray *)rowTextArrayWithNumber:(NSInteger)number{
    
    NSMutableArray *arrM = [NSMutableArray array];
    NSInteger loc = 0;
    
    //计算一行至少有几个字体
    NSInteger num = self.ym_width /(self.font.pointSize+1);
    for (int i=0; i<self.text.length; i++) {
        //优化
        if(i-loc <num &&num+i<self.text.length){
            i+=num;
        }
        NSString *text = [self.text substringWithRange:NSMakeRange(loc,i-loc)];
        CGSize pointSize = [self getSizeWithtext:text];
        
        if((NSInteger)((pointSize.width)/self.ym_width)>0){
            [arrM addObject:[text substringToIndex:text.length-1]];
            if(arrM.count == number)
                return arrM;
            loc = i-1;
        }
    }
    [arrM addObject:[self.text substringWithRange:NSMakeRange(loc,self.text.length-loc)]];
    
    return arrM;
}

//判断点是在字符串内
-(BOOL)ym_textContainsPoint:(NSRange)range point:(CGPoint)point{
    
  
    NSString *text = [self.text substringWithRange:NSMakeRange(0,range.location)];
    CGSize pointSize = [self getSizeWithtext:text];
    
    CGFloat x = pointSize.width;
    CGFloat y = pointSize.height - self.font.pointSize;

    CGSize size = [self getSizeWithtext:[self.text substringWithRange:range]];
    
    
    //判断有没跨行
    CGFloat temp = x; //不包含文字 location之前所有文字的大小
    CGFloat temp2 = x+size.width;//包含文字
    NSInteger tempRowNumber = 0; //不包含文字在第几行 判断是否跨行
    NSInteger number = 0;  //包含文字在第几行
    //获取每行的文字数组
    NSArray *arr = [self rowTextArrayWithNumber:MAXFLOAT];
    BOOL issetupTemp = false;
    //精确获取文字在的行数
    for (int i=0; i<arr.count; i++) {
        NSString *str = arr[i];
        CGFloat rowWidth = [self getSizeWithtext:str].width;
        temp -= rowWidth;
        temp2 -= rowWidth;
        //只要设定一次 
        if(temp<-0.001 && issetupTemp == false){
            issetupTemp = true;
            tempRowNumber = i;
          
        }
        //有加本身大小 所以最多=0
        if(temp2<=0.001){
            number = i;
            break;
        }
        //文字位置减去前几行的length
        range.location -= str.length;
    }
    //判断文字是否跨行
    if(tempRowNumber !=number){
        CGRect rect;
        for (NSInteger i=0; i<arr.count; i++) {
            NSString *str = arr[i];
            CGFloat rowWidth = [self getSizeWithtext:str].width;
            if(i==0){
                rect = CGRectMake(x,y,rowWidth-x,size.height);
                if(CGRectContainsPoint(rect, point)==YES)
                    return YES;
            }
            
            //每次减去上一行的宽度
            size.width -= rowWidth-x;
            y += pointSize.height;
            x = 0;
            if(size.width<0)
                return NO;
            rect = CGRectMake(x,y,size.width,size.height);
            if(CGRectContainsPoint(rect, point)==YES)
                return YES;
        }
        return NO;
    }
    //没跨行情况下

    NSString *str = arr[number];

    pointSize = [self getSizeWithtext:[str substringWithRange:NSMakeRange(0, range.location)]];

    x = pointSize.width;
    y = (pointSize.height - self.font.pointSize)+(number*pointSize.height);
    size = [self getSizeWithtext:[str substringWithRange:range]];
 
    return CGRectContainsPoint(CGRectMake(x, y, size.width,size.height), point);
    
}
//判断点是否在文字内
-(NSRange) stringContainsPoint:(CGPoint)point{
    

    for (NSString *str in self.rangeArray) {

        if(self.isSetupType == NO){
            //传入的是字符串模式
            NSArray *rangeArr = [self rangeArrayWithString:str];
            for (int i=0; i<rangeArr.count;i++) {
                NSRange range =  NSRangeFromString(rangeArr[i]);
                if([self ym_textContainsPoint:range point:point]==YES)
                    return range;
            }
        }
        else{
            //传入是具体模式
            NSRange range = NSRangeFromString(str);
            if([self ym_textContainsPoint:range point:point]==YES)
                return range;
        }
        
    }
    //判断展开 收起
    if(self.limitLine>0){
        if([self ym_textContainsPoint:NSMakeRange(self.text.length-2,2) point:point]==YES){
            return NSMakeRange(self.text.length-2,2);
        }
    }
   
    return NSMakeRange(0, 0);
}


@end
