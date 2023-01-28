
//

import Foundation
import SystemConfiguration

//let hostUrl = "https://evvdev.caretap.net/"

let hostUrl = "http://59.163.241.38:8080/"
//let hostUrl = "https://qamax.caretap.net/"


class ServiceManager: NSObject {
    var baseUrl : String!
//    var finishLoading: ((Bool? ,AnyObject? ,Error?) -> Void)!
    var session: URLSession!
    
    override init() {
        super.init()
        //setting main url
        self.baseUrl = hostUrl
        session = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: OperationQueue.main)
    }
    
    class func fetchDataFromService(serviceName: String, parameters : [String: AnyObject]?, formData: NSMutableData? = nil, withCompletion completion: @escaping (_ success : Bool, _ result: AnyObject?, _ error: Error?)-> Void){
       
      
        
        let serviceManager = ServiceManager()
        #if DEBUG
        print("Host Url", hostUrl)
        print("Service Name:", serviceName)
        print("Request Parameters:", parameters ?? [:])
        #endif
        
        let body = formData ?? NSMutableData.postData()
        if let dict = parameters {
            for (key, value) in dict {
                body.addValue(value, key: key)
            }
        }
        body.endData()
        serviceManager.httpRequestForService(serviceName: serviceName, serviceMethod: "POST", parameters: body as Data) { (success, result, error) -> Void in
            completion(success!, result, error)
        }
    }
    
    class func getDataFromService(serviceName: String, parameters : [String: AnyObject]?, formData: NSMutableData? = nil, withCompletion :@escaping (_ success : Bool, _ result: AnyObject?, _ error: Error?)-> Void){
        
       
        let serviceManager = ServiceManager()
        #if DEBUG
        print(serviceName)
        print(parameters ?? [:])
        #else
        #endif
        
        var serviceUrl = serviceName.hasSuffix("?") ? serviceName : serviceName + "?"
        if let dict = parameters {
            for (key, value) in dict {
                serviceUrl.append("\(key)=\(value)&")
            }
        }
        
        serviceManager.httpRequestForService(serviceName: serviceUrl, serviceMethod: "GET", parameters: nil) { (success, result, error) -> Void in
            withCompletion(success!, result, error)
        }
    }
    
    func httpRequestForService(serviceName: String, serviceMethod method: String, parameters : Data?, completion :@escaping (_ success : Bool?, _ result: AnyObject?, _ error: Error?)-> Void) {
        let url = URL(string: (self.baseUrl! + serviceName).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? (self.baseUrl! + serviceName))
        
        let request = prepareRequestWithURL(url: url!, serviceMethod: method, parameters: parameters)
        
        session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print("Service error:",error?.localizedDescription ?? "")
                #endif
              
            } else if let responseData = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: responseData, options:[.allowFragments]) as AnyObject
                    #if DEBUG
                    print(json)
                    #endif
                    DispatchQueue.main.async {
                        completion(true, json, nil)
                    }
                } catch let catchError {
                    #if DEBUG
                    print("json error:",catchError.localizedDescription)
                    #endif
                    DispatchQueue.main.async {
                        completion(false, nil, catchError)
                    }
                }
            }
        }.resume()
    }
    
    func prepareRequestWithURL(url: URL, serviceMethod method: String, parameters : Data?) -> URLRequest {
        let request = NSMutableURLRequest()
        request.url = url
        
        request.httpMethod = method
        let charset = String(CFStringConvertEncodingToIANACharSetName(CFStringConvertNSStringEncodingToEncoding(String.Encoding.utf8.rawValue)))
        
        if method == "POST" {
            let contentType = "multipart/form-data; charset=\(charset); boundary=0xBhEmRbLuIdNrS"
            request.addValue(contentType, forHTTPHeaderField: "Content-Type")
            if(parameters != nil) {
                request.httpBody = parameters
            }
        }
        return request as URLRequest
    }
}

extension ServiceManager: URLSessionDelegate {
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {

    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {

    }
}
