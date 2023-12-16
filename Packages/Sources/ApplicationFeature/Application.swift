import ComposableArchitecture

@Reducer
public struct Application {
    public struct State: Equatable {
        public init() {
            
        }
    }
    
    public enum Action {
        
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
