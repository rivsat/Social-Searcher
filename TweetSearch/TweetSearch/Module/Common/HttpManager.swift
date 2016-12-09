//
//  HttpManager.swift
//  CarPOC1
//
//  Created by Tasvir H Rohila on 24/11/16.
//  Copyright © 2016 Tasvir H Rohila. All rights reserved.
//

import Foundation
import UIKit

//Structure to hold the API reponse
struct HttpApiResponse {
    var statusCode      :   Int?                    //HTTP status code
    var statusMessage   :   String                  //Server message
    var responseJSON    :   [String : AnyObject]?   //JSON
    var responseData    :   Data?                 //Raw NSData
    var allHeaderFields :   [NSObject : AnyObject]? //Key = Value pairs of the http response
}

enum HTTPMethod: String {
    case Get = "GET"
    case Post = "POST"
    case Put = "PUT"
}

//The dafault key to be used for JSON result
let kDefaultJsonResultsKey = "kDefaultJsonResultsKey"

/**
 Class that manages the networking with API server
 */
public class HttpManager {
    
    // Mark: Shared instance
    private static let theSharedInstance = HttpManager()
    
    // MARK: Public
    public static func sharedInstance() -> HttpManager {
        return theSharedInstance
    }
    
    /**
     Main function to fetch data from server API
     
     - parameter isHttpPOST: Bool
     - parameter theURL:String URL of the end-point
     - parameter onSuccess:((HttpApiResponse?)->())? callback closure for Success
     - parameter onFailure:((HttpApiResponse)->()? callback closure for failure
     */
    func getData(httpMethod: HTTPMethod,
                 url:String,
                 requestHeaderDict: [String: String],
                 requestBodyData: Data?,
                 onSuccess:((HttpApiResponse)->())?,
                 onFailure: ((HttpApiResponse)-> ())? )
    {
        let request = composeRequest(httpMethod: httpMethod,
                                     theURL: url,
                                     theRequestHeaderDict: requestHeaderDict,
                                     theRequestBodyData: requestBodyData)
        
        self.showNetworkActivityIndicator(isVisible: true)
        
        //start the session with given request
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil && data != nil else {
                // check for fundamental networking error
                debugPrint("getData error=\(error)")
                self.showNetworkActivityIndicator(isVisible: false)
                onFailure?(HttpApiResponse(statusCode: -1,
                                           statusMessage: error?.localizedDescription ?? "Unknown server error",
                                           responseJSON: nil,
                                           responseData: nil,
                                           allHeaderFields: [:]))
                return
            }
            self.showNetworkActivityIndicator(isVisible: false)
            
            self.handleHTTPDataResponse(data: data,
                                        response: response,
                                        error: error as NSError?,
                                        onSuccess: onSuccess,
                                        onFailure: onFailure)
            
        }
        task.resume()
    }
    
    /**
     Helper method to handle HTTP response data from the API
     
     - parameter data: optional NSData as part of the response body
     - parameter response: NSURLResponse from the remote server
     - parameter error: NSError object containing the error details
     - parameter onSuccess:((HttpApiRespons?)->())? callback closure for Success
     - parameter onFailure:(((HttpApiResponse))->()? callback closure for failure
     */
    func handleHTTPDataResponse(data: Data?,
                                response: URLResponse?,
                                error: NSError?,
                                onSuccess:((HttpApiResponse)->())?,
                                onFailure: ((HttpApiResponse)-> ())? )
    {
        
        if let httpStatus = response as? HTTPURLResponse {
            if httpStatus.statusCode != 200 && httpStatus.statusCode != 201 {           // check for http errors
                debugPrint("statusCode should be 200 or 201, but is \(httpStatus.statusCode)")
                debugPrint("response = \(response)")
                //let responseData = self.parseJSON(data!)
                let statusMessage = "Unknown server error."
                onFailure?(HttpApiResponse(statusCode: httpStatus.statusCode, statusMessage: statusMessage, responseJSON: nil, responseData: nil, allHeaderFields: [:]))
            }
            else {
                let responseString = NSString(data: data! as Data, encoding: String.Encoding.utf8.rawValue)
                let responseData = self.parseJSON(data: data!)
                let statusMessage = "Unknown server error."
                let httpResponse: HttpApiResponse = HttpApiResponse(statusCode: httpStatus.statusCode, statusMessage: statusMessage, responseJSON: responseData, responseData: data, allHeaderFields: httpStatus.allHeaderFields as [NSObject : AnyObject]?)
                debugPrint("responseString = \(responseString)")
                debugPrint("responseJSON =", responseData)
                debugPrint("response Headers = ",httpStatus.allHeaderFields)
                
                onSuccess?(httpResponse)
            }
        }
    }
    
    /**
     Parse the JSON data that has been retrieved from the API
     
     - parameter data: The response data of type NSData
     - returns: array of [String: AnyObject]
     */
    func parseJSON(data: Data) -> [String: AnyObject] {
        var results:[String: AnyObject] = [:]
        do {
            let json = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments)
            debugPrint("json = \(json)")
            if let jsonDict = json as? [String:AnyObject] {
                results = jsonDict
            } else {
                if let jsonArray = json as? [AnyObject] {
                    results = [kDefaultJsonResultsKey: jsonArray as AnyObject]
                }
            }
        } catch {
            debugPrint("Error in HttpManager::parseJSON()")
        }
        return results
    }
    
    /**
     Compose HTTP request for API
     
     - parameter httpMethod: Enum for the HTTPMethod that this request takes (GET, POST, etc.)
     - parameter theURL: String URL of the request
     - parameter theRequestHeaderDict: custom envelope to be sent with the request header
     - parameter theRequestBodyData: Optional NSData that goes along with the request body
     
     - returns: NSURLRequest for this request
     
     */
    func composeRequest(httpMethod: HTTPMethod, theURL:String, theRequestHeaderDict: [String: String], theRequestBodyData: Data?) -> URLRequest {
        
        var request = URLRequest(url: NSURL(string: theURL)! as URL)
        request.httpMethod = httpMethod.rawValue
        
        //Body
        /*
        request.httpBody = "grant_type=client_credentials".data(using: .utf8)
        //Header
        request.addValue(kAppBasicAuthKey, forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Social-Searcher App ver 1.0.0", forHTTPHeaderField: "User-Agent")
        */
        
        // Custom Http body
        if theRequestBodyData != nil {
            request.httpBody = theRequestBodyData!
        }
        // Custom HTTP header fields for this request
        for (key, value) in theRequestHeaderDict {
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }

    /**
     sets the visible state of network activity indicator in top status-bar
     
     - parameter isVisible: Bool to set the visible state of network activity indicator
     */
    func showNetworkActivityIndicator(isVisible: Bool) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = isVisible
    }
    
}
