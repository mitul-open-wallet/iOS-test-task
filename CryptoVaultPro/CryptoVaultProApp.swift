import AlchemyAPIClient
import ApplicationFeature
import ComposableArchitecture
import DataModel
import NetworkClient
import SwiftUI

@main
struct CryptoVaultProApp: App {
    @Dependency(\.alchemyAPIClient) var alchemyAPI
    @Dependency(\.networkClient) var network
    
    var body: some Scene {
        WindowGroup {
            ApplicationView(
                store: Store(
                    initialState: Application.State(),
                    reducer: Application.init,
                    withDependencies: {
                        $0.alchemyAPIClient = alchemyAPI
                            .with(key: APIKey("fF7QkDcHYnH3Vihfm2Dckz4SuZz_v-XK"))
                            .with(user: ETHAddress("0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045"))
                        
                        $0.networkClient = network.with(baseURL: URL(string: "https://eth-mainnet.g.alchemy.com")!)
                    }
                )
            )
        }
    }
}
