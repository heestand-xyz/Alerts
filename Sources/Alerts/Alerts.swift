import Foundation
import SwiftUI

@MainActor
@Observable
public final class Alerts: Sendable {
   
    public static var warningButton: Alerts.Button = .ok
    public static var errorButton: Alerts.Button = .ok
    
    public static var okButtonTitle: String = "Ok"
    public static var cancelButtonTitle: String = "Cancel"
    public static var dismissButtonTitle: String = "Dismiss"
    
    public static var overrideFailureMessage: ((Error) -> String)?
    
    var alert: Alert?
    
    var title: String {
        alert?.title ?? ""
    }
    
    var isPresented: Binding<Bool> {
        Binding { [weak self] in
            self?.alert != nil
        } set: { [weak self] isPresented in
            guard !isPresented else { return }
            self?.alert = nil
        }
    }
    
    public init() {}
}

extension Alerts {
    
    public func alert(_ alert: Alerts.Alert) {
        self.alert = alert
    }
}
