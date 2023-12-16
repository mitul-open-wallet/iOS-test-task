import ComposableArchitecture
import ItemDetailsFeature
import SwiftUI

public struct ApplicationView: View {
    private let store: StoreOf<Application>
    
    public init(store: StoreOf<Application>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStackStore(
            store.scope(state: \.path, action: \.path),
            root: {
                WithViewStore(store, observe: \.viewState) {
                    viewStore in
                    
                    VStack {
                        List {
                            ForEach(viewStore.items) {
                                item in
                                
                                Button(action: { store.send(.tapped(item)) }) {
                                    HStack(alignment: .top) {
                                        AsyncImage(url: item.thumbnailURL)
                                            .frame(width: 100, height: 100)
                                        VStack(alignment: .leading) {
                                            Text(item.contract.name)
                                                .font(.subheadline)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            if let name = item.name {
                                                Text(name)
                                                    .font(.headline)
                                            }
                                            Text("Balance: \(item.balance)")
                                        }
                                    }
                                }
                            }
                            ProgressView()
                                .progressViewStyle(.circular)
                                .frame(maxWidth: .infinity)
                                .onAppear(perform: { store.send(.loadData) })
                        }
                        .listStyle(.plain)
                        .refreshable {
                            await viewStore.send(.pulledToRefresh, while: \.loading)
                        }
                    }
                    .buttonStyle(.plain)
                }
                .navigationTitle("CryptoVaultPro")
            },
            destination: {
                switch $0 {
                case .itemDetails:
                    CaseLet(
                        /Application.Path.State.itemDetails,
                        action: Application.Path.Action.itemDetails,
                        then: ItemDetailsView.init(store:)
                    )

                }
            }
        )
    }
}
