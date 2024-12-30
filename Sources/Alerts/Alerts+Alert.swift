import SwiftUI

extension Alerts {
    
    public enum Alert: Sendable {
        case info(title: String, message: String?, buttons: [Button])
        @available(*, deprecated, renamed: "info")
        case warning(title: String, message: String?)
        case error(title: String, error: Error)
    }
}

@MainActor
extension Alerts.Alert {
    
    var title: String {
        switch self {
        case .info(let title, _, _):
            return title
        case .warning(let title, _):
            return title
        case .error(let title, _):
            return title
        }
    }
    
    var message: String? {
        switch self {
        case .info(_, let message, _):
            return message
        case .warning(_, let message):
            return message
        case .error(_, let error):
            return Alerts.overrideFailureMessage?(error) ?? (
                """
                \(error.localizedDescription)
                \((error as NSError).localizedFailureReason ?? "")
                Error code: \((error as NSError).code)
                """
            )
        }
    }
    
    var buttons: [Alerts.Button] {
        switch self {
        case .info(_, _, let buttons):
            return buttons
        case .warning:
            return [Alerts.warningButton]
        case .error:
            return [Alerts.errorButton]
        }
    }
}
