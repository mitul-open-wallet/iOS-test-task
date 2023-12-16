import Foundation

public enum AppError: Error, LocalizedError {
    case badJSON
    case fromSerever(String)
    case notAuthenticated
    case unknown(any Error)
}
