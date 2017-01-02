//
//  YMComment.m
//  YMFastDrawCell
//
//  Created by 夜幕 on 16/12/27.
//  Copyright © 2016年 yemu. All rights reserved.
//

#import "YMCommentLabel.h"

@interface YMCommentLabel()

@property (nonatomic,strong) NSArray *rangeArray;
@property (nonatomic,strong) void (^active)(NSString *);

@end
@implementation YMCommentLabel

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
}

-(void)ym_setupAttributeColorWithArray:(NSArray<NSString *> *)array{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    for (NSString *str in array) {
        NSRange range = NSRangeFromString(str);
        [attributedString addAttribute:NSForegroundColorAttributeName value:self.normalColor range:range];
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
-(void)clickLable:(UIGestureRecognizer *)gest{
    
    CGPoint point = [gest locationInView:gest.view];
    NSRange range = [self stringContainsPoint:point];
    if(range.length>0){
        self.active([self.text substringWithRange:range]);
        [self removeBackgroundAttribute];
    }
    
}
#pragma mark 计算
-(CGFloat)ym_getContentHeight{

    CGSize expectSize = [self sizeThatFits:CGSizeMake(self.ym_width, MAXFLOAT)];
    self.ym_height = expectSize.height;
    self.ym_width = expectSize.width;
    
    return self.ym_height;
}
//根据字符串长度获取字符串大小
-(CGSize)getSizeWithtext:(NSString *)text{
    
   
    NSDictionary *dict = @{
                           NSFontAttributeName:self.font
                           };
    return [text sizeWithAttributes:dict];
    
}

//返回一个lable每行文本数组
-(NSArray *)rowTextArray{
    
    NSMutableArray *arrM = [NSMutableArray array];
    NSInteger loc = 0;
    NSString *str = self.text;
    for (int i=0; i<self.text.length; i++) {
        
        NSString *text = [self.text substringWithRange:NSMakeRange(loc,i-loc)];
        CGSize pointSize = [self getSizeWithtext:text];
        if((NSInteger)(pointSize.width/self.ym_width)>0){
       
            [arrM addObject:[str substringToIndex:i-loc-1]];
            str = [str substringFromIndex:i-loc-1];
            loc = i;
        }
    }
    
    [arrM addObject:str];
    return arrM;
}

//判断点是在字符串内
-(BOOL)ym_textContainsPoint:(NSRange)range point:(CGPoint)point{
    
    NSString *text = [self.text substringWithRange:NSMakeRange(0,range.location)];
    CGSize pointSize = [self getSizeWithtext:text];
    
    CGFloat x = pointSize.width;
    CGFloat y = pointSize.height - self.font.pointSize;
    
    CGSize size = [self getSizeWithtext:[self.text substringWithRange:range]];
    //在第几行
    NSInteger number = (x+size.width)/ self.ym_width;
    
    //判断有没跨行
    CGFloat temp = x;
    //获取每行的文字数组
    NSArray *arr = [self rowTextArray];
    NSInteger tempRowNumber;
    
    //精确获取文字在的行数
    for (int i=0; i<arr.count; i++) {
        NSString *str = arr[i];
        CGFloat rowWidth = [self getSizeWithtext:str].width;
        temp -= rowWidth;
        if(temp<0){
            tempRowNumber=i;
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
        NSRange range = NSRangeFromString(str);
        if(range.length ==0){
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
            if([self ym_textContainsPoint:range point:point]==YES)
                return range;
        }
        
    }
    return NSMakeRange(0, 0);
}


@end
