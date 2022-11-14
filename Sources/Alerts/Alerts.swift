import Foundation
import SwiftUI

public final class Alerts: ObservableObject {
   
    @Published var alert: Alert?
    
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
        DispatchQueue.main.async {
            self.alert = alert
        }
    }
}
