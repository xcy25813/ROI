//
//  ROIFilter.h
//  ROI
//
//  Copyright (c) 2019 Chunyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OsiriXAPI/PluginFilter.h>

@interface ROIFilter : PluginFilter {

}

- (long) filterImage:(NSString*) menuName;

@end
