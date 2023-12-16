public struct Raw: Codable, Sendable, Equatable {
    public let metadata: Metadata?
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            _ = try container.decode(String.self, forKey: .metadata)
            self.metadata = nil
        } catch {
            self.metadata = try container.decodeIfPresent(Metadata.self, forKey: .metadata)
        }
    }
}
