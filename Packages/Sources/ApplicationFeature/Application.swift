import AlchemyAPIClient
import ComposableArchitecture
import DataModel

@Reducer
public struct Application: Sendable {
    internal struct ViewState: Equatable {
        let items: IdentifiedArrayOf<NFTItem>
        let loading: Bool
    }
    
    public struct State: Equatable {
        internal var items = IdentifiedArrayOf<NFTItem>()
        fileprivate var nextPageKey: PageKey?
        internal var loading = false
        
        public init() {
            
        }
        
        internal var viewState: ViewState {
            ViewState(
                items: items,
                loading: loading
            )
        }
    }
    
    public enum Action: Sendable {
        case loadData
        case pulledToRefresh
        
        case local(Local)
        
        public enum Local: Sendable {
            case loaded(Result<OwnerNFTPage, any Error>)
        }
    }
    
    public init() {
        
    }
    
    @Dependency(\.alchemyAPIClient) var alchemyAPI
    
    public var body: some ReducerOf<Self> {
        Reduce {
            state, action in
            
            switch action {
            case .loadData:
                state.loading = true
                return Effect.run {
                    [nextPageKey = state.nextPageKey]
                    
                    send in
                    
                    await send(
                        .local(
                            .loaded(
                                Result {
                                    try await alchemyAPI.getNFTsForOwner(with: nextPageKey)
                                }
                            )
                        )
                    )
                }
                
            case .pulledToRefresh:
                state.nextPageKey = nil
                return Effect.send(.loadData)
                
            case .local(let action):
                switch action {
                case .loaded(.failure(let error)):
                    state.loading = false
                    return .none
                    
                case .loaded(.success(let page)):
                    state.loading = false
                    if state.nextPageKey == nil {
                        state.items = IdentifiedArray(uniqueElements: page.ownedNfts)
                    } else {
                        state.items.append(contentsOf: page.ownedNfts)
                    }
                    state.nextPageKey = page.pageKey
                    return .none
                }
            }
        }
        ._printChanges()
    }
}
