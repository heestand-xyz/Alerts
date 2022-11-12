import SwiftUI

extension View {
    
    public func alerts(_ alerts: Alerts) -> some View {
        self.background { AlertView(alerts: alerts) }
    }
}
