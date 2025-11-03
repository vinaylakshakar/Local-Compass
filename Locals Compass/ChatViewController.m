//
//  ChatViewController.m
//  MiRusPROM
//
//  Created by silstone on 10/25/17.
//  Copyright © 2017 SilstoneGroup. All rights reserved.
//

#import "ChatViewController.h"
#import "NetworkEngine.h"
#import "Constants.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBarController.tabBar setHidden:YES];
    self.automaticallyScrollsToMostRecentMessage = YES;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeMake(0.0f, 0.0f);
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeMake(0.0f, 0.0f);
    
    self.messages = [[NSMutableArray alloc]init];
    self.inputToolbar.contentView.leftBarButtonItem = nil;
    self.senderId = [[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"];
    self.senderDisplayName = @"PT-4482GFR";
    [self getMessages];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:message.senderDisplayName];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentLeft;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, message.senderDisplayName.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, message.senderDisplayName.length)];
    //    return attributedString;
    return [self.senderId isEqualToString:message.senderId]? nil : attributedString;
    
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    return [self.senderId isEqualToString:message.senderId]? 0 : 20 ;
}


-(void) addMessage:(NSString *)Id withname:(NSString *)name  withText:(NSString *)text{
    NSMutableArray *othersMessage = [[NSMutableArray alloc]init];
    
    [othersMessage addObject:[JSQMessage messageWithSenderId:Id displayName:name text:text]];
}

- (void)didPressSendButton:(UIButton *)button
           withMessageText:(NSString *)text
                  senderId:(NSString *)senderId
         senderDisplayName:(NSString *)senderDisplayName
                      date:(NSDate *)date{
    
    [self addMessage:text:senderId];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _messages.count;
    
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    JSQMessage *dic = [_messages objectAtIndex:indexPath.row];
    //  }
    if(true)
    {
        
        [cell.textView setTextColor:[UIColor whiteColor]];
        cell.textView.text = dic.text;
        
    }
    
    return cell;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [self.messages objectAtIndex:indexPath.item];
    
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessagesBubbleImageFactory *imgFactory = [[JSQMessagesBubbleImageFactory alloc]init];
    // for(int i = 0; i <= _messages.count; i++){
    JSQMessage *dic = [_messages objectAtIndex:indexPath.row];
    //  }
    if([dic.senderId isEqualToString:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"]])
    {
        return [imgFactory outgoingMessagesBubbleImageWithColor:[UIColor lightGrayColor]];
        
    }
    else{
        
        //return [imgFactory incomingMessagesBubbleImageWithColor:[UIColor colorWithRed:255.0f/255.0f green:95.0f/255.0f blue:98.0f/255.0f alpha:1.0f]];
        //vinay here-
        return [imgFactory incomingMessagesBubbleImageWithColor:[UIColor colorWithRed:0.20 green:0.77 blue:0.94 alpha:1.0]];
    }
    

}
- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return nil;
}

-(void)initBubbles{
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
}

-(void)addMessage:(NSString *)message :(NSString *)senderID
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"sender_id"];
    [dic setObject:self.recieverIDStr forKey:@"receiver_id"];
    [dic setObject:self.itineraryIDStr forKey:@"itineraryid"];
    [dic setObject:message forKey:@"message"];
    
    [[NetworkEngine sharedNetworkEngine] sendmessageApi:message :dic :^(id object) {
        NSLog(@"add mesager Done");
        [self.messages addObject:[JSQMessage messageWithSenderId:senderID displayName:@"" text:message]];
        [self finishSendingMessage];
        [self.collectionView reloadData];
        
    } onError:^(NSError *error) {
        NSLog(@"error");
    }];
    
}
-(void)getMessages
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[[USERDEFAULTS valueForKey:DictUserData] valueForKey:@"user_id"] forKey:@"sender_id"];
    [dic setObject:self.recieverIDStr forKey:@"receiver_id"];
    [dic setObject:self.itineraryIDStr forKey:@"itineraryid"];
    
    [[NetworkEngine sharedNetworkEngine] getmessageApi:dic :^(id object) {
        NSLog(@"get messages");
        [self.messages removeAllObjects];
        
        NSMutableArray *messageArray = [[object valueForKey:@"Data"] mutableCopy];
        
        for (int i=0; i<[messageArray count]; i++) {
            NSMutableDictionary *dic = [messageArray objectAtIndex:i];
            [self.messages addObject:[JSQMessage messageWithSenderId:[dic valueForKey:@"sender_id"] displayName:@"" text:[dic valueForKey:@"message"]]];
        }
        [self.collectionView reloadData];
        
    } onError:^(NSError *error) {
        NSLog(@"error");
    }];
    
}


@end
