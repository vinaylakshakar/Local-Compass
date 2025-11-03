//
//  NetworkEngine.h
//  Keep
//
//  Created by Vibha on 30/09/15.
//  Copyright © 2015 Vibha. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>


typedef void(^completion_block)(id object);
typedef void(^error_block)(NSError *error);
typedef void (^upload_completeBlock)(NSString *url);
@interface NetworkEngine : NSObject

@property(nonatomic,strong)AFHTTPRequestOperationManager *httpManager;
+ (id)sharedNetworkEngine;

// For login purposes
-(void)loginUser:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary*)params;
-(void)registration:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)upload:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params;
-(void)forgotPassword:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)editProfile:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSMutableDictionary *)params;
-(void)updateImage:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params;
-(void)getmessageApi:(NSMutableDictionary *)params :(completion_block)completionBlock onError:(error_block)errorBlock;
-(void)sendmessageApi:(NSString *)message :(NSMutableDictionary *)params :(completion_block)completionBlock onError:(error_block)errorBlock;
-(void)itinerary_list:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)city_list:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)locals_list:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)city_details:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)get_local_profile:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)city_search:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)signup:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)onBoarding:(completion_block)completionBlock onError:(error_block)errorBlock filePath:(NSString *)filePath imageName:(UIImage *)imageName params:(NSDictionary *)params;
-(void)get_user_profile:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)update_user_profile:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSMutableDictionary *)params;
-(void)updatePassword:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)get_question:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)rate_itinerary:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)accept_itinerary:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)change_itinerary:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)user_message:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)itinerary_process:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)local_like:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)city_like:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)itinerary_section_detail:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)itinerary_day_activity:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)user_feedback:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)itinerary_submit:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)userLogout:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)new_city:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
-(void)get_image:(completion_block)completionBlock onError:(error_block)errorBlock params:(NSDictionary *)params;
@end



