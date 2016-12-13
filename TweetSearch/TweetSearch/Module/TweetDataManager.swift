//
//  TweetDataManager.swift
//  TweetSearch
//
//  Created by Tasvir H Rohila on 08/12/16.
//  Copyright © 2016 Tasvir H Rohila. All rights reserved.
//

import Foundation

enum RequestHeader: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
    case userAgent = "User-Agent"
    case grantType = "grant_type"
    case clientCredentials = "client_credentials"
}

public class TweetDataManager {
    // Mark: -
    // Mark : Properties
    // Mark: Shared instance
    private static let theSharedInstance = TweetDataManager()
    
    private var tweetData: [Tweet] = []
    
    //count of filtered items
    public var tweetCount: Int {
        return tweetData.count
    }
    
    // MARK: Public
    open class var shared: TweetDataManager { return theSharedInstance }
    
    public func getAccessToken(onSuccess: @escaping (String)-> Void, onFailure: @escaping (String)-> Void ) {
        if kAppBearerAuthKey.isEmpty {
            let theURL = oAuthTokenApi
            let requestHeaderDict = self.defaultRequestHeader
            HttpManager.sharedInstance().getData(httpMethod: .Post,
                                                 url: theURL,
                                                 requestHeaderDict: requestHeaderDict,
                                                 requestBodyData: defaultRequestBody.data(using: .utf8),
                                                 onSuccess: { (apiResponse) in
                                                    DispatchQueue.main.async {
                                                        if let accessToken = apiResponse.responseJSON?["access_token"] as? String {
                                                            kAppBearerAuthKey = "Bearer \(accessToken)"
                                                            onSuccess(accessToken)
                                                        }
                                                    }
            }) { (apiResponse) in
                //Failure. Signal back onFailure to calling program
                onFailure(apiResponse.statusMessage)
            }

        }
    }
    
    public func getTweets(forQuery queryString: String, onSuccess: @escaping ()-> Void, onFailure: @escaping (String) -> Void) {
        let theURL = tweetSearchApi + (queryString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        var requestHeaderDict = self.defaultRequestHeader
        requestHeaderDict[RequestHeader.authorization.rawValue] = kAppBearerAuthKey
        
        HttpManager.sharedInstance().getData(httpMethod: .Get,
            url: theURL,
            requestHeaderDict: requestHeaderDict,
            requestBodyData: nil,
            onSuccess: { (apiResponse) in
                DispatchQueue.main.async {
                    self.populateTweets(apiResponse: apiResponse)
                    onSuccess()
                }
        }) { (apiResponse) in
            //Failure. Signal back onFailure to calling program
            onFailure(apiResponse.statusMessage)
        }
    }
    
    func getTweet(at index: Int, onComplete: ((Int) -> Void)?) -> Tweet? {
        if tweetData.count == 0 || (index < 0 || index > (tweetData.count - 1)) {
            return nil
        }

        var requestHeaderDict = self.defaultRequestHeader
        requestHeaderDict[RequestHeader.authorization.rawValue] = kAppBearerAuthKey

        var data = tweetData[index]
        guard data.user.profileImageData != nil else {
            //start the image download
            HttpManager.sharedInstance().getData(httpMethod: .Get,
                                                 url: data.user.profileImageUrl,
                                                 requestHeaderDict: requestHeaderDict,
                                                 requestBodyData: nil,
                                                 onSuccess: { (apiResponse) in ()
                                                    runForeground {
                                                        //update the carImageData dictionary
                                                        self.tweetData[index].user.profileImageData = apiResponse.responseData
                                                        onComplete?(index)
                                                    }
            },
                                                 onFailure: { (apiResponse) in ()
                                                    //
            })
            //once the image is downloaded, trigger refresh of UI as per index of the item
            return data
        }

        return data
    }
    
    
    private func populateTweets(apiResponse: HttpApiResponse) {
        self.tweetData.removeAll()
        if let JSONObjects = apiResponse.responseJSON?["statuses"] as? [[String: AnyObject]] {
            for item in JSONObjects {
                if let _tweet = Tweet(withJSON: item) {
                    self.tweetData.append(_tweet)
                }
            }
        }
    }
    
    private var defaultRequestHeader: [String: String] {
        return [RequestHeader.authorization.rawValue: kAppBasicAuthKey,
                RequestHeader.contentType.rawValue: "application/x-www-form-urlencoded;charset=UTF-8.",
                RequestHeader.userAgent.rawValue: kUserAgent
        ]
    }
    
    private var defaultRequestBody: String {
        return "\(RequestHeader.grantType.rawValue)=\(RequestHeader.clientCredentials.rawValue)"
    }

}
