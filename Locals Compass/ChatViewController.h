//
//  ChatViewController.h
//  MiRusPROM
//
//  Created by silstone on 10/25/17.
//  Copyright © 2017 SilstoneGroup. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JSQMessagesViewController/JSQMessages.h>
@interface ChatViewController : JSQMessagesViewController
@property (strong, nonatomic) NSMutableArray *messages;
@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;
@property (strong,nonatomic) NSString *recieverIDStr;
@property (strong,nonatomic) NSString *senderIDStr;
@property (strong,nonatomic) NSString *itineraryIDStr;
@end
