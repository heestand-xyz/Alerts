import SwiftUI

extension Alerts {
    
    public enum Alert {
        case info(title: String, message: String?, buttons: [Button])
        case error(title: String, error: Error)
    }
}

extension Alerts.Alert {
    
    var title: String {
        switch self {
        case .info(let title, _, _):
            return title
        case .error(let title, _):
            return title
        }
    }
    
    var message: String? {
        switch self {
        case .info(_, let message, _):
            return message
        case .error(_, let error):
            return error.localizedDescription
        }
    }
    
    var buttons: [Alerts.Button] {
        switch self {
        case .info(_, _, let buttons):
            return buttons
        case .error(_, _):
            return [Alerts.Button(title: "Ok", role: .cancel)]
        }
    }
}
