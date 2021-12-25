//
//  APIClient.swift
//  rocketeer
//
//  Created by Feranmi on 24/12/2021.
//

import Foundation
import RxSwift

enum HTTPError: Error {
    case clientError(String)
    case serverError
    case invalidURL
}

extension HTTPError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .clientError(message):
            return message
        case .serverError:
            return "Server error"
        case .invalidURL:
            return "Invalid URL"
        }
    }
}

enum RequestType: String {
    case GET
    case POST
}

typealias Parameters = [String: Any]

final class APIClient {
    public func performRequest<T: Codable>(_ model: T.Type, _ endpoint: Endpoint) -> Observable<T> {
        return Observable<T>.create { observer in
            guard let componentUrl = endpoint.url else {
                observer.onError(HTTPError.invalidURL)
                return Disposables.create()
            }
            var request = URLRequest(url: componentUrl, cachePolicy: .reloadIgnoringLocalCacheData)
            request.httpMethod = endpoint.requestType.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")

            if let body = try? JSONSerialization.data(withJSONObject: endpoint.parameters, options: .prettyPrinted) {
                request.httpBody = body
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                if error != nil {
                    observer.onError(HTTPError.clientError("Unable to connect"))
                }

                guard let httpResponse = response as? HTTPURLResponse, let responseData = data else {
                    observer.onError(HTTPError.clientError("No data available"))
                    return
                }

                if 200 ..< 300 ~= httpResponse.statusCode {
                    print(String(decoding: responseData, as: UTF8.self))

                    do {
                        let result = try JSONDecoder().decode(T.self, from: responseData)
                        observer.onNext(result)
                        observer.onCompleted()
                    } catch {
                        observer.onError(HTTPError.clientError("Invalid JSON"))
                        print(error)
                    }

                } else if 400 ..< 500 ~= httpResponse.statusCode {
                    observer.onError(HTTPError.clientError("Client Error"))
                    return
                } else {
                    observer.onError(HTTPError.clientError("Cannot connect to the server"))
                }

            }.resume()

            return Disposables.create {}
        }
    }

    static func loadImage(url: String, completion: @escaping ((UIImage) -> Void)) {
        guard let url = URL(string: url) else { return }
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        completion(image)
                    }
                }
            }
        }
    }
}
