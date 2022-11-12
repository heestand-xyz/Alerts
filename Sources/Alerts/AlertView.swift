import SwiftUI

struct AlertView<Content: View>: View {
    
    @ObservedObject var alerts: Alerts
    let content: () -> Content
    
    var body: some View {
        content()
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
