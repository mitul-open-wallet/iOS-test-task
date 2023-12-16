public struct OwnerNFTPage: Codable, Sendable {
    public let ownedNfts: [NFTItem]
    public let pageKey: PageKey?
}
