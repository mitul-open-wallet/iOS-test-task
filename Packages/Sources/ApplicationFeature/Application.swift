import AlchemyAPIClient
import ComposableArchitecture
import DataModel
import ItemDetailsFeature

@Reducer
public struct Application: Sendable {
    internal struct ViewState: Equatable {
        let items: IdentifiedArrayOf<NFTItem>
        let loading: Bool
        let hasMore: Bool
    }
    
    public struct State: Equatable {
        internal var path = StackState<Path.State>()
        
        internal var items = IdentifiedArrayOf<NFTItem>()
        internal var nextPageKey: PageKey?
        internal var loading = false
        internal var loaderVisible = false
        internal var hasMore = true
        
        public init() {
            
        }
        
        internal var viewState: ViewState {
            ViewState(
                items: items,
                loading: loading,
                hasMore: hasMore
            )
        }
    }
    
    public enum Action: Sendable {
        case loadNextPage
        case markLoaderVisible(Bool)
        case pulledToRefresh
        case tapped(NFTItem)
        
        case local(Local)
        case path(StackAction<Path.State, Path.Action>)
        
        @CasePathable
        public enum Local: Sendable {
            case loaded(Result<OwnerNFTPage, any Error>)
            case maybeGoAgain
        }
    }
    
    public init() {
        
    }
    
    @Dependency(\.alchemyAPIClient) var alchemyAPI
    
    public var body: some ReducerOf<Self> {
        Reduce {
            state, action in
            
            switch action {
            case .loadNextPage:
                if state.loading {
                    return .none
                }
                
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
                    state.hasMore = page.pageKey != nil
                    
                    if page.pageKey == nil {
                        return .none
                    } else {
                        return Effect.send(.local(.maybeGoAgain))
                    }
                    
                case .maybeGoAgain:
                    guard state.loaderVisible else {
                        return .none
                    }
                    return Effect.send(.loadNextPage)
                }
                
            case .markLoaderVisible(let visible):
                state.loaderVisible = visible
                
                if visible {
                    return Effect.send(.loadNextPage)
                } else {
                    return .none
                }
                
            case .pulledToRefresh:
                state.nextPageKey = nil
                state.hasMore = true
                return Effect.send(.loadNextPage)
                
            case .tapped(let item):
                state.path.append(.itemDetails(ItemDetails.State(item: item)))
                return .none
                
            case .path:
                return .none
            }
        }
        ._printChanges()
        .forEach(\.path, action: \.path) {
            Path()
        }
    }
    
    @Reducer
    public struct Path {
        public enum State: Equatable, Sendable {
            case itemDetails(ItemDetails.State)
        }
        
        public enum Action: Sendable {
            case itemDetails(ItemDetails.Action)
        }
        
        public var body: some ReducerOf<Self> {
            Scope(state: \.itemDetails, action: \.itemDetails) {
                ItemDetails()
            }
        }
    }
}
