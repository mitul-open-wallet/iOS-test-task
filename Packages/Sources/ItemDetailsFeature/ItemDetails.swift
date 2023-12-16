import ComposableArchitecture
import DataModel

@Reducer
public struct ItemDetails {
    public struct State: Equatable, Sendable {
        internal let item: NFTItem
        public init(
            item: NFTItem
        ) {
            self.item = item
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
