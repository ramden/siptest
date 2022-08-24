//
//  PJSUA2Wrapper.h
//  
//
//  Created by Oliver Epper on 22.08.22.
//

#import <Foundation/Foundation.h>
#include <pjsip/sip_types.h>

NS_ASSUME_NONNULL_BEGIN

@interface PJSUA2Wrapper : NSObject

typedef void(^OnIncomingCall)(int);
@property OnIncomingCall onIncomingCallCallback;

- (instancetype)init;
- (instancetype)initWithUserAgent:(NSString* )userAgent NS_DESIGNATED_INITIALIZER;

- (void)createTransportWithType:(pjsip_transport_type_e)type andPort:(int)port;

typedef NSString * _Nonnull(^PasswordFunction)(void);
- (void)createAccountOnServer:(NSString *)servername forUser:(NSString *)user withPassword:(PasswordFunction)passwordFunction;

- (void)libStart;

- (void)reportCall:(int)callId;

@end

NS_ASSUME_NONNULL_END