import Foundation

public struct Image: Codable, Equatable, Sendable {
    public let thumbnailUrl: URL?
    public let cachedUrl: URL?
}
