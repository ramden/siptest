//
//  Header.h
//  
//
//  Created by Oliver Epper on 22.08.22.
//

#ifndef Header_h
#define Header_h

#include <pjsua2.hpp>

class MyAccount : public pj::Account {
public:
    MyAccount(const PJSUA2Wrapper *wrapper) : wrapper{wrapper} {}
    void onIncomingCall(pj::OnIncomingCallParam &prm) override {
        if (wrapper) [wrapper reportCall:prm.callId];
    }
private:
    const PJSUA2Wrapper *wrapper;
};

#endif /* Header_h */

