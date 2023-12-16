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
                //params["spamConfidenceLevel"] = .string("VERY_HIGH")
                params["excludeFilters[]"] = .string("SPAM")
                
                return try await network.get(
                    path: "/nft/v3/\(apiKey.rawValue)/getNFTsForOwner",
                    params: params
                )
            }
        )
    }
}
