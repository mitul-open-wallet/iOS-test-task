import DataModel
import SwiftUI

public struct ItemSummaryView: View {
    private let item: NFTItem
    
    public init(item: NFTItem) {
        self.item = item
    }
    
    public var body: some View {
        HStack(alignment: .top) {
            AsyncImage(
                url: item.thumbnailURL,
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
            .frame(width: 100, height: 100)
            VStack(alignment: .leading) {
                if let name = item.contract.name {
                    Text(name)
                        .font(.subheadline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                if let name = item.name {
                    Text(name)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Text("Balance: \(item.balance)")
            }
        }
    }
}
