import Dependencies
import DependenciesMacros

@DependencyClient
public struct AlchemyAPIClient: Sendable {
    
}

extension AlchemyAPIClient: TestDependencyKey {
    public static var testValue: AlchemyAPIClient {
        Self()
    }
}

extension DependencyValues {
    public var alchemyAPIClient: AlchemyAPIClient {
        get { self[AlchemyAPIClient.self] }
        set { self[AlchemyAPIClient.self] = newValue }
    }
}
