import ApplicationFeature
import ComposableArchitecture
import SwiftUI

@main
struct CryptoVaultProApp: App {
    var body: some Scene {
        WindowGroup {
            ApplicationView(
                store: Store(
                    initialState: Application.State(),
                    reducer: Application.init
                )
            )
        }
    }
}
