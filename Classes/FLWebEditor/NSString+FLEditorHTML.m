//
//  NSString+FLEditorHTML.m
//  BallOfBitcoin
//
//  Created by Shangen Zhang on 2018/5/18.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "NSString+FLEditorHTML.h"


/**
  通过 类加载bundle 的空类
 */
@interface __FL_WebEditor_BundleRederence_Class : NSObject
@end
@implementation __FL_WebEditor_BundleRederence_Class
@end



@implementation NSString (FLEditorHTML)
+ (NSString *)fl_loadEditorHTMLString {
    
    //Define correct bundle for loading resources
    NSBundle* bundle = [NSBundle bundleForClass:[__FL_WebEditor_BundleRederence_Class class]];
    
    //Create a string with the contents of editor.html
    NSString *filePath = [bundle pathForResource:@"FLEditor" ofType:@"html"];
    NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
    NSString *htmlString = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    
    //Add jQuery.js to the html file
    NSString *jquery = [bundle pathForResource:@"jQuery" ofType:@"js"];
    NSString *jqueryString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:jquery] encoding:NSUTF8StringEncoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- jQuery -->" withString:jqueryString];
    
    //Add JSBeautifier.js to the html file
    NSString *beautifier = [bundle pathForResource:@"JSBeautifier" ofType:@"js"];
    NSString *beautifierString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:beautifier] encoding:NSUTF8StringEncoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!-- jsbeautifier -->" withString:beautifierString];
    
    //Add FLRichTextEditor.js to the html file
    NSString *source = [bundle pathForResource:@"FLRichTextEditor" ofType:@"js"];
    NSString *jsString = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:source] encoding:NSUTF8StringEncoding];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<!--editor-->" withString:jsString];
    
    return htmlString;
}

- (NSString *)fl_htmlStringRemoveQuotes {
    NSString *html = self.copy;
    html = [html stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    html = [html stringByReplacingOccurrencesOfString:@"“" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"”" withString:@"&quot;"];
    html = [html stringByReplacingOccurrencesOfString:@"\r"  withString:@"\\r"];
    html = [html stringByReplacingOccurrencesOfString:@"\n"  withString:@"\\n"];
    return html;
}

- (NSString *)fl_stringByDecodingURLFormat {
    NSString *result = [self stringByReplacingOccurrencesOfString:@"+" withString:@" "];

    result = [result stringByReplacingPercentEscapesUsingEncoding:NSStringEncodingConversionAllowLossy];
    
    return result;
}

@end
