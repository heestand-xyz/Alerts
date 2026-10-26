import Foundation

extension Alerts {

    struct PendingCancellableAlert {
        let id: UUID
        let continuation: CheckedContinuation<ButtonInfo?, Never>
    }

    /// Throws when the task is canceled or the alert is dismissed or replaced.
    @discardableResult
    public func cancellableAlert(
        title: String,
        message: String? = nil,
        buttons: [ButtonInfo] = [.ok]
    ) async throws(CancellationError) -> ButtonInfo {
        let id: UUID = UUID()
        let selectedButton: ButtonInfo? = await withTaskCancellationHandler {
            await withCheckedContinuation { (continuation: CheckedContinuation<ButtonInfo?, Never>) in
                guard !Task.isCancelled else {
                    continuation.resume(returning: nil)
                    return
                }
                let actionButtons: [Button] = buttons.map { button in
                    Button(title: button.title, role: button.role) { [weak self] in
                        self?.resolveCancellableAlert(id: id, selectedButton: button)
                    }
                }
                present(
                    .info(title: title, message: message, buttons: actionButtons),
                    id: id,
                    pending: PendingCancellableAlert(id: id, continuation: continuation)
                )
            }
        } onCancel: {
            Task(name: "Alerts: Cancel Pending Alert") { @MainActor [weak self] in
                self?.resolveCancellableAlert(id: id, selectedButton: nil)
            }
        }
        guard let selectedButton, !Task.isCancelled else {
            throw CancellationError()
        }
        return selectedButton
    }

    func present(_ alert: Alert, id: UUID, pending: PendingCancellableAlert? = nil) {
        let previousPending: PendingCancellableAlert? = pendingCancellableAlert
        pendingCancellableAlert = pending
        presentationID = id
        self.alert = alert
        previousPending?.continuation.resume(returning: nil)
    }

    func dismissAlert(id: UUID?) {
        guard let id, presentationID == id else { return }
        if pendingCancellableAlert?.id == id {
            presentationID = nil
            alert = nil
            // SwiftUI can update the binding before invoking the selected button.
            Task(name: "Alerts: Finish Dismissed Alert") { @MainActor [weak self] in
                self?.resolveCancellableAlert(id: id, selectedButton: nil)
            }
        } else {
            presentationID = nil
            alert = nil
        }
    }

    func resolveCancellableAlert(id: UUID, selectedButton: ButtonInfo?) {
        guard let pending: PendingCancellableAlert = pendingCancellableAlert,
              pending.id == id else { return }
        pendingCancellableAlert = nil
        if presentationID == id {
            presentationID = nil
            alert = nil
        }
        pending.continuation.resume(returning: selectedButton)
    }
}
