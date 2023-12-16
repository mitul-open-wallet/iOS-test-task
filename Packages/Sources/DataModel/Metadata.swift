public struct Metadata: Codable, Sendable, Equatable {
    public let attributes: [Attibute]?
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.attributes = try container.decodeIfPresent([Attibute].self, forKey: .attributes)
        } catch {
            self.attributes = nil
        }
    }
}
