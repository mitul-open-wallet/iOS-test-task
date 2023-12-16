import AlchemyAPIClient
import Dependencies
import NetworkClient

extension AlchemyAPIClient: DependencyKey {
    public static var liveValue: AlchemyAPIClient {
        @Dependency(\.networkClient) var network
        
        return AlchemyAPIClient(
            onGetNFTsForOwner: {
                apiKey, user in
                
                try await network.get(
                    path: "/nft/v3/\(apiKey.rawValue)/getNFTsForOwner",
                    params: ["owner" : .string(user.rawValue)]
                )
            }
        )
    }
}
