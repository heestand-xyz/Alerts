import Foundation
import Observation
import SwiftUI
import Testing
@testable import Alerts

@Suite(.timeLimit(.minutes(1)))
@MainActor
struct CancellableAlertTests {

    @Test func selectionResumesOnceEvenWhenDismissalPrecedesTheButton() async throws {
        let alerts: Alerts = Alerts()
        let selectedButton: Alerts.ButtonInfo = Alerts.ButtonInfo(title: "Continue")
        let task: Task<Alerts.ButtonInfo, Error> = Task(name: "CancellableAlertTests: Select Alert Button") {
            try await alerts.cancellableAlert(title: "Pending", buttons: [selectedButton])
        }
        await waitForPresentation(alerts)
        let action: @MainActor () -> Void = try #require(alerts.alert?.buttons.first?.action)
        let binding: Binding<Bool> = alerts.isPresented

        binding.wrappedValue = false
        action()
        action()

        let result: Alerts.ButtonInfo = try await task.value
        #expect(result == selectedButton)
        #expect(alerts.alert == nil)
        #expect(alerts.pendingCancellableAlert == nil)
    }

    @Test func cancellationDismissesThePendingAlertAndResumesItsCaller() async {
        let alerts: Alerts = Alerts()
        let task: Task<Alerts.ButtonInfo, Error> = Task(name: "CancellableAlertTests: Cancel Pending Alert") {
            try await alerts.cancellableAlert(title: "Pending")
        }
        await waitForPresentation(alerts)

        task.cancel()

        await expectCancellation(of: task)
        #expect(alerts.alert == nil)
        #expect(alerts.pendingCancellableAlert == nil)
    }

    @Test func dismissalWithoutSelectingAButtonResumesTheCaller() async {
        let alerts: Alerts = Alerts()
        let task: Task<Alerts.ButtonInfo, Error> = Task(name: "CancellableAlertTests: Dismiss Pending Alert") {
            try await alerts.cancellableAlert(title: "Pending")
        }
        await waitForPresentation(alerts)

        alerts.isPresented.wrappedValue = false

        await expectCancellation(of: task)
        #expect(alerts.alert == nil)
        #expect(alerts.pendingCancellableAlert == nil)
    }

    @Test func staleCancellationAndDismissalCannotRemoveAReplacement() async throws {
        let alerts: Alerts = Alerts()
        let task: Task<Alerts.ButtonInfo, Error> = Task(name: "CancellableAlertTests: Replace Canceled Alert") {
            try await alerts.cancellableAlert(title: "Pending")
        }
        await waitForPresentation(alerts)
        let action: @MainActor () -> Void = try #require(alerts.alert?.buttons.first?.action)
        let binding: Binding<Bool> = alerts.isPresented
        let pendingID: UUID = try #require(alerts.presentationID)

        task.cancel()
        alerts.alert(.info(title: "Replacement", message: nil, buttons: [.ok]))
        binding.wrappedValue = false
        action()
        alerts.resolveCancellableAlert(id: pendingID, selectedButton: nil)

        await expectCancellation(of: task)
        #expect(alerts.title == "Replacement")
        #expect(alerts.pendingCancellableAlert == nil)
    }

    @Test func replacementResumesThePreviousCaller() async {
        let alerts: Alerts = Alerts()
        let task: Task<Alerts.ButtonInfo, Error> = Task(name: "CancellableAlertTests: Replace Pending Alert") {
            try await alerts.cancellableAlert(title: "Pending")
        }
        await waitForPresentation(alerts)

        alerts.alert(.info(title: "Replacement", message: nil, buttons: [.ok]))

        await expectCancellation(of: task)
        #expect(alerts.title == "Replacement")
    }

    @Test func anAlreadyCanceledCallerDoesNotPresentAnAlert() async {
        let alerts: Alerts = Alerts()
        alerts.alert(.info(title: "Existing", message: nil, buttons: [.ok]))
        let task: Task<Alerts.ButtonInfo, Error> = Task(name: "CancellableAlertTests: Skip Canceled Alert") {
            try await alerts.cancellableAlert(title: "Pending")
        }
        task.cancel()

        await expectCancellation(of: task)
        #expect(alerts.title == "Existing")
        #expect(alerts.pendingCancellableAlert == nil)
    }

    private func waitForPresentation(_ alerts: Alerts) async {
        guard alerts.alert == nil else { return }
        await withCheckedContinuation { (continuation: CheckedContinuation<Void, Never>) in
            withObservationTracking {
                _ = alerts.alert
            } onChange: {
                continuation.resume()
            }
        }
    }

    private func expectCancellation(of task: Task<Alerts.ButtonInfo, Error>) async {
        do {
            let _: Alerts.ButtonInfo = try await task.value
            Issue.record("Expected the pending alert to report cancellation.")
        } catch {
            #expect(error is CancellationError)
        }
    }
}
