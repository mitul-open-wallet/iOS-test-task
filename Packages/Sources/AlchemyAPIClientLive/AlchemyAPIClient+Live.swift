import AlchemyAPIClient
import Dependencies
import NetworkClient

extension AlchemyAPIClient: DependencyKey {
    public static var liveValue: AlchemyAPIClient {
        @Dependency(\.networkClient) var network
        
        return AlchemyAPIClient(
            onGetNFTsForOwner: {
                apiKey, user, nextPage in
                
                var params: [String: Parameter] = ["owner" : .string(user.rawValue)]
                if let nextPage {
                    params["pageKey"] = .string(nextPage.rawValue)
                }
                
                return try await network.get(
                    path: "/nft/v3/\(apiKey.rawValue)/getNFTsForOwner",
                    params: params
                )
            }
        )
    }
}
