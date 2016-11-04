//
//  ViewController.m
//  PickerViewDemo
//
//  Created by IRIGI-HuiMin on 11/3/16.
//  Copyright © 2016 IRIGI-HuiMin. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,retain)NSString *currentY;
@property (nonatomic,retain)NSString *currentM;
@property (nonatomic,retain)NSString *currentD;
@property (nonatomic,retain)NSString *currentH;

@property (nonatomic,retain)NSString *selectY;
@property (nonatomic,retain)NSString *selectM;
@property (nonatomic,retain)NSString *selectD;
@property (nonatomic,retain)NSString *selectH;

//@property (nonatomic,assign)NSInteger c0row;
@property (nonatomic,assign)NSInteger c1row;
@property (nonatomic,assign)NSInteger c2row;
@property (nonatomic,assign)NSInteger c3row;

@property (nonatomic,retain)UILabel *showL;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.view.backgroundColor = [UIColor orangeColor];
    
    //计算当前年 月 日
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm"];
    NSString *string = [formatter stringFromDate:date];
    NSMutableArray *dateArr = [[string componentsSeparatedByString:@"."] mutableCopy];
    self.currentY = dateArr.firstObject;
    [dateArr removeObjectAtIndex:0];
    self.currentM = dateArr.firstObject;
    [dateArr removeObjectAtIndex:0];
    NSString *shortStr = dateArr.lastObject;
    NSMutableArray *shortArr = [[shortStr componentsSeparatedByString:@" "] mutableCopy];
    self.currentD = shortArr.firstObject;
    NSString *lastStr = shortArr.lastObject;
    NSMutableArray *lastArr = [[lastStr componentsSeparatedByString:@":"] mutableCopy];
    self.currentH = lastArr.firstObject;
    NSString *minute = lastArr.lastObject;
    if ([minute integerValue]>30)
    {
        self.currentH = [NSString stringWithFormat:@"%ld",[self.currentH integerValue]+1];
    }
    self.currentH = [NSString stringWithFormat:@"%ld", [self.currentH integerValue]+1];
    if ([self.currentH isEqualToString:@"24"])
    {
        self.currentH = @"1";
    }
    
    
    self.selectY = self.currentY;
    self.selectM = self.currentM;
    self.selectD = self.currentD;
    self.selectH = self.currentH;
    
    
    UIPickerView *yearPV = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 100, 400, 200/2)];
    yearPV.delegate = self;
    yearPV.dataSource = self;
    [self.view addSubview:yearPV];
    
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 300, 400, 50)];
    label.text = [NSString stringWithFormat:@"当前时间 %@年%@月%@日%@",self.currentY,self.currentM,self.currentD,self.currentH];
    [self.view addSubview:label];

    
    self.showL = [[UILabel alloc]initWithFrame:CGRectMake(0, 400, 400, 50)];
    [self.view addSubview:self.showL];
}

#pragma mark - UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([self.selectY isEqualToString:self.currentY])
    {
        if (component == 0)
        {
            return 2;
        }
        else if (component == 1)
        {
            NSInteger mNum = 12-[self.currentM integerValue]+1;
            
            return mNum;
        }
        else if (component == 2)
        {
            if ([self.selectM isEqualToString:self.currentM])
            {
                
                NSInteger dNum = [self dayForMonth:[self.currentM integerValue]];
                
                return dNum;
            }
            else
            {
                return [self dayForMonth:[self.selectM integerValue]];
            }
            
        }
        else
        {
            
            if ( [self.selectM isEqualToString:self.currentM] && [self.selectD isEqualToString:self.currentD])
            {
                
                NSInteger hNum = 24-[self.currentH integerValue]+1;
                
                return hNum;
            }
            
            return 24;
        }
        
    }
    else
    {
        if (component == 0)
        {
            return 2;
        }
        else if (component == 1)
        {
            return 12;
        }
        else if (component == 2)
        {
            return [self dayForMonth:[self.selectM integerValue]];
        }
        else
        {
            return 24;
        }
        
    }
    
    
    
    
}

