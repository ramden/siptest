//
//  MyCall.h
//  
//
//  Created by Oliver Epper on 25.08.22.
//

#ifndef MyCall_h
#define MyCall_h

#include <pjsua2.hpp>

class MyCall : public pj::Call {
public:
    MyCall(pj::Account& account, int callId = PJSUA_INVALID_ID) : Call(account, callId) {}

    virtual void onCallState(pj::OnCallStateParam &prm) {};

    virtual void onCallMediaState(pj::OnCallMediaStateParam &prm) {
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
};


#endif /* MyCall_h */
