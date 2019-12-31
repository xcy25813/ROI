//
//  ROIFilter.m
//  ROI
//
//  Copyright (c) 2019 Chunyu. All rights reserved.
//

#import "ROIFilter.h"

@implementation ROIFilter

- (void) initPlugin
{
}

- (long) filterImage:(NSString*) menuName
{
    /*
	ViewerController	*new2DViewer;
	
	// In this plugin, we will simply duplicate the current 2D window!
	
	new2DViewer = [self duplicateCurrent2DViewerWindow];
	
	if( new2DViewer) return 0; // No Errors
	else return -1;
    */
   
    NSString * filepath = NSHomeDirectory();//当前工程目录
    NSLog(@"当前文件路径:%@",filepath);
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"YYYY.MM.dd.hh:mm:ss:SS"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    dateString = [dateString stringByAppendingString:@".csv"];
    filepath = [filepath stringByAppendingPathComponent:@"Desktop/"];
    filepath = [filepath stringByAppendingPathComponent:dateString];
    NSLog(@"文件路径:%@",filepath);
    NSFileManager *file = [NSFileManager defaultManager];
    
    if ([file fileExistsAtPath:filepath]) {
        NSLog(@"文件已存在");
    }else{
        BOOL sucess = [file createFileAtPath:filepath contents:nil attributes:nil];
        if (sucess == 1) {
            NSLog(@"文件创建成功");
        }else{
            NSLog(@"文件创建失败");
        }
    }
    
    NSError *error=nil;
    NSString *data = @"id,value,pointx,pointy,actualx,actualy,actualz,diffx,diffy,diffz\n";
    [data writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:&error];
    //向文件里面写数据，写数据之前把字符串转换成UTF8编码并且存起来
    
    NSMutableArray  *roiSeriesList  = [viewerController roiList];
    NSArray         *pixListSum = [viewerController pixList];
    int count=[pixListSum count];
    NSLog(@"imagecount:%d",count);
    NSLog(@"seriescount:%lu",(unsigned long)[roiSeriesList count]);
    int index=0;
    float basex;
    float basey;
    float basez;
    for(int i=0;i<count;i++){
        
        NSMutableArray  *roiImageList = [roiSeriesList objectAtIndex: i];
        NSLog(@"roicount:%lu",(unsigned long)[roiImageList count]);
        for (int i = 0; i < [roiImageList count]; i++) {
            
            ROI *curROI = [roiImageList objectAtIndex: [roiImageList count]-i-1];
            //NSImage *image=[curROI layerImage];
            
            
            NSMutableArray *points=[curROI points];
            //[points class];
            MyPoint *a=points[0];
            //NSMutableArray  *zPositions=[curROI zPositions];
            NSPoint o=[a point];
           // [curROI centroid]
            
            //NSLog(@"point:%@",[[points objectAtIndex: 0] objectAtIndex:0] );
            float value=[curROI min];
            NSLog(@"x:%f",o.x);
            NSLog(@"y:%f",o.y);
            NSLog(@"min:%f",[curROI min]);
            //NSLog(@"position:%@",zPositions[0]);
            NSPoint orig=[curROI imageOrigin];
            NSRect rec=[curROI rect];
            
            
            float location[3];
            [[[viewerController imageView] curDCM] convertPixX: (float) o.x pixY: (float) o.y toDICOMCoords: (float*) location pixelCenter: YES];
            
            float xmm = location[0];
            float ymm = location[1];
            float zmm = location[2];
            
          
             NSLog(@"x:%f",xmm);
             NSLog(@"y:%f",ymm);
             NSLog(@"z:%f",zmm);
            
            
           
            
            
            //跳到文件末尾
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filepath];
            [fileHandle seekToEndOfFile];
            //NSData * u =[fileHandle readDataToEndOfFile] ;
            if(index==0){
                basex=xmm;
                basey=ymm;
                basez=zmm;
            }
            index++;
            NSString *ind = [NSString stringWithFormat:@"%d",index];
            NSString *s1 = [NSString stringWithFormat:@"%f",value];
            NSString *sx = [NSString stringWithFormat:@"%f",o.x];
            NSString *sy = [NSString stringWithFormat:@"%f",o.y];
            NSString *sxmm = [NSString stringWithFormat:@"%f",xmm];
            NSString *symm = [NSString stringWithFormat:@"%f",ymm];
            NSString *szmm = [NSString stringWithFormat:@"%f",zmm];
            NSString *diffx = [NSString stringWithFormat:@"%f",xmm-basex];
            NSString *diffy = [NSString stringWithFormat:@"%f",ymm-basey];
            NSString *diffz = [NSString stringWithFormat:@"%f",zmm-basez];
            
            
            NSString *newString = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",ind,s1,sx,sy,sxmm,symm,szmm,diffx,diffy,diffz];
            [fileHandle writeData:[newString dataUsingEncoding:NSUTF8StringEncoding]];
            //NSString *str1 = [[NSString alloc] initWithData:u encoding:NSUTF8StringEncoding];
            //NSLog(@"data = %@",str1);
            
            
            /*
            NSLog(@"width:%d",[curROI textureWidth]);
             //NSLog(@"origin:%@",[curROI imageOrigin]);
            //NSLog(@"buffer:%s",[curROI textureBuffer]);
            NSLog(@"opacity:%f",[curROI opacity]);
            NSLog(@"type:%ld",[curROI type]);
             NSLog(@"mode:%ld",[curROI ROImode]);
             //NSLog(@"rect:%@",[curROI rect]);
            NSLog(@"data:%@",[curROI data]);
            NSString *comm=[curROI comments];
            NSLog(@"comments:%@",[curROI comments]);
            NSLog(@"pix:%@",[curROI pix]);
            NSLog(@"view:%@",[curROI curView]);
            NSLog(@"mouse:%f",[curROI mousePosMeasure]);
            NSLog(@"NScolor:%@",[curROI NSColor]);
           // NSLog(@"rgbcolor:%@",[curROI rgbcolor]);
            NSLog(@"min:%f",[curROI min]);
            //NSLog(@"image:%@",image);
             //NSLog(@"zuobiao:%@",[points[0] objectAtIndex:0]);
            //NSLog(@"xinxi:%@",[curROI name]);
            //[curROI displayTexture];
            
            
            //NSLog([@"xinxi:%@",[curROI imageOrigin]);
           */
        }
    }
    
   
    return 0;
    
}

@end
