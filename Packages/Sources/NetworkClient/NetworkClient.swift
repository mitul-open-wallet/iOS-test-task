import Dependencies
import DependenciesMacros

@DependencyClient
public struct NetworkClient: Sendable {
    
}

extension NetworkClient: TestDependencyKey {
    public static var testValue: NetworkClient {
        Self()
    }
}

extension DependencyValues {
    public var networkClient: NetworkClient {
        get { self[NetworkClient.self] }
        set { self[NetworkClient.self] = newValue }
    }
}
