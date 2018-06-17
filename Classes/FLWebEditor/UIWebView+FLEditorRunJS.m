//
//  UIWebView+FLEditorRunJS.m
//  BallOfBitcoin
//
//  Created by Shangen Zhang on 2018/5/18.
//  Copyright © 2018年 Flame. All rights reserved.
//

#import "UIWebView+FLEditorRunJS.h"



#pragma mark - RGB COLOR UITIL
typedef struct{
    float r;
    float g;
    float b;
} FLRGBColor;
static int fl_HexColorFromRGBColor(const FLRGBColor* rgb){
    return (int)(rgb->r*255.0f) << 16 | (int)(rgb->g*255.0f) << 8 | (int)(rgb->b*255.0f) << 0;
}
static void fl_RGBColorFromUIColor(const UIColor* uiColor,FLRGBColor* rgb){
    const CGFloat* components = CGColorGetComponents(uiColor.CGColor);
    if(CGColorGetNumberOfComponents(uiColor.CGColor) == 2){
        rgb->r = components[0];
        rgb->g = components[0];
        rgb->b = components[0];
    }else{
        rgb->r = components[0];
        rgb->g = components[1];
        rgb->b = components[2];
    }
}
static int fl_HexColorFromUIColor(const UIColor* color){
    FLRGBColor rgb_color;
    fl_RGBColorFromUIColor(color, &rgb_color);
    return fl_HexColorFromRGBColor(&rgb_color);
}



#pragma mark - UIWebView(FLEditorRunJS) implementation

@implementation UIWebView (FLEditorRunJS)

- (NSString *)getText {
    return [self stringByEvaluatingJavaScriptFromString:@"fl_editor.getText();"];
}
- (NSString *)fl_getHTML {
    return [self stringByEvaluatingJavaScriptFromString:@"fl_editor.getHTML();"];
}


- (NSString *)tidyHTML:(NSString *)html shouldFormat:(BOOL)isformatHTML {
    html = [html stringByReplacingOccurrencesOfString:@"<br>" withString:@"<br />"];
    html = [html stringByReplacingOccurrencesOfString:@"<hr>" withString:@"<hr />"];
    if (isformatHTML) {
        html = [self stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"style_html(\"%@\");", html]];
    }
    return html;
}

- (void)fl_updateHTML:(NSString *)html {
    NSString *cleanedHTML = [html fl_htmlStringRemoveQuotes];
    NSString *trigger = [NSString stringWithFormat:@"fl_editor.setHTML(\"%@\");", cleanedHTML];
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)insertHTML:(NSString *)html {
    NSString *cleanedHTML = [html fl_htmlStringRemoveQuotes];
    NSString *trigger = [NSString stringWithFormat:@"fl_editor.insertHTML(\"%@\");", cleanedHTML];
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_setPlaceholderText:(NSString *)plcaeholder {
    //Call the setPlaceholder javascript method if a placeholder has been set
    NSString *js = [NSString stringWithFormat:@"fl_editor.setPlaceholder(\"%@\");",plcaeholder];
    [self stringByEvaluatingJavaScriptFromString:js];
}

#pragma mark - undo redo
- (void)fl_undo {
    [self stringByEvaluatingJavaScriptFromString:@"fl_editor.undo();"];
}
- (void)fl_redo {
    [self stringByEvaluatingJavaScriptFromString:@"fl_editor.redo();"];
}

#pragma mark - insert operations

- (void)fl_prepareForInser {
    // Save the selection location
    [self stringByEvaluatingJavaScriptFromString:@"fl_editor.prepareInsert();"];
}


#pragma mark - insert link
- (void)fl_insertLink:(NSString *)url title:(NSString *)title {
    NSString *trigger = [NSString stringWithFormat:@"fl_editor.insertLink(\"%@\", \"%@\");", url, title];
    [self stringByEvaluatingJavaScriptFromString:trigger];
}


- (void)fl_updateLink:(NSString *)url title:(NSString *)title {
    NSString *trigger = [NSString stringWithFormat:@"fl_editor.updateLink(\"%@\", \"%@\");", url, title];
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_removeLink {
    [self stringByEvaluatingJavaScriptFromString:@"fl_editor.unlink();"];
}

- (void)fl_quickLink {
    [self stringByEvaluatingJavaScriptFromString:@"fl_editor.quickLink();"];
}
#pragma mark - insert image

- (void)fl_insertImage:(NSString *)url alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"fl_editor.insertImage(\"%@\", \"%@\");", url, alt];
    [self stringByEvaluatingJavaScriptFromString:trigger];
}


- (void)fl_updateImage:(NSString *)url alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"fl_editor.updateImage(\"%@\", \"%@\");", url, alt];
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_insertImageBase64String:(NSString *)imageBase64String alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"fl_editor.insertImageBase64String(\"%@\", \"%@\");", imageBase64String, alt];
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_updateImageBase64String:(NSString *)imageBase64String alt:(NSString *)alt {
    NSString *trigger = [NSString stringWithFormat:@"fl_editor.updateImageBase64String(\"%@\", \"%@\");", imageBase64String, alt];
    [self stringByEvaluatingJavaScriptFromString:trigger];
}


