import SwiftUI

extension Alerts {
    
    public struct Button: Identifiable {
        
        public var id: String { title }
        
        let title: String
        let role: ButtonRole?
        let action: (() -> Void)?
        
        public init(title: String,
                    role: ButtonRole? = nil,
                    action: (() -> Void)? = nil) {
            self.title = title
            self.role = role
            self.action = action
        }
    }
}

extension Alerts.Button {
    
    public static let ok = Alerts.Button(title: Alerts.okButtonTitle, role: .cancel)
    public static let cancel = Alerts.Button(title: Alerts.cancelButtonTitle, role: .cancel)
    public static let dismiss = Alerts.Button(title: Alerts.dismissButtonTitle, role: .cancel)
}
