import ComposableArchitecture
import SwiftUI

public struct ItemDetailsView: View {
    private let store: StoreOf<ItemDetails>
    
    public init(store: StoreOf<ItemDetails>) {
        self.store = store
    }
    
    public var body: some View {
        Form {
            if let image = store.withState(\.item.image.cachedUrl) {
                Section {
                    AsyncImage(
                        url: image,
                        scale: 1,
                        content: {
                            phase in
                            
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } else if let error = phase.error {
                                Color.red
                            } else {
                                RoundedRectangle(cornerRadius: 4)
                                    .foregroundColor(Color.secondary)
                            }
                        }
                    )
                }
            }
            Section {
                if let name = store.withState(\.item.name) {
                    Text(name)
                }
                if let name = store.withState(\.item.description) {
                    Text(name)
                }
            }
        }
    }
}
