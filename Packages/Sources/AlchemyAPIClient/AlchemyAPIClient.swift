import Dependencies
import DependenciesMacros

@DependencyClient
public struct AlchemyAPIClient: Sendable {
    private var apiKey = APIKey("<-- undefined -->")
    private var user = ETHAddress("<-- undefined -->")
    
    public internal(set) var onGetNFTsForOwner: @Sendable (APIKey, ETHAddress) async throws -> Void
    
    public func with(key: APIKey) -> AlchemyAPIClient {
        var modified = self
        modified.apiKey = key
        return modified
    }
    
    public func with(user: ETHAddress) -> AlchemyAPIClient {
        var modified = self
        modified.user = user
        return modified
    }
    
    public func getNFTsForOwner() async throws -> Void {
        try await onGetNFTsForOwner(apiKey, user)
    }
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
