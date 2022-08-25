//
//  PJSUA2Wrapper.m
//  
//
//  Created by Oliver Epper on 22.08.22.
//

#include <pjsua2.hpp>
#import "PJSUA2Wrapper.h"
#import "MyAccount.h"
#import "MyCall.h"

@interface PJSUA2Wrapper ()

@property MyAccount *account;
@property MyCall *call;

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
    self.account = new MyAccount(object);
    pj::AccountConfig cfg;
    cfg.mediaConfig.srtpUse = PJMEDIA_SRTP_OPTIONAL;
    cfg.idUri = [[NSString stringWithFormat:@"%@<sip:%@@%@>", user, user, servername] cStringUsingEncoding:NSUTF8StringEncoding];
    pj::AuthCredInfo credInfo;
    credInfo.realm = "*";
    credInfo.username = [user cStringUsingEncoding:NSUTF8StringEncoding];
    credInfo.data = [passwordFunction() cStringUsingEncoding:NSUTF8StringEncoding];
    cfg.sipConfig.authCreds.push_back(credInfo);
    cfg.regConfig.registrarUri = [[NSString stringWithFormat:@"sip:%@;transport=TLS", servername] cStringUsingEncoding:NSUTF8StringEncoding];
    self.account->create(cfg, true);
}

- (void)libStart
{
    pj::Endpoint::instance().libStart();
}

- (void)reportCall:(int)callId
{
    self.call = new MyCall(*self.account, callId);
    if (self.onIncomingCallCallback) {
        self.onIncomingCallCallback(callId);
    }
}

- (void)answerCall
{
    if (self.call) {
        pj::CallOpParam prm;
        prm.statusCode = PJSIP_SC_OK;
        self.call->answer(prm);
    }
}

- (void)hangupCall
{
    if (self.call) {
        pj::CallOpParam prm;
        prm.statusCode = PJSIP_SC_DECLINE;
        self.call->hangup(prm);
        free(self.call);
        [self reportCall:PJSUA_INVALID_ID];
    }
}

- (void)testAudio
{
    pj::AudioMedia& playback_dev_media = pj::Endpoint::instance().audDevManager().getPlaybackDevMedia();
    pj::AudioMedia& capture_dev_media = pj::Endpoint::instance().audDevManager().getCaptureDevMedia();

    capture_dev_media.startTransmit(playback_dev_media);
    capture_dev_media.adjustTxLevel(1.0);

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        capture_dev_media.stopTransmit(playback_dev_media);
    });
}

@end
