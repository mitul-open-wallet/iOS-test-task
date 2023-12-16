import AlchemyAPIClient
import ComposableArchitecture
import DataModel

@Reducer
public struct Application: Sendable {
    public struct State: Equatable {
        internal var items = IdentifiedArrayOf<NFTItem>()
        
        public init() {
            
        }
    }
    
    public enum Action: Sendable {
        case loadData
        
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
                return Effect.run {
                    send in
                    
                    await send(
                        .local(
                            .loaded(
                                Result {
                                    try await alchemyAPI.getNFTsForOwner()
                                }
                            )
                        )
                    )
                }
                
            case .local(let action):
                switch action {
                case .loaded(.failure(let error)):
                    return .none
                    
                case .loaded(.success(let page)):
                    state.items.append(contentsOf: page.ownedNfts)
                    return .none
                }
            }
        }
        ._printChanges()
    }
}
