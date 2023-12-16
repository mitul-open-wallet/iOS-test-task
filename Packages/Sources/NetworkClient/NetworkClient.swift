import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct NetworkClient: Sendable {
    private var baseURL = URL(string: "https://not.defined")!
    
    public internal(set) var onGet: @Sendable (URL) async throws -> Void
    
    public func with(baseURL: URL) -> Self {
        var modified = self
        modified.baseURL = baseURL
        return modified
    }
    
    public func get(path: String, params: [String: Parameter] = [:]) async throws -> Void {
        var url = baseURL.appending(path: path)
        
        if !params.isEmpty {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            var queryItems = [URLQueryItem]()
            
            for (name, value) in params {
                switch value {
                case .string(let string):
                    queryItems.append(URLQueryItem(name: name, value: string))
                }
            }
            
            components.queryItems = queryItems
            url = components.url!
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        try await perform(request: request)
    }
    
    private func perform(request: URLRequest) async throws {
        let (data, response) = try await URLSession.shared.data(for: request)
        if let string = String(data: data, encoding: .utf8) {
            print(string)
        }
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
