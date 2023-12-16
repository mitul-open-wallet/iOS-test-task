public struct Attibute: Codable, Sendable, Equatable {
    public let value: String
    public let trait_type: String?
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.value = try container.decode(String.self, forKey: .value)
        } catch {
            let int = try container.decodeIfPresent(Double.self, forKey: .value)
            self.value = String(describing: int)
        }
        self.trait_type = try? container.decode(String.self, forKey: .trait_type)
    }
}
