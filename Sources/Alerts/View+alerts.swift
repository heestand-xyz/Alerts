import SwiftUI

extension View {
    
    public func alerts(_ alerts: Alerts) -> some View {
        AlertView(alerts: alerts) { self }
    }
}
