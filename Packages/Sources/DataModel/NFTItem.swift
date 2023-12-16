import Foundation

public struct NFTItem: Codable, Sendable, Identifiable, Equatable {
    public var id: String {
        tokenId + tokenType + contract.address // 🤷‍♂️ - get a unique conbination for IdentifiedArray used in UI
    }
    
    public let tokenId: String
    public let tokenType: String
    public let contract: Contract
}
