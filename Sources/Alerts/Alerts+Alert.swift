import SwiftUI

extension Alerts {
    
    public enum Alert {
        case info(title: String, message: String?, buttons: [Button])
        case warning(title: String, message: String?)
        case error(title: String, error: Error)
    }
}

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
            return error.localizedDescription
            + "\n" + ((error as NSError).localizedFailureReason ?? "")
            + "\n" + "Error Code \((error as NSError).code)"
        }
    }
    
    var buttons: [Alerts.Button] {
        switch self {
        case .info(_, _, let buttons):
            return buttons
        case .warning, .error:
            return [.ok]
        }
    }
}