- (NSInteger)dayForMonth:(NSInteger)month
{
    NSInteger dNum=0;
    switch (month)
    {
        case 4:
        case 6:
        case 9:
        case 11:
            dNum = 30;
            break;
        case 2:
            // 计算是否为闰年
        {
            NSInteger Y = 0;
            if ([self.selectY isEqualToString:self.currentY])
            {
                Y = [self.currentY integerValue];
            }
            
            Y = [self.selectY integerValue];
            
            
            if (((Y%4==0) && (Y%100!=0))|| (Y%400==0))
            {
                dNum = 29;
            }
            else
            {
                dNum = 28;
            }
            
            
        }
            break;
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            dNum = 31;
            break;
    }
    
    if ([self.selectY isEqualToString:self.currentY] && month == [self.currentM integerValue])
    {
        return dNum-[self.currentD integerValue]+1;
    }
    
    return dNum;
}

#pragma mark - UIPickerViewDelegate
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (component == 0)
    {
        return 100;
    }
    else if (component == 1)
    {
        return 50;
    }
    else if (component == 2)
    {
        return 50;
    }
    else
    {
        return 414-100-50-50;
    }
    
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if ([self.selectY isEqualToString:self.currentY])
    {
        if (component == 0)
        {
            return [NSString stringWithFormat:@"%ld",[self.currentY integerValue] + row];
        }
        else if (component == 1)
        {
            
            //            NSLog(@"return monthTitle %@------ %ld",[NSString stringWithFormat:@"%ld",[self.currentM integerValue] + row],row);
            return [NSString stringWithFormat:@"%ld",[self.currentM integerValue] + row];
        }
        else if (component == 2)
        {
            if ([self.selectM isEqualToString:self.currentM])
            {
                return [NSString stringWithFormat:@"%ld",[self.currentD integerValue]+row];
            }
            else
            {
                return [NSString stringWithFormat:@"%ld",1+row];
            }
            //            NSLog(@"return dayTitle %@",[NSString stringWithFormat:@"%ld",[self.currentD integerValue]+row]);
        }
        else
        {
            
            if ( [self.selectM isEqualToString:self.currentM] && [self.selectD isEqualToString:self.currentD])
            {
                NSInteger hNum = [self.currentH integerValue]+row;
                
                if (hNum > 24)
                {
                    return [NSString stringWithFormat:@"%ld:00-%ld:00",hNum-24,hNum-24+1];
                    
                }
                
                if (hNum == 24)
                {
                    return [NSString stringWithFormat:@"%ld:00-%ld:00",hNum,hNum-24+1];
                    
                }
                return [NSString stringWithFormat:@"%ld:00-%ld:00",hNum,hNum+1];
            }
            else
            {

                if (1+row == 24)
                {
                    return [NSString stringWithFormat:@"%ld:00-%ld:00",1+row,1+row-24+1];
                }
                return [NSString stringWithFormat:@"%ld:00-%ld:00",1+row,1+row+1];
            }
            
            
        }
    }
    else
    {
        if (component == 0)
        {
            
            return [NSString stringWithFormat:@"%ld",[self.currentY integerValue] + row];
        }
        else if (component == 1)
        {
            return [NSString stringWithFormat:@"%ld",1 + row];
        }
        else if (component == 2)
        {
            return [NSString stringWithFormat:@"%ld",1+row];
        }
        else
        {
        
            if (1+row == 24)
            {
                return [NSString stringWithFormat:@"%ld:00-%ld:00",1+row,1+row-24+1];
            }
            
            return [NSString stringWithFormat:@"%ld:00-%ld:00",1+row,1+row+1];
        }
        
    }
    
}


//- (NSInteger)workingTimeForRow:(NSInteger)row
//{
//    //上班时间7：00-18：00
//
//}

