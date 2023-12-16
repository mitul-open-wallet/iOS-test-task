import ComposableArchitecture
import SwiftUI

public struct ItemDetailsView: View {
    private let store: StoreOf<ItemDetails>
    
    public init(store: StoreOf<ItemDetails>) {
        self.store = store
    }
    
    public var body: some View {
         Text("ItemDetails")
    }
}
