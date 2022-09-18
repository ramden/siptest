//
//  File.swift
//  
//
//  Created by Oliver Epper on 24.08.22.
//

import Cpjproject

public enum PJSIPError: Error {
    case failed(pj_status_t)
}

private func on_call_state(call_id: pjsua_call_id, event: UnsafeMutablePointer<pjsip_event>?) {
    print(#function)
}

private func on_call_media_state(call_id: pjsua_call_id) {
    print(#function)
}

public func initPJSIP() throws {
    var status = pjsua_create()
    if (status != PJ_SUCCESS.rawValue) { throw PJSIPError.failed(status) }

    var cfg = pjsua_config()
    var log_cfg = pjsua_logging_config()
    var media_cfg = pjsua_media_config()
    pjsua_config_default(&cfg)
    pjsua_logging_config_default(&log_cfg)
    pjsua_media_config_default(&media_cfg)

    cfg.cb.on_call_state = on_call_state
    cfg.cb.on_call_media_state = on_call_media_state

    /* init */
    status = pjsua_init(&cfg, &log_cfg, &media_cfg)
    if (status != PJ_SUCCESS.rawValue) { throw PJSIPError.failed(status) }
}
 
