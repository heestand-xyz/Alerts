import SwiftUI

struct AlertView: View {
    
    @ObservedObject var alerts: Alerts
    
    var body: some View {
        EmptyView()
            .alert(alerts.title,
                   isPresented: alerts.isPresented,
                   presenting: alerts.alert) { alert in
                ForEach(alert.buttons) { button in
                    Button(role: button.role) {
                        button.action?()
                    } label: {
                        Text(button.title)
                    }
                }
            } message: { alert in
                if let message = alert.message {
                    Text(message)
                }
            }
    }
}
