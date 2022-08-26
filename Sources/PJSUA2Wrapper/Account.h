//
//  Account.h
//  
//
//  Created by Oliver Epper on 22.08.22.
//

#ifndef Account_h
#define Account_h

#include <pjsua2.hpp>

class Account : public pj::Account {
public:
    Account(const PJSUA2Wrapper *wrapper) : wrapper{wrapper} {}
    void onIncomingCall(pj::OnIncomingCallParam &prm) override {
        if (wrapper) [wrapper onIncomingCall:prm.callId];
    }
private:
    const PJSUA2Wrapper *wrapper;
};

#endif /* Account_h */

