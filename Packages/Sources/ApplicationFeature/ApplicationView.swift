import ComposableArchitecture
import SwiftUI

public struct ApplicationView: View {
    private let store: StoreOf<Application>
    
    public init(store: StoreOf<Application>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(
            root: {
                WithViewStore(store, observe: \.viewState) {
                    viewStore in
                    
                    VStack {
                        List {
                            ForEach(viewStore.items) {
                                item in
                                
                                Text(item.contract.name)
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
                }
                .navigationTitle("CryptoVaultPro")
            }
        )
    }
}
