public struct OwnerNFTPage: Codable, Sendable {
    public let ownedNfts: [NFTItem]
    public let pageKey: PageKey?
    
    public init(ownedNfts: [NFTItem], pageKey: PageKey?) {
        self.ownedNfts = ownedNfts
        self.pageKey = pageKey
    }
}
