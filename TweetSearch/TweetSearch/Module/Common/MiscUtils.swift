//
//  MiscUtils.swift
//  CarSalesPOC
//
//  Created by Tasvir H Rohila on 25/11/16.
//  Copyright © 2016 Tasvir H Rohila. All rights reserved.
//

import Foundation
import UIKit

//Quick display of an alert box
func showAlert(callingVC: UIViewController, title:String, message:String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
    let OK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
    alert.addAction(OK)
    
    //#COMMENTED as it gives warning "view is not in the window hierarchy"
    ///alert.show(true)
    callingVC.present(alert, animated: true, completion: nil)
}

func runForeground(theBlock: @escaping ()->Void) {
    DispatchQueue.main.async { theBlock() }
}

extension String {
    var URL:NSURL? {
        if let _decodedLink = self.removingPercentEncoding {
            if let _link = _decodedLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                return NSURL(string:_link)
            }
        }
        return nil
    }
}

extension UIImageView {
    func downloadFromURL(theURL:String , showActivity: Bool = true, onSuccess:(((UIImage)->Void)?) = nil, onFailure:(()->())? = nil) {
        if let urlRequest = theURL.URL {
            let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            
            runForeground {
                if showActivity == true {
                    self.addSubview(activity)
                    activity.center = CGPoint(x: self.bounds.midX , y: self.bounds.midY)
                    activity.autoresizingMask = [
                        .flexibleLeftMargin,
                        .flexibleRightMargin,
                        .flexibleTopMargin,
                        .flexibleBottomMargin
                    ]
                    activity.startAnimating()
                }
            }
            
            URLSession.shared.dataTask(with: NSURLRequest(url: urlRequest as URL) as URLRequest, completionHandler: {
                data, response, error in
                
                runForeground {
                    if showActivity == true {
                        activity.stopAnimating()
                        activity.removeFromSuperview()
                    }
                }
                if let data = data {
                    if let image = UIImage(data: data) {
                        runForeground {
                            self.image = image
                            onSuccess?(image)
                        }
                    }
                } else {
                    onFailure?()
                }
            }).resume()
        }
    }

}

extension Dictionary {
    var JSONData: NSData? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            return jsonData as NSData?
        } catch {
            debugPrint(error)
        }
        return nil
    }
}
