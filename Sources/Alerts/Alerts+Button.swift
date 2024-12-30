import SwiftUI

extension Alerts {
    
    public struct Button: Identifiable, Sendable {
        
        public var id: String { title }
        
        let title: String
        let role: ButtonRole?
        let action: (@MainActor () -> Void)?
        
        public init(
            title: String,
            role: ButtonRole? = nil,
            action: (@MainActor () -> Void)? = nil
        ) {
            self.title = title
            self.role = role
            self.action = action
        }
    }
}

@MainActor
extension Alerts.Button {
    
    public static let ok = Alerts.Button(title: Alerts.okButtonTitle, role: .cancel)
    public static let cancel = Alerts.Button(title: Alerts.cancelButtonTitle, role: .cancel)
    public static let dismiss = Alerts.Button(title: Alerts.dismissButtonTitle, role: .cancel)
}
