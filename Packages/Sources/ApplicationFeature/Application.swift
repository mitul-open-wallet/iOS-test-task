import AlchemyAPIClient
import ComposableArchitecture

@Reducer
public struct Application: Sendable {
    public struct State: Equatable {
        public init() {
            
        }
    }
    
    public enum Action: Sendable {
        case loadData
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
                    
                    try? await alchemyAPI.getNFTsForOwner()
                }
            }
        }
    }
}
