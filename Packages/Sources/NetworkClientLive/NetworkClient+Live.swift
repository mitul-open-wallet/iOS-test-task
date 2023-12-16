import Dependencies
import Foundation
import NetworkClient

extension NetworkClient: DependencyKey {
    public static var liveValue: NetworkClient {
        NetworkClient(onPerformRequest: { try await URLSession.shared.data(for: $0) })
    }
}
