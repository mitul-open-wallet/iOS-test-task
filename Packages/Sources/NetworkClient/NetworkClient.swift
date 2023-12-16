import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct NetworkClient: Sendable {
    private var baseURL = URL(string: "https://not.defined")!
    private let decoder = JSONDecoder()
    
    public internal(set) var onPerformRequest: @Sendable (URLRequest) async throws -> (Data, URLResponse)
    
    public func with(baseURL: URL) -> Self {
        var modified = self
        modified.baseURL = baseURL
        return modified
    }
    
    public func get<Result: Decodable>(path: String, params: [String: Parameter] = [:]) async throws -> Result {
        var url = baseURL.appending(path: path)
        
        if !params.isEmpty {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            var queryItems = [URLQueryItem]()
            
            for (name, value) in params {
                switch value {
                case .bool(let value):
                    queryItems.append(URLQueryItem(name: name, value: String(describing: value)))

                case .int(let int):
                    queryItems.append(URLQueryItem(name: name, value: String(describing: int)))

                case .string(let string):
                    queryItems.append(URLQueryItem(name: name, value: string))
                }
            }
            
            components.queryItems = queryItems
            url = components.url!
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        return try await perform(request: request)
    }
    
    private func perform<Result: Decodable>(request: URLRequest) async throws -> Result {
        let (data, response) = try await onPerformRequest(request)
        return try decoder.decode(Result.self, from: data)
    }
}

extension NetworkClient: TestDependencyKey {
    public static var testValue: NetworkClient {
        Self()
    }
}

extension DependencyValues {
    public var networkClient: NetworkClient {
        get { self[NetworkClient.self] }
        set { self[NetworkClient.self] = newValue }
    }
}
