//
//  ServerCommunication.swift
//  GitHubAPI
//
//  Created by Pratik on 19/08/20.
//  Copyright © 2020 Pratik. All rights reserved.
//

import Alamofire
final class ServerCommunication {
    static let sharedInstance: ServerCommunication = ServerCommunication()
    
    /// API request method
    /// - Parameters:
    ///   - requestHelper: request object
    ///   - completion: respone object
    /// - Returns: DataRequest
    @discardableResult func request(with requestHelper: RequestHelper?,completion : ((_ response : ResponseHelper) -> Void)?) -> DataRequest? {
        guard let requestData = requestHelper, let url = try? requestData.url.asURL() else {
            let responseData = ResponseHelper(isSuccess: false, statusCode: 400, responseData: nil, error: nil)
            completion?(responseData)
            return nil
        }
        
        func networkIndicatorVisible(isTrue : Bool) {
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = isTrue
            }
        }
        
        networkIndicatorVisible(isTrue: true)
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestData.method.rawValue
        urlRequest.allHTTPHeaderFields = requestData.headers
        urlRequest.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        if let param = requestData.parameters, let data = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) {
            urlRequest.httpBody = data
        }
        let cURL = AF.request(urlRequest).responseJSON {
            response in
            let statusCode = response.response?.statusCode ?? 0
            print("Request url : \(requestData.url)")
            print("Server status code : \(statusCode.description)")
            networkIndicatorVisible(isTrue: false)
            switch response.result {
            case .success:
                //print(response)
                let responseData = ResponseHelper(isSuccess: true, statusCode: statusCode, responseData: response.data, error: response.error)
                completion?(responseData)
                break
            case .failure(let error):
                print(error)
                let responseData = ResponseHelper(isSuccess: false, statusCode: statusCode, responseData: response.data, error: error)
                completion?(responseData)
                break
            }
        }
        debugPrint(cURL)
        return cURL
    }
    
    /// Internet rechability checking
    class func isConnectedToInternet() -> Bool {
        return NetworkReachabilityManager()?.isReachable ?? false
    }
}

/// Request helper struct
struct RequestHelper {
    let url: URLConvertible
    var method: HTTPMethod = .get
    var parameters: Parameters? = nil
    var encoding: ParameterEncoding = URLEncoding.default
    var headers: [String : String]? = nil
    ///Modification time store
    var isStoreModificationTime = false
    var userID : String?
    init(url: URLConvertible, method: HTTPMethod = .get) {
        self.url = url
        self.method = method
    }
    
    init(url: URLConvertible, method: HTTPMethod, parameters: Parameters) {
        self.url = url
        self.method = method
        self.parameters = parameters
    }
    
    init(url: URLConvertible, method: HTTPMethod, headers: [String : String]?) {
        self.url = url
        self.method = method
        self.headers = headers
    }
    
    init(url: URLConvertible, method: HTTPMethod, parameters: Parameters, headers: [String : String]?) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = headers
    }
    
    init(url: URLConvertible, method: HTTPMethod, parameters: Parameters, encoding: ParameterEncoding, headers: [String : String]?) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.encoding = encoding
        self.headers = headers
    }
}

/// Response Helper struct
struct ResponseHelper {
    var isSuccess : Bool
    let statusCode : Int
    let responseData : Data?
    let error : Error?
    init(isSuccess : Bool, statusCode : Int, responseData : Data?, error : Error?) {
        self.isSuccess = isSuccess
        self.statusCode = statusCode
        self.responseData = responseData
        self.error = error
    }
}
