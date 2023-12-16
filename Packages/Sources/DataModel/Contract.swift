import Foundation

public struct Contract: Codable, Sendable, Equatable {
    public let address: String
    public let name: String?
    public let openSeaMetadata: SpenSeaMetadata
}
