//
//  API Calling.swift
//  Sample Project Class
//
//  Created by Rankit on 17/09/20.
//  Copyright © 2020 Rankit. All rights reserved.
//
//Notes: you can use https://app.quicktype.io/ for creating model from json directly :p


import Foundation
import UIKit

class APICalling:NSObject{
    /**
     This Function is used to call get api.

     - parameter url: url with base url.
     - parameter paramet: To pass any parameter.
     - parameter header: If any header is needed to pass.
     - returns: dictionary which can use for decodable.

     # Notes: #
     1.
     2.
    */
    func getRequestWithHeader(url:String,header:[String : String]?, controlller:UIViewController,success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String) -> Void) {
        
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.requestCachePolicy = .useProtocolCachePolicy
        
        sessionConfig.httpAdditionalHeaders = header
        
        let session = URLSession(configuration: sessionConfig)
        
        let datatask = session.dataTask(with: URL(string: url)!) { (data, response, error) in
            if error == nil,data != nil {
                do{
                    if let dict = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String,AnyObject> {
                        
                        success(dict)
                        // Now you can use it by this code when needed
//                        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) {
//                            do {
//                                let finalResult = try JSONDecoder().decode(Model_name.self,from: jsonData)
//                            }catch{
//                                print("error")
//                            }
//                        }
                        
                    }
                    else
                    {
                        failed("Error reason")
                    }
                } catch let error
                {
                    failed(error.localizedDescription)
                }
            }
            else
            {
                if let error = error {
                    failed(error.localizedDescription)
                }
            }
            
        }
        datatask.resume()
    }
    /**
     This Function is used to call get api.
     
     - parameter url: url with base url.
     - parameter params: To pass any parameter.
     - parameter header: If any header is needed to pass.
     - returns: dictionary which can use for decodable.
     
     # Notes: #
     1.
     2.
     */
    
    func postRequestWithHeaderAndParam(url:String,params:[String:AnyObject]?,header:[String : String]?, controlller:UIViewController,success:@escaping (Dictionary<String, AnyObject>) -> Void, failed:@escaping (String) -> Void) {
        
        if(Reachability.isConnectedToNetwork()){
            let session = URLSession.shared
            
            var urlreq = URLRequest(url: URL(string: url)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
            urlreq.httpMethod = "POST"
            urlreq.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            urlreq.addValue("text/html", forHTTPHeaderField:"accept")
            urlreq.timeoutInterval = TimeInterval(integerLiteral: Int64(60))
            
            if params != nil{
                urlreq.httpBody = try? JSONSerialization.data(withJSONObject: params!, options: [])
            }
            
            let datatask = session.dataTask(with: urlreq) { (data, response, error) in
                if error == nil,data != nil {
                    do{
                        if let dict = try JSONSerialization.jsonObject(with: data!, options: []) as? Dictionary<String,AnyObject> {
                            
                            success(dict)
                            
                        }
                        else
                        {
                            failed("Error reason")
                        }
                    } catch let error
                    {
                        failed(error.localizedDescription)
                    }
                }
                else
                {
                    if let error = error {
                        failed(error.localizedDescription)
                    }
                }
                
            }
            datatask.resume()
            
        }else{
            debugPrint("no internet alert")
        }
    }

}
