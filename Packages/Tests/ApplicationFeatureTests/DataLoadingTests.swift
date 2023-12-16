@testable import AlchemyAPIClient
@testable import ApplicationFeature
import ComposableArchitecture
import DataModel
import XCTest

@MainActor
final class DataLoadingTests: XCTestCase {
    func testKeepPagingIfLoaderVisible() async {
        let store = TestStore(
            initialState: Application.State(),
            reducer: Application.init
        )
        
        var count = 0
        func nextPage(withKey: Bool = true) -> OwnerNFTPage {
            defer {
                count += 1
            }
            
            let key: PageKey? = withKey ? PageKey(rawValue: "page-key-\(count)") : nil
            return OwnerNFTPage(ownedNfts: [], pageKey: key)
        }
        
        let responseStream = AsyncStream.makeStream(of: OwnerNFTPage.self)
        
        store.dependencies.alchemyAPIClient.onGetNFTsForOwner = {
            _, _, _ in
            
            for await value in responseStream.stream {
                return value
            }
            
            throw NSError(domain: "", code: 0)
        }
        
        await store.send(.markLoaderVisible(true)) {
            $0.loaderVisible = true
        }
        await store.receive(\.loadNextPage) {
            $0.loading = true
        }
        
        responseStream.continuation.yield(nextPage())

        
        await store.receive(\.local.loaded.success) {
            $0.nextPageKey = PageKey(rawValue: "page-key-0")
            $0.loading = false
        }
        await store.receive(\.local.maybeGoAgain)
        await store.receive(\.loadNextPage) {
            $0.loading = true
        }
        
        responseStream.continuation.yield(nextPage())
        await store.receive(\.local.loaded.success) {
            $0.nextPageKey = PageKey("page-key-1")
            $0.loading = false
        }
        await store.receive(\.local.maybeGoAgain)
        await store.receive(\.loadNextPage) {
            $0.loading = true
        }
        
        await store.send(.markLoaderVisible(false)) {
            $0.loaderVisible = false
        }
        
        responseStream.continuation.yield(nextPage())
        
        await store.receive(\.local.loaded.success) {
            $0.nextPageKey = PageKey("page-key-2")
            $0.loading = false
        }
        await store.receive(\.local.maybeGoAgain)
    }
    
    func testNoPagingIfNoNextKey() async {
        let store = TestStore(
            initialState: Application.State(),
            reducer: Application.init
        )
        
        store.dependencies.alchemyAPIClient.onGetNFTsForOwner = {
            _, _, _ in
            
            OwnerNFTPage(ownedNfts: [], pageKey: nil)
        }
        
        await store.send(.markLoaderVisible(true)) {
            $0.loaderVisible = true
        }
        await store.receive(\.loadNextPage) {
            $0.loading = true
        }
        await store.receive(\.local.loaded.success) {
            $0.loading = false
            $0.hasMore = false
        }

        await store.finish()
    }
}