#pragma mark -
- (void)fl_updateCSS:(NSString *)css {
    
    NSString *js = [NSString stringWithFormat:@"fl_editor.setCustomCSS(\"%@\");", css];
    [self stringByEvaluatingJavaScriptFromString:js];
    
}
- (void)fl_removeFormat {
    NSString *trigger = @"fl_editor.removeFormating();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}



- (void)fl_setSelectedColor:(UIColor*)color option:(FLSetColorOptions)tag {
    NSString *hex = [NSString stringWithFormat:@"#%06x",fl_HexColorFromUIColor(color)];
    NSString *trigger;
    switch (tag) {
        case FLSetColorTextOption:
            trigger = [NSString stringWithFormat:@"fl_editor.setTextColor(\"%@\");", hex];
            break;
        case FLSetColorBackgroundOption:
            trigger = [NSString stringWithFormat:@"fl_editor.setBackgroundColor(\"%@\");", hex];
            break;
        default:
            break;
    }
    [self stringByEvaluatingJavaScriptFromString:trigger];
}
- (void)fl_setSelectedFontFamily:(FLFontFamily)fontFamily {
    NSString *fontFamilyString;
    switch (fontFamily) {
        case FLFontFamilyDefault:
            fontFamilyString = @"Arial, Helvetica, sans-serif";
            break;
            
        case FLFontFamilyGeorgia:
            fontFamilyString = @"Georgia, serif";
            break;
            
        case FLFontFamilyPalatino:
            fontFamilyString = @"Palatino Linotype, Book Antiqua, Palatino, serif";
            break;
            
        case FLFontFamilyTimesNew:
            fontFamilyString = @"Times New Roman, Times, serif";
            break;
            
        case FLFontFamilyTrebuchet:
            fontFamilyString = @"Trebuchet MS, Helvetica, sans-serif";
            break;
            
        case FLFontFamilyVerdana:
            fontFamilyString = @"Verdana, Geneva, sans-serif";
            break;
            
        case FLFontFamilyCourierNew:
            fontFamilyString = @"Courier New, Courier, monospace";
            break;
            
        default:
            fontFamilyString = @"Arial, Helvetica, sans-serif";
            break;
    }
    
    NSString *trigger = [NSString stringWithFormat:@"fl_editor.setFontFamily(\"%@\");", fontFamilyString];
    
    [self stringByEvaluatingJavaScriptFromString:trigger];
}



- (void)fl_setFooterHeight:(float)footerHeight {
    //Call the setFooterHeight javascript method
    NSString *js = [NSString stringWithFormat:@"fl_editor.setFooterHeight(\"%f\");", footerHeight];
    [self stringByEvaluatingJavaScriptFromString:js];
    
}
- (void)fl_setContentHeight:(float)contentHeight {
    //Call the contentHeight javascript method
    NSString *js = [NSString stringWithFormat:@"fl_editor.contentHeight = %f;", contentHeight];
    [self stringByEvaluatingJavaScriptFromString:js];
}





- (void)fl_alignLeft {
    NSString *trigger = @"fl_editor.setJustifyLeft();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_alignCenter {
    NSString *trigger = @"fl_editor.setJustifyCenter();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_alignRight {
    NSString *trigger = @"fl_editor.setJustifyRight();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_alignFull {
    NSString *trigger = @"fl_editor.setJustifyFull();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_setBold {
    NSString *trigger = @"fl_editor.setBold();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_setItalic {
    NSString *trigger = @"fl_editor.setItalic();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_setSubscript {
    NSString *trigger = @"fl_editor.setSubscript();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_setUnderline {
    NSString *trigger = @"fl_editor.setUnderline();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_setSuperscript {
    NSString *trigger = @"fl_editor.setSuperscript();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_setStrikethrough {
    NSString *trigger = @"fl_editor.setStrikeThrough();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_setUnorderedList {
    NSString *trigger = @"fl_editor.setUnorderedList();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_setOrderedList {
    NSString *trigger = @"fl_editor.setOrderedList();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_setHR {
    NSString *trigger = @"fl_editor.setHorizontalRule();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_setIndent {
    NSString *trigger = @"fl_editor.setIndent();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_setOutdent {
    NSString *trigger = @"fl_editor.setOutdent();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_heading1 {
    NSString *trigger = @"fl_editor.setHeading('h1');";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_heading2 {
    NSString *trigger = @"fl_editor.setHeading('h2');";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_heading3 {
    NSString *trigger = @"fl_editor.setHeading('h3');";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_heading4 {
    NSString *trigger = @"fl_editor.setHeading('h4');";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_heading5 {
    NSString *trigger = @"fl_editor.setHeading('h5');";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_heading6 {
    NSString *trigger = @"fl_editor.setHeading('h6');";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}

- (void)fl_paragraph {
    NSString *trigger = @"fl_editor.setParagraph();";
    [self stringByEvaluatingJavaScriptFromString:trigger];
}



#pragma mark - focus
- (void)fl_focusTextEditor {
    self.keyboardDisplayRequiresUserAction = NO;
    NSString *js = [NSString stringWithFormat:@"fl_editor.focusEditor();"];
    [self stringByEvaluatingJavaScriptFromString:js];
}

- (void)fl_blurTextEditor {
    NSString *js = [NSString stringWithFormat:@"fl_editor.blurEditor();"];
    [self stringByEvaluatingJavaScriptFromString:js];
}


@end
