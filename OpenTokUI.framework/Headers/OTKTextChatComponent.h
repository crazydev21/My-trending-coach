//
//  OTKTextChatComponent.h
//
//  Created by Cesar Guirao on 2/6/15.
//  Copyright (c) 2015 TokBox. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * Defines the chat message object that you pass into the
 * <[OTKTextChatComponent addMessage:]> method.
 */
@interface OTKChatMessage : NSObject

/**
 * The sender alias for the message.
 */
@property (nonatomic, copy) NSString *senderAlias;
/**
 * The unique ID of the sender.
 */
@property (nonatomic, copy) NSString *senderId;
/**
 * The text of the message.
 */
@property (nonatomic, copy) NSString *text;
/**
 * The timestamp for the message.
 */
@property (nonatomic, copy) NSDate *dateTime;

@end

/**
 * A delegate for receiving events when a text chat message is ready to send.
 */
@protocol OTKTextChatDelegate <NSObject>

/**
 * Called when a message in the OTKTextChatComponent is ready to send. A message
 * is ready to send when the user clicks the Send button in the
 * OTKTextChatComponent user interface.
 */
- (BOOL)onMessageReadyToSend:(OTKChatMessage *)message;

@end

/**
 * A controller for the OpenTok iOS Text Chat UI widget.
 */
@interface OTKTextChatComponent : NSObject <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

/**
 * The view containing the OTKTextChatComponent user interface.
 */
@property (nonatomic, strong) IBOutlet UIView * view;

/**
 * Set to the delegate object that receives events for this OTKTextChatComponent.
 */
@property (nonatomic, weak) id<OTKTextChatDelegate> delegate;

/**
 * Add a message to the TextChatListener received message list.
 *
 * @param message The message to send.
 */
- (BOOL)addMessage:(OTKChatMessage *)message;

/**
 * Set the maximum length of a text chat message.
 *
 * @param length The maximum length for a message.
 */
- (void)setMaxLength:(int) length;

/**
 * Set the sender ID and the sender alias of the output messages.
 *
 * @param senderId The unique ID for the sender. The OTKTextChatComponent uses this ID
 * to group messages from the same sender in the user interface.
 *
 * @param alias The string (alias) identifying the sender of the message.
 */
- (void)setSenderId:(NSString *)senderId alias:(NSString *)alias;

@end
