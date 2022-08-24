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

- (instancetype)init;
- (instancetype)initWithUserAgent:(NSString* )userAgent NS_DESIGNATED_INITIALIZER;

- (void)createTransportWithType:(pjsip_transport_type_e)type andPort:(int)port;

- (void)createAccount;

@end

NS_ASSUME_NONNULL_END
