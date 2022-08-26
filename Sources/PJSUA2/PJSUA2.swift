import Combine
import PJSUA2Wrapper

public struct PJSUA2 {
    private var wrapper = PJSUA2Wrapper(userAgent: "✌️")
    private var callSubject = PassthroughSubject<Int32, Never>()

    public init() {
        setup()
    }

    private func setup() {
        wrapper.onIncomingCallCallback = { callId in
            callSubject.send(callId)
        }
    }

    public func createTransport(withType type: pjsip_transport_type_e = PJSIP_TRANSPORT_TLS, andPort port: Int32 = 5061) {
        wrapper.createTransport(withType: type, andPort: port)
    }

    public func createAccount(onServer server: String, forUser user: String, withPassword password: @escaping () -> String) {
        wrapper.createAccount(onServer: server, forUser: user) {
            password()
        }
    }

    public func libStart() {
        wrapper.libStart()
    }

    public func answerCall() {
        wrapper.answerCall()
    }

    public func hangupCall() {
        wrapper.hangupCall()
    }

    public func testAudio() {
        wrapper.testAudio()
    }

    public func call(number: String, onServer server: String) {
        wrapper.call(number, onServer: server)
    }

    public func incomingCalls() -> AnyPublisher<Int32, Never> {
        callSubject.eraseToAnyPublisher()
    }
}
