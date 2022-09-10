import Foundation

class NetworkManager: NSObject {
    
    
    typealias CompletionHandler = ((Result<Data, NetworkError>) -> Void)
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    override init() {
        self.session = URLSession.shared
    }

    //MARK: - Internal structs
    private struct authParameters {
        struct Keys {
            static let accept = "Accept"
            static let apiKey = "apikey"
        }
        static let apiKey = "38a73d59546aa378980a88b645f487fc"
    }
    
    //An NSCach object to cache images, if necessary
    private let cache = NSCache<NSString, NSData>()
    
    //Default session configuration
    private let urlSessionConfig = URLSessionConfiguration.default
    
    //Additional headers such as authentication token, go here
    private func configSession(){
        self.urlSessionConfig.httpAdditionalHeaders = [
            AnyHashable(authParameters.Keys.accept): MIMETypes.json.rawValue
        ]
    }
        
    //MARK: - Private APIs
    private func createAuthParameters(with parameters:[String:String]) -> Data? {
        guard parameters.count > 0 else {return nil}
        return  parameters.map {"\($0.key)=\($0.value)"}.joined(separator: "&").data(using: .utf8)
    }
    
    
    private func request(url:String,
                 cachePolicy: URLRequest.CachePolicy = .reloadRevalidatingCacheData,
                 httpMethod: RequestType,
                 headers:[String:String]?,
                 body: [String:String]?,
                 parameters: [URLQueryItem]?,
                 handler:  @escaping (Data?, URLResponse?, Error?) -> Void){
        
        if var urlComponent = URLComponents(string: url) {
            urlComponent.queryItems = parameters
            if let _url = urlComponent.url {
                
                var request = URLRequest(url: _url)
                request.cachePolicy = cachePolicy
                request.allHTTPHeaderFields = headers
                
                if let _body = body {
                    request.httpBody = createAuthParameters(with: _body)
                }
                request.httpMethod = httpMethod.rawValue
                
                session.dataTask(with: request) { (data, response, error) in
                    handler(data, response, error)
                }.resume()
            }
            else {
                handler(nil, nil, NetworkError.invalidURL)
            }
        }
        else {
            handler(nil, nil, NetworkError.invalidURL)
        }
    }
    
    private func isSuccessCode(_ statusCode: Int) -> Bool {
        return statusCode == NetworkConstant.ErrorCode.httpOk
    }
    
    private func isSuccessCode(_ response: URLResponse?) -> Bool {
        guard let urlResponse = response as? HTTPURLResponse else {
            return false
        }
        return isSuccessCode(urlResponse.statusCode)
    }

}


extension NetworkManager {
    
    func getMovie(completionHandler: @escaping CompletionHandler){
        
        //check network reachablity, if network not available, call completionHandler with proper error & return
        //if device is not connected with network.
//        if !ReachabilityManager.sharedInstance.isNetworkWorking {
//            completionHandler(.failure(.noNetwork))
//            return
//        }

        var queries = [URLQueryItem]()
        queries.append(URLQueryItem(name: authParameters.Keys.apiKey, value: authParameters.apiKey))
        
        request(url: EndPoints.Popular.path, httpMethod: .get, headers: nil, body: nil, parameters: queries){ (data, response, error) in
                guard let httpResponse = response as? HTTPURLResponse, let receivedData = data
                    else {
                        completionHandler(.failure(.noData))
                        return
                }
                if error == nil && self.isSuccessCode(httpResponse) {
                    completionHandler(.success(receivedData))
                }
                else {
                    completionHandler(.failure(.unknown))
                }
            }
        }
}
