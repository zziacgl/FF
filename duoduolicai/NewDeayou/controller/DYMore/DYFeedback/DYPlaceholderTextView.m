//
//  DYPlaceholderTextView.m
//  NewDeayou
//
//  Created by DiyouiOS3 on 15/4/13.
//  Copyright (c) 2015年 wayne. All rights reserved.
//

#import "DYPlaceholderTextView.h"
#define PLACEHOLDER_LEFT_SPACE 5
#define PLACEHOLDER_TOP_SPACE  5
#define IS_IOS7                [[[UIDevice currentDevice] systemVersion] floatValue]>=7.0

@interface DYPlaceholderTextView()<UITextViewDelegate>
@property (assign,nonatomic) CGFloat originalBorderWidth;           //原始宽度
@property (assign,nonatomic) CGFloat editBorderWidth;               //编辑宽度
@property (assign,nonatomic) CGColorRef originalBorderColor;        //原始颜色
@property (assign,nonatomic) CGColorRef editBorderColor;            //编辑颜色

//清空占位符
-(void)clearPlaceholder;
@end;
@implementation DYPlaceholderTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        ;
        if (!(IS_IOS7))
        {
            self.contentInset = UIEdgeInsetsMake(7, 0, 0, 0);
        }
        
        self.originalBorderWidth =1;
        self.editBorderWidth = 2;
        self.layer.borderWidth = self.originalBorderWidth;
        self.layer.cornerRadius = 5;
        
        self.originalBorderColor= [UIColor lightGrayColor].CGColor;
        self.editBorderColor = kMainColor.CGColor;
        self.layer.borderColor = self.originalBorderColor;
        UILabel *tempLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.origin.x+PLACEHOLDER_LEFT_SPACE+(IS_IOS7?0:2), self.bounds.origin.y+PLACEHOLDER_TOP_SPACE, self.bounds.size.width-PLACEHOLDER_LEFT_SPACE, self.bounds.size.height-PLACEHOLDER_TOP_SPACE)];
        tempLabel.backgroundColor = [UIColor clearColor];
        tempLabel.textColor = [UIColor lightGrayColor];
        tempLabel.font = [UIFont systemFontOfSize:10];
        self.placeholderLabel = tempLabel;
        [self addSubview:tempLabel];
        [tempLabel release];
        tempLabel = nil;
        

        self.delegate = self;
        [self addObserver:self forKeyPath:@"placeholder" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
        [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    return self;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
//    self.layer.borderColor = kMainColor.CGColor;
    self.layer.borderColor = kMainColor.CGColor;
    self.layer.borderWidth = self.editBorderWidth;
    if (self.placeholderTextViewDelegate&&[self.placeholderTextViewDelegate respondsToSelector:@selector(placeholderTextViewDidBeginEditing:)])
    {
        [self.placeholderTextViewDelegate placeholderTextViewDidBeginEditing:self];
    }
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0 )
    {
        if (self.placeholder)
        {
            self.placeholderLabel.text = self.placeholder;
            
        }
        else
        {
            [self clearPlaceholder];
        }
    }
    else
    {
        [self clearPlaceholder];
    }
    if (self.placeholderTextViewDelegate&&[self.placeholderTextViewDelegate respondsToSelector:@selector(placeholderTextViewDidChange:)])
    {
        [self.placeholderTextViewDelegate placeholderTextViewDidChange:self];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.layer.borderColor = self.originalBorderColor;
    self.layer.borderWidth = self.originalBorderWidth;
    if (self.placeholderTextViewDelegate&&[self.placeholderTextViewDelegate respondsToSelector:@selector(placeholderTextViewDidEndEditing:)])
    {
        [self.placeholderTextViewDelegate placeholderTextViewDidEndEditing:self];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"placeholder"])
    {
//        [self.placeholderLabel adjustWithText:[change objectForKey:@"new"] font:self.placeholderLabel.font];
        self.placeholderLabel.text = [change objectForKey:@"new"];
        self.placeholderLabel.numberOfLines = 0;
        CGSize fontsize = [self.placeholderLabel.text sizeWithFont:self.placeholderLabel.font];
        CGSize size = CGSizeMake(self.placeholderLabel.frame.size.width, fontsize.height*2);
        CGSize lableSize = [self.placeholderLabel.text sizeWithFont:self.placeholderLabel.font constrainedToSize:size];
        self.placeholderLabel.frame = CGRectMake(self.placeholderLabel.frame.origin.x, self.placeholderLabel.frame.origin.y,lableSize.width, lableSize.height);
    }
    if ([keyPath isEqualToString:@"text"])
    {
        [self clearPlaceholder];
    }
}

-(void)clearPlaceholder
{
    self.placeholderLabel.text = @"";
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"placeholder"];
    [self removeObserver:self forKeyPath:@"text"];
    [_placeholder release];
    _placeholder = nil;
    [_placeholderLabel release];
    _placeholderLabel = nil;
    [super dealloc];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
