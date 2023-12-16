public struct ServerErrorMessage: Codable {
    public struct Message: Codable {
        public let message: String
    }
    
    public let error: Message
}
