  //
//  NetworkEngine.m
//  Keep
//
//  Created by Eweb-A1-iOS on 30/09/15.
//  Copyright © 2015 Mnjt-PC. All rights reserved.
//

#import "NetworkEngine.h"
#import "Utility.h"
#import "Constants.h"
//#import <Stripe/Stripe.h>
#import "AppDelegate.h"
//#define kBaseURL @"http://192.168.1.253/chowze/webservice/"
//#define kBaseURL @"http://a1professionals.net/showtimebroker/webservices/"

static NetworkEngine *sharedNetworkEngine = nil;
@implementation NetworkEngine
@synthesize httpManager;

+(id)sharedNetworkEngine{
 if(sharedNetworkEngine == nil)
 {
  sharedNetworkEngine = [[NetworkEngine alloc]init];
 }
 return sharedNetworkEngine;
}

-(id)init {
 self = [super init];
 if(self) {
  self.httpManager = [AFHTTPRequestOperationManager manager];
  
  self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/javascript", nil];
  
  [self.httpManager.requestSerializer setAuthorizationHeaderFieldWithUsername:nil password:nil];

 }
 return self;
}

-(void)loginUser:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"login.php" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         if([responseObject valueForKey:@"Response"])
         {
             if([[responseObject valueForKey:@"Response"]isEqualToString:@"failure"])
             {
                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"Message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}

-(void)SocialLoginUser:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params
{
    
    [self.httpManager POST:kBaseURL@"user/SocialLogin" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //NSLog(@"JSON: %@", responseObject);
         if([responseObject valueForKey:@"code"])
         {
             if([[responseObject valueForKey:@"code"]isEqualToString:@"200"])
             {
//                 [kAppDelegate hideProgressHUD];
                 [Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
             }
             else completionBlock(responseObject);
         }
         else errorBlock(nil);
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
//         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
}


-(void)registration:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
//    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"UserRegistration/Registration" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        completionBlock(responseObject);

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
//         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}



-(void)upload:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params
{
//    [kAppDelegate showProgressHUD];
    NSLog(@"params %@",params);
    NSData *data = UIImageJPEGRepresentation(imageName, 0.5);
    self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [self.httpManager POST:kBaseURL@"UserRegistration/Registration" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:data name:@"ProfileImage" fileName:filePath mimeType:@"image/jpeg"];
     }
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         completionBlock(responseObject);
     }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
//         [kAppDelegate hideProgressHUD];
         errorBlock(error);
     }];
}

-(void)forgotPassword:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"forgotPassword.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
//        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
//            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            
//            [alert show];
            
//            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
             //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)itinerary_list:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"itinerary_list.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}
//http://localscompass.silappdevops.com/services/city_list.php?page_no=0&user_id=83
-(void)city_list:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager GET:kBaseURL@"city_list.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if([responseObject valueForKey:@"Message"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)locals_list:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager GET:kBaseURL@"locals_list.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)city_details:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager GET:kBaseURL@"city_details.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)get_local_profile:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"local_details.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

//-(void)submit_request:(completion_block)completionBlock onError:(error_block)errorBlock params:{}

-(void)city_search:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"city_search.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}


-(void)get_user_profile:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"get_user_profile.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)update_user_profile:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSMutableDictionary *)params
{
     [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"update_user_profile.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         if([[responseObject valueForKey:@"code"]isEqualToString:@"201"])
         {
             completionBlock(responseObject);
         }
         else
         {
             completionBlock(responseObject);
//             [kAppDelegate hideProgressHUD];
             //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
         }
     }
   failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
         
     }];
    
    
}

-(void)updatePassword:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"updatePassword.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)get_question:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"get_question.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)rate_itinerary:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"rate_itinerary.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)accept_itinerary:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"accept_itinerary.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)change_itinerary:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"change_itinerary.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)user_message:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"user_message.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}


-(void)itinerary_process:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"itinerary_process.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)local_like:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"local_like.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)city_like:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"city_like.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)itinerary_section_detail:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"itinerary_section_detail.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)itinerary_day_activity:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"itinerary_day_activity.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)signup:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"signup.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
//            [Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)user_feedback:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"user_feedback.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)userLogout:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    //localscompass.silappdevops.com/services/logout.php?user_id=1&device_id=1
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"logout.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
    
}


-(void)itinerary_submit:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"itinerary_submit.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)new_city:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"new_city.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}

-(void)updateImage:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params
{
//    [kAppDelegate showProgressHUD];
    NSLog(@"params %@",params);
    NSData *data = UIImageJPEGRepresentation(imageName, 0.5);
    self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [self.httpManager POST:kBaseURL@"update_user_image.php?" parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
     {
         [formData appendPartWithFileData:data name:@"picture" fileName:filePath mimeType:@"image/jpeg"];
     }
                   success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         
         completionBlock(responseObject);
     }
                   failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
//         [kAppDelegate hideProgressHUD];
         errorBlock(error);
     }];
}

-(void)getmessageApi:(NSMutableDictionary *)params :(completion_block)completionBlock onError:(error_block)errorBlock
{
   // [kAppDelegate showProgressHUD];
    NSString *url = [NSString stringWithFormat:@"http://localscompass.silappdevops.com/services/getallmsgs.php?sender_id=%@&receiver_id=%@&itineraryid=%@",[params valueForKey:@"sender_id"],[params valueForKey:@"receiver_id"],[params valueForKey:@"itineraryid"]];
    NSLog(@"JSON: %@", url);
    self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/javascript", nil];
    [self.httpManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         completionBlock(responseObject);
     }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
     }];
}

-(void)sendmessageApi:(NSString *)message :(NSMutableDictionary *)params :(completion_block)completionBlock onError:(error_block)errorBlock
{
    //[kAppDelegate showProgressHUD];
    NSString *url = [NSString stringWithFormat:@"http://localscompass.silappdevops.com/services/sendmessage.php?"];
    NSLog(@"JSON: %@", url);
    self.httpManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/javascript", nil];
    [self.httpManager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSLog(@"JSON: %@", responseObject);
         completionBlock(responseObject);
     }
                  failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         errorBlock(error);
     }];
}

-(void)get_image:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params{
    
    [kAppDelegate showProgressHUD];
    
    [self.httpManager POST:kBaseURL@"get_image.php?" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        //        [kAppDelegate hideProgressHUD];
        
        if([responseObject valueForKey:@"Message"])
        {
            //            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:nil message:[responseObject valueForKey:@"message"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            //
            //            [alert show];
            
            //            [kAppDelegate hideProgressHUD];
            completionBlock(responseObject);
        }
        else
        {
            completionBlock(responseObject);
            //[kAppDelegate hideProgressHUD];
            //[Utility showAlertMessage:nil message:[responseObject objectForKey:@"message"] ];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [kAppDelegate hideProgressHUD];
         
         errorBlock(error);
     }];
}


//-------------------------------
//- (void)createCustomerKeyWithAPIVersion:(NSString *)apiVersion completion:(STPJSONResponseCompletionBlock)completion {
//    NSURL *url = [self.baseURL URLByAppendingPathComponent:@"ephemeral_keys"];
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager POST:@"" parameters:@{@"api_version": apiVersion} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
//         completion(responseObject, nil);
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         completion(nil, error);
//    }];
//}

@end
