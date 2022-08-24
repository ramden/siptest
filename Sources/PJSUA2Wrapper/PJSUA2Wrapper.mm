//
//  PJSUA2Wrapper.m
//  
//
//  Created by Oliver Epper on 22.08.22.
//

#include <pjsua2.hpp>
#import "PJSUA2Wrapper.h"
#import "MyAccount.h"

@interface PJSUA2Wrapper ()

@property MyAccount *acc;

@end

@implementation PJSUA2Wrapper

- (instancetype)initWithUserAgent:(NSString *)userAgent
{
    if ( self = [super init]) {
        new pj::Endpoint();
        pj::Endpoint::instance().libCreate();

        pj::EpConfig cfg;
        cfg.uaConfig.userAgent = [[userAgent copy] cStringUsingEncoding:NSUTF8StringEncoding];

        pj::Endpoint::instance().libInit(cfg);
        return self;
    }
    return nil;
}

- (instancetype)init
{
    return [self initWithUserAgent:@"PJSUA2 for 🖥 and 📱"];
}

- (void)dealloc
{
    pj::Endpoint::instance().libDestroy();
}

- (void)createTransportWithType:(pjsip_transport_type_e)type andPort:(int)port
{
    pj::TransportConfig cfg;
    cfg.port = port;
    pj::Endpoint::instance().transportCreate(type, cfg);
}

- (void)createAccountOnServer:(NSString *)servername forUser:(NSString *)user withPassword:(PasswordFunction)passwordFunction
{
    PJSUA2Wrapper *object(self);
    self.acc = new MyAccount(object);
    pj::AccountConfig cfg;
    cfg.mediaConfig.srtpUse = PJMEDIA_SRTP_OPTIONAL;
    cfg.idUri = [[NSString stringWithFormat:@"%@<sip:%@@%@>", user, user, servername] cStringUsingEncoding:NSUTF8StringEncoding];
    pj::AuthCredInfo credInfo;
    credInfo.realm = "*";
    credInfo.username = [user cStringUsingEncoding:NSUTF8StringEncoding];
    credInfo.data = [passwordFunction() cStringUsingEncoding:NSUTF8StringEncoding];
    cfg.sipConfig.authCreds.push_back(credInfo);
    cfg.regConfig.registrarUri = [[NSString stringWithFormat:@"sip:%@;transport=TLS", servername] cStringUsingEncoding:NSUTF8StringEncoding];
    self.acc->create(cfg, true);
}

- (void)libStart
{
    pj::Endpoint::instance().libStart();
}

- (void)reportCall:(int)callId
{
    if (self.onIncomingCallCallback) {
        self.onIncomingCallCallback(callId);
    }
}

@end