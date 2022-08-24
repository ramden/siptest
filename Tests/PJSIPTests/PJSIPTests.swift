import XCTest
@testable import PJSIP
import Cpjproject

final class PJSIPTests: XCTestCase {
    func testCreatePJSIP() throws {
        let pjsip = PJSIP()
        XCTAssertNotNil(pjsip)
    }

    func testCreateTransport() throws {
        let pjsip = PJSIP()
        pjsip.createTransport(withType: PJSIP_TRANSPORT_TLS, andPort: 5061)
        XCTAssertNotNil(pjsip)
    }

    func testCreateAccount() throws {
        let pjsip = PJSIP()
        pjsip.createTransport()
        pjsip.createAccount()
        XCTAssertNotNil(pjsip)
    }
}
