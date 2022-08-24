import Combine
import PJSUA2Wrapper

public struct PJSUA2 {
    private var wrapper = PJSUA2Wrapper(userAgent: "✌️")

    public init() {
        
    }

    public func createTransport(withType type: pjsip_transport_type_e = PJSIP_TRANSPORT_TLS, andPort port: Int32 = 5061) {
        wrapper.createTransport(withType: type, andPort: port)
    }

    public func createAccount(onServer server: String, forUser user: String, withPassword password: @escaping () -> String) {
        wrapper.createAccount(onServer: server, forUser: user) {
            password()
        }
    }
}
