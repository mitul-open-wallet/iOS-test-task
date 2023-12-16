import AlchemyAPIClient
import Dependencies

extension AlchemyAPIClient: DependencyKey {
    public static var liveValue: AlchemyAPIClient {
        AlchemyAPIClient(
            onGetNFTsForOwner: {
                apiKey, user in
            }
        )
    }
}
