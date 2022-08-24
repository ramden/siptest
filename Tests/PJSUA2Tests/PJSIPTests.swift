import XCTest
@testable import PJSUA2
import Cpjproject

final class PJSUA2Tests: XCTestCase {
    func testCreatePJSUA2() throws {
        let pjsua2 = PJSUA2()
        XCTAssertNotNil(pjsua2)
    }

    func testCreateTransport() throws {
        let pjsua2 = PJSUA2()
        pjsua2.createTransport(withType: PJSIP_TRANSPORT_TLS, andPort: 5061)
        XCTAssertNotNil(pjsua2)
    }

    func testCreateAccount() throws {
        let pjsua2 = PJSUA2()
        pjsua2.createTransport()
        pjsua2.createAccount()
        XCTAssertNotNil(pjsua2)
    }
}
