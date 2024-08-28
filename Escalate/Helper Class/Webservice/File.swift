//
//  File.swift
//   Created by Devshashi pandey 
//

import Foundation
import Alamofire
import SwiftyJSON

class AlmofireWrapper: NSObject {
    
    //MARK:- For Get Type  webservice
    //MARK:-
    static let alamofireManager: SessionManager = {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 10
        return Alamofire.SessionManager(configuration: sessionConfiguration)
    }()
    
    var responseCode = 0
    
    // let baseURL = "http://mobulous.app/escalate/api/"
    // let baseURL = "http://mobulous.in/escalate/api/"
    // let baseURL = "http://ec2-54-194-198-217.eu-west-1.compute.amazonaws.com/escalate/api/"
    let baseURL = "http://escalateapp.co.uk/escalate/api/"
   
  
    
    func requestGETURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        var strURL =  (strURL as String)
        
        strURL = baseURL + "\(strURL)"
        
        let urlValue = URL(string: strURL)!
        
        print(strURL)
        print(urlValue)
        _ = URLRequest(url: urlValue)
        
        Alamofire.request(urlValue).responseJSON { (responseObject) -> Void in
            
            print(responseObject)
            
            if responseObject.result.isSuccess {
                
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
                self.responseCode = 1
                
            }
            if responseObject.result.isFailure {
                let error : Error = responseObject.result.error!
                failure(error)
                
                self.responseCode = 2
            }
        }
    }
    
    
    //MARK:- For POST Type  webservice
    //MARK:-
    
    func requestPOSTURL(_ strURL : String, params : [String : AnyObject]!, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
        
        let urlString = baseURL + (strURL as String)
        
        let urlValue = URL(string: urlString)!
        
        var request = URLRequest(url: urlValue)
        print(urlValue)
        
        print(params!)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        Alamofire.request(urlValue, method: .post, parameters: params, encoding: JSONEncoding.default, headers:headers).responseJSON { (responseObject) -> Void in
            
            if responseObject.result.isSuccess {
                
                let resJson = JSON(responseObject.result.value!)
                success(resJson)
                self.responseCode = 1
            }
            if responseObject.result.isFailure {
                
                let error : Error = responseObject.result.error!
                failure(error)
                
                self.responseCode = 2
            }
        }
        
        
        
    }
    
    
    func requWithFile( imageData:NSData,fileName: String,imageparam:String, urlString:String, parameters : [String : AnyObject]?, headers : [String : String]?,success: @escaping (JSON) -> Void,failure:@escaping (Error) -> Void) {
        
        let urlString = baseURL + (urlString as String)
        
        let urlValue = URL(string: urlString)!
        
        var request = URLRequest(url: urlValue)
        
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        
        Alamofire.upload( multipartFormData: { multipartFormData in

            multipartFormData.append(imageData as Data, withName: imageparam, fileName: fileName, mimeType:"image/png")


            for (key, value) in parameters! {

                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )

            }
        },
                          to: urlString,
                          encodingCompletion: { encodingResult in

                            switch encodingResult {

                            case .success(let upload, _, _):

                                upload.responseJSON { response in

                                    print(response.result.value)

                                    if((response.result.value != nil)){

                                        self.responseCode = 1

                                        let resJson = JSON(response.result.value!)
                                        success(resJson)

                                    }else{

                                        self.responseCode = 2

                                        let error : Error = response.result.error!
                                        failure(error)


                                    }



                                }


                            case .failure(let encodingError):
                                self.responseCode = 2
                                print(encodingError)
                                let error : Error = encodingError
                                failure(error)

                            }
        })

    
    }
    
    
    
    
    func requWithFilewith2Data( imageData:NSData,audioData:NSData,fileName1: String,fileName2: String,imageparam1:String,imageparam2:String, urlString:String, parameters : [String : AnyObject]?, headers : [String : String]?,success: @escaping (JSON) -> Void,failure:@escaping (Error) -> Void) {
        
        let urlString = baseURL + (urlString as String)
        
        let urlValue = URL(string: urlString)!
        
        var request = URLRequest(url: urlValue)
        
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        
        Alamofire.upload( multipartFormData: { multipartFormData in
            
            multipartFormData.append(imageData as Data, withName: imageparam1, fileName: fileName1, mimeType:"image/jpg")
            multipartFormData.append(audioData as Data, withName: imageparam2, fileName: fileName2, mimeType:"recording/mp3")
            
            for (key, value) in parameters! {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
        },
                          to: urlString,
                          encodingCompletion: { encodingResult in
                            
                            switch encodingResult {
                                
                            case .success(let upload, _, _):
                                
                                upload.responseJSON { response in
                                    
                                    print(response.result.value)
                                    
                                    if((response.result.value != nil)){
                                        
                                        self.responseCode = 1
                                        
                                        let resJson = JSON(response.result.value!)
                                        success(resJson)
                                        
                                    }else{
                                        
                                        self.responseCode = 2
                                        
                                        let error : Error = response.result.error!
                                        failure(error)
                                        
                                        
                                    }
                                    
                                    
                                    
                                }
                                
                                
                            case .failure(let encodingError):
                                self.responseCode = 2
                                print(encodingError)
                                let error : Error = encodingError
                                failure(error)
                                
                            }
        })
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func requWithAudioFile(audioData:NSData,fileName: String,audioparam:String, urlString:String, parameters : [String : AnyObject]?, headers : [String : String]?,success: @escaping (JSON) -> Void,failure:@escaping (Error) -> Void) {
        
        let urlString = baseURL + (urlString as String)
        
        let urlValue = URL(string: urlString)!
        
        var request = URLRequest(url: urlValue)
        
        request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
        
        Alamofire.upload( multipartFormData: { multipartFormData in
            
            multipartFormData.append(audioData as Data, withName: audioparam, fileName: fileName, mimeType:"recording/mp3")
            
            
            for (key, value) in parameters! {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
                
            }
        },
                          to: urlString,
                          encodingCompletion: { encodingResult in
                            
                            switch encodingResult {
                                
                            case .success(let upload, _, _):
                                
                                upload.responseJSON { response in
                                    
                                    print(response.result.value)
                                    
                                    if((response.result.value != nil)){
                                        
                                        self.responseCode = 1
                                        
                                        let resJson = JSON(response.result.value!)
                                        success(resJson)
                                        
                                    }else{
                                        
                                        self.responseCode = 2
                                        
                                        let error : Error = response.result.error!
                                        failure(error)
                                        
                                        
                                    }
                                    
                                    
                                    
                                }
                                
                                
                            case .failure(let encodingError):
                                self.responseCode = 2
                                print(encodingError)
                                let error : Error = encodingError
                                failure(error)
                                
                            }
        })
        
        
    }
    
    

    
}