// 当改变年到当年时，
// 如果月日时未操作过,将月日时改为当前时间
// 如果这三个操作过任何一个，将操作过的改到指定月日时
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0)
    {
        if (row == 0)
        {

            self.selectY = self.currentY;
            
            [self changeMonth];
            
        }
        else
        {
            self.selectY = [NSString stringWithFormat:@"%ld",[self.currentY integerValue]+1];
            self.selectM = [NSString stringWithFormat:@"%ld",self.c1row+1];
            
        }
        
        [self changeDate];
        
        [self changeHour];
        
        
    }
    else if (component == 1)
    {
        
        self.c1row = row;
        if ([self.selectY isEqualToString:self.currentY])
        {
            self.selectM = [NSString stringWithFormat:@"%02ld",[self.currentM integerValue] + row];

        }
        else
        {
            self.selectM = [NSString stringWithFormat:@"%02ld",1 + row];
        
        }
        
        [self changeDate];
        
        [self changeHour];
        
    }
    else if (component == 2)
    {
        self.c2row = row;
        if ([self.selectY isEqualToString:self.currentY]&& [self.selectM isEqualToString:self.currentM])
        {
            
            self.selectD = [NSString stringWithFormat:@"%02ld",[self.currentD integerValue] + row];
        }
        else
        {
            self.selectD = [NSString stringWithFormat:@"%02ld",1 + row];
            
            [self changeHour];
        }
    }
    else
    {
        self.c3row = row;
        if ([self.selectY isEqualToString:self.currentY]&& [self.selectM isEqualToString:self.currentM] && [self.selectD isEqualToString:self.currentD])
        {
            NSInteger dNum = [self.currentH integerValue]+row;
            
            if (dNum > 24)
            {
                self.selectH = [NSString stringWithFormat:@"%02ld",dNum-24];
                
            }
            self.selectH = [NSString stringWithFormat:@"%02ld",dNum];
        }
        else
        {
            self.selectH = [NSString stringWithFormat:@"%02ld",1+row];
        }
    }
    
    [pickerView reloadAllComponents];
 
    self.showL.text = [NSString stringWithFormat:@"当前选择时间 %@年%@月%@日%@",self.selectY,self.selectM,self.selectD,self.selectH];
    
}


- (void)changeMonth
{
    if (1+self.c1row < [self.currentM integerValue])
    {
        self.selectM = self.currentM;
    }
    else
    {
        self.selectM = [NSString stringWithFormat:@"%ld",self.c1row+1];
    }
}

- (void)changeDate
{
    if ([self.selectY isEqualToString:self.currentY] && [self.selectM isEqualToString:self.currentM])
    {
        if (self.c2row == 0)
        {
            self.selectD = self.currentD;
        }
        else
        {
            if (1+self.c2row < [self.currentD integerValue])
            {
                self.selectD = [NSString stringWithFormat:@"%02ld",1+self.c2row];
            }
            else
            {
                NSInteger dNum = [self dayForMonth:[self.selectM integerValue]];
                
                if (self.c2row+1 >= dNum)
                {
                    self.selectD = [NSString stringWithFormat:@"%02ld",dNum];
                }
                else
                {
                    self.selectD = [NSString stringWithFormat:@"%02ld",self.c2row+1];
                }
                
            }

        }
    }
    else
    {
        if (1+self.c2row < [self.currentD integerValue])
        {
            self.selectD = [NSString stringWithFormat:@"%02ld",1+self.c2row];
        }
        else
        {
            NSInteger dNum = [self dayForMonth:[self.selectM integerValue]];
            
            if (self.c2row+1 >= dNum)
            {
                self.selectD = [NSString stringWithFormat:@"%02ld",dNum];
            }
            else
            {
                self.selectD = [NSString stringWithFormat:@"%02ld",self.c2row+1];
            }
            
        }
    }
    


}

- (void)changeHour
{
    
    if ([self.selectY isEqualToString:self.currentY] && [self.selectM isEqualToString:self.currentM] && [self.selectD isEqualToString:self.currentD])
    {
        if (self.c3row == 0)
        {
            self.selectH = self.currentH;
        }
        else
        {

            if (1+self.c3row < [self.currentH integerValue])
            {
                self.selectH = [NSString stringWithFormat:@"%02ld",1+self.c3row];
            }
            else
            {
                if (self.c3row+1 >= 24)
                {
                    self.selectH = [NSString stringWithFormat:@"%02d",24];
                    
                }
                else
                {
                    self.selectH = [NSString stringWithFormat:@"%02ld",1+self.c3row];
                }
            }
        }
    }
    else
    {

        if (1+self.c3row >= 24)
        {
            self.selectH = [NSString stringWithFormat:@"%02d",24];
            
        }
        else
        {
            self.selectH = [NSString stringWithFormat:@"%02ld",1+self.c3row];
        }
    
    }
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
