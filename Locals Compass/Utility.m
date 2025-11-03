//
//  Utility.m
//  Keep
//
//  Created by eweba1-pc-69 on 18/08/2015.
//  Copyright (c) 2015 Mnjt-PC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "AppDelegate.h"
//#define kBaseURL @"http://a1professionals.net/showtimebroker/webservices/"
#define kBaseURL @"http://showtimebroker.com/showtimebroker/webservices/"
@implementation Utility


+(void)showAlertMessage:(NSString *)title message :(NSString *)message
{

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
+(BOOL)emailValidation:(NSString *)emailText
{
 NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
 NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
 return [emailTest evaluateWithObject:emailText];
}
+(NSMutableURLRequest *)makeMultipartDataForStickerPost:(NSDictionary *)paramDict path:(NSString *)service httpMethod:(NSString *)method{
 NSString *boundary = [NSString stringWithFormat:@"---------------------------44247638221121663601275327610"];
 NSMutableData *body = [NSMutableData data];
 
 for (NSString *key in [paramDict allKeys]) {
  [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
  
  if([key isEqualToString:@"sticker_picture"]||[key isEqualToString:@"file_name"]){
   [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"user_pic.png\"\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
   [body appendData:[[NSString stringWithFormat:@"Content-Type: image/png\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
   [body appendData:[paramDict objectForKey:key] ];
  }
  
  else {
   [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
   [body appendData:[[paramDict valueForKey:key] dataUsingEncoding:NSUTF8StringEncoding]];
  }
  
  
  
  [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
  
  
 }
 
 [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"submit\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
 [body appendData:[@"SUBMIT" dataUsingEncoding:NSUTF8StringEncoding]];
 
 [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
 
 //NSString *httpRequest=@"http://";
 
 NSString *servicePath=[NSString stringWithFormat:@"%@%@/",kBaseURL,service];
 
 servicePath=[servicePath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 NSURL *url=[NSURL URLWithString:servicePath];
 NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:url];
 NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
 [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
 [request setHTTPMethod:method];
 
 [request setHTTPBody:body];
 NSLog(@"%@",request);
 return request;
}


@end
