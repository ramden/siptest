import Combine
import PJSUA2Wrapper

public struct PJSUA2 {
    public private(set) var wrapper = PJSUA2Wrapper(userAgent: "✌️")
    private var callSubject = PassthroughSubject<Int32, Never>()

    public init() {
        setup()
    }

    private func setup() {
        wrapper.onIncomingCallCallback = { callId in
            callSubject.send(callId)
        }
    }

    public func incomingCalls() -> AnyPublisher<Int32, Never> {
        callSubject.eraseToAnyPublisher()
    }
}
