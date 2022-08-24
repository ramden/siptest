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

- (void)createAccount
{
    self.acc = new MyAccount();
    pj::AccountConfig cfg;
    cfg.mediaConfig.srtpUse = PJMEDIA_SRTP_OPTIONAL;
    cfg.idUri = "stdsip<sip:stdsip@v7oliep.starface-cloud.com>";
    pj::AuthCredInfo credInfo;
    credInfo.realm = "*";
    credInfo.username = "stdsip";
    credInfo.data = "HKg7SgmF0q2p8v02Qd4f6sf0XF9Lof";
    cfg.sipConfig.authCreds.push_back(credInfo);
    cfg.regConfig.registrarUri = "sip:v7oliep.starface-cloud.com;transport=TLS";
    self.acc->create(cfg, true);
}

@end
