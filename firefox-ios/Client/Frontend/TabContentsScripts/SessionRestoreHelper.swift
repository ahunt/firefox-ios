// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation
import WebKit

protocol SessionRestoreHelperDelegate: AnyObject {
    func sessionRestoreHelper(_ helper: SessionRestoreHelper, didRestoreSessionForTab tab: Tab)
}

class SessionRestoreHelper: TabContentScript {
    weak var delegate: SessionRestoreHelperDelegate?
    fileprivate weak var tab: Tab?

    required init(tab: Tab) {
        self.tab = tab
    }

    func scriptMessageHandlerNames() -> [String]? {
        return ["sessionRestoreHelper"]
    }

    func userContentController(_ userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        guard let tab = tab,
              let params = message.body as? [String: AnyObject],
              let parameter = params["name"] as? String,
              parameter == "didRestoreSession"
        else { return }

        DispatchQueue.main.async {
            self.delegate?.sessionRestoreHelper(self, didRestoreSessionForTab: tab)
        }
    }

    class func name() -> String {
        return "SessionRestoreHelper"
    }
}
