import ComposableArchitecture

@Reducer
public struct ItemDetails {
    public struct State: Equatable, Sendable {
        public init() {
            
        }
    }
    
    public enum Action: Sendable {
        
    }
    
    public init() {
        
    }
    
    public var body: some ReducerOf<Self> {
        Reduce {
            state, action in
            
            return .none
        }
    }
}
