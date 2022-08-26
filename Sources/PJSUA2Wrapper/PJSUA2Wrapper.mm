//
//  PJSUA2Wrapper.m
//  
//
//  Created by Oliver Epper on 22.08.22.
//

#include <pjsua2.hpp>
#import "PJSUA2Wrapper.h"
#import "Account.h"
#import "Call.h"

@interface PJSUA2Wrapper ()

@property Account *account;

@end

@implementation PJSUA2Wrapper

std::vector<Call *> calls;

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
    self.account = new Account(object);
    pj::AccountConfig cfg;
    cfg.mediaConfig.srtpUse = PJMEDIA_SRTP_OPTIONAL;
    cfg.idUri = [[NSString stringWithFormat:@"%@<sip:%@@%@>", user, user, servername] UTF8String];
    pj::AuthCredInfo credInfo;
    credInfo.realm = "*";
    credInfo.username = [user UTF8String];
    credInfo.data = [passwordFunction() UTF8String];
    cfg.sipConfig.authCreds.push_back(credInfo);
    cfg.regConfig.registrarUri = [[NSString stringWithFormat:@"sip:%@;transport=TLS", servername] UTF8String];

    self.account->create(cfg, true);

    // FIXME: delete
    [self dumpAccount];
}

- (void)libStart
{
    pj::Endpoint::instance().libStart();
}

- (void)onIncomingCall:(int)callId
{
    calls.push_back(new Call(*self.account, callId));
    if (self.onIncomingCallCallback) {
        self.onIncomingCallCallback(callId);
    }
}

- (void)answerCall
{
    if (auto call = calls.back()) {
        pj::CallOpParam prm;
        prm.statusCode = PJSIP_SC_OK;
        call->answer(prm);
    }
}

- (void)hangupCall
{
    if (auto call = calls.back()) {
        pj::CallOpParam prm;
        prm.statusCode = PJSIP_SC_DECLINE;
        call->hangup(prm);
        calls.pop_back();
        if (self.onIncomingCallCallback) {
            self.onIncomingCallCallback(PJSUA_INVALID_ID);
        }
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

- (void)call:(NSString *)number onServer:(NSString *)server
{
    auto call = new Call(*self.account);
    pj::CallOpParam prm{true};
    try {
        call->makeCall([[NSString stringWithFormat:@"<sips:%@@%@>", number, server] UTF8String], prm);
    } catch (pj::Error &error) {
        NSLog(@"@@@@@ ERROR: %s", error.info().c_str());
    }
}

- (void)dumpAccount
{
    auto info = self.account->getInfo();
    NSLog(@"@@@@@ %s", info.uri.c_str());
}
@end
