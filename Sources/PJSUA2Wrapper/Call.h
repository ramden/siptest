//
//  Call.h
//  
//
//  Created by Oliver Epper on 25.08.22.
//

#ifndef Call_h
#define Call_h

#include <pjsua2.hpp>

class Call : public pj::Call {
public:
    Call(pj::Account& account, int callId = PJSUA_INVALID_ID) : pj::Call(account, callId) {}

    virtual void onCallState(pj::OnCallStateParam &prm) {
        pj::CallInfo ci = getInfo();
        NSLog(@"@@@@@ %s", ci.stateText.c_str());
        NSLog(@"@@@@@ %s", ci.remoteUri.c_str());
        NSLog(@"@@@@@ %s", ci.remoteContact.c_str());
    };

    virtual void onCallMediaState(pj::OnCallMediaStateParam &prm) {
        printAudioDevices();
        pj::CallInfo ci = getInfo();
        for (unsigned i = 0; i < ci.media.size(); ++i) {
            if (ci.media[i].type == PJMEDIA_TYPE_AUDIO && getMedia(i)) {
                pj::AudioMedia *aud_med = (pj::AudioMedia *)getMedia(i);

                pj::AudDevManager &mgr = pj::Endpoint::instance().audDevManager();
                aud_med->startTransmit(mgr.getPlaybackDevMedia());
                mgr.getCaptureDevMedia().startTransmit(*aud_med);
            }
        }
    }

private:
    void printAudioDevices() {
        int count = pjmedia_aud_dev_count();
        NSLog(@"Found %d audio devices", count);
        for (pjmedia_aud_dev_index idx = 0; idx < count; ++idx) {
            pjmedia_aud_dev_info info;
            pjmedia_aud_dev_get_info(idx, &info);
            NSLog(@"%d - %s (ins: %d, outs: %d)", idx, info.name, info.input_count, info.output_count);
        }
    }
};


#endif /* Call_h */
