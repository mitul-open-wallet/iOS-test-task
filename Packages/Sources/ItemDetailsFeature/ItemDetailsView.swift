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
                                    .aspectRatio(1, contentMode: .fit)
                                    .foregroundColor(Color.secondary)
                                    .overlay(content: { ProgressView().progressViewStyle(.circular) })
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
            if let attributes = store.withState(\.item.raw.metadata?.attributes) {
                Section {
                    ForEach(attributes, id: \.value) {
                        attribute in
                        
                        if let type = attribute.trait_type {
                            LabeledContent(type, value: attribute.value)
                        }
                    }
                }
            }
        }
    }
}
