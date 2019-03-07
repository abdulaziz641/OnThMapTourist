//
//  NetworkClient.swift
//  OnTheMapTourist
//
//  Created by Abdulaziz Alsaloum on 06/03/2019.
//  Copyright © 2019 Abdulaziz Alsaloum. All rights reserved.
//

import Foundation

class NetworkClient {
    
    static func addParameters(_ parameters: [String: Any]) -> String {
        var components = URLComponents()
        
        components.queryItems = [URLQueryItem]()
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        return components.string!
    }
    
    //MARK: Request Builder
    static func buildURLFromProperties(url: String, with data: Data? = nil, andParamaters: [String: Any]? = nil, additionalheaders: [String: String]? = nil, using method: HTTPMethod = .get) -> URLRequest {
        var request: URLRequest!
        
        // Do we have parameters?
        if !(andParamaters?.isEmpty)! {
            request = URLRequest(url: URL(string:  ("\(url)\(addParameters(andParamaters!))"))!)
        }else {
            request = URLRequest(url: URL(string: url)!)
        }
        for (headerKey, headerValue) in additionalheaders ?? [:] {
            request.addValue(headerValue, forHTTPHeaderField: headerKey)
        }
        
        // adding default headers
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method.rawValue
        request.httpBody = data
        
        return request
    }
    
    //MARK: Search For Images
    static func searchForImageFromFlickr(_ methodParameters: [String: AnyObject]?, pages: Int? = 0, lat: Double, long: Double, completion: @escaping (Bool, String?, Error?, [String]?) -> ()) {
        var methodParameters: [String: AnyObject] = [
            Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.SearchMethod,
            Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
            Constants.FlickrParameterKeys.SafeSearch: Constants.FlickrParameterValues.UseSafeSearch,
            Constants.FlickrParameterKeys.Extras: Constants.FlickrParameterValues.MediumURL,
            Constants.FlickrParameterKeys.BoundingBox: bboxString(latitude: lat, longitude: long),
            Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
            Constants.FlickrParameterKeys.NoJSONCallback: Constants.FlickrParameterValues.DisableJSONCallback,
            Constants.FlickrParameterKeys.Accuracy: Constants.FlickrParameterValues.Accuracy,
            Constants.FlickrParameterKeys.PerPage: Constants.FlickrParameterValues.PerPage
            ] as [String: AnyObject]
        if pages == 0 {
            methodParameters[Constants.FlickrParameterKeys.Page] = String(Int.random(in: 1..<1000)) as AnyObject
        }
        
        let request = buildURLFromProperties(url: Constants.Flickr.APIHost, andParamaters: methodParameters)
        
        let session = URLSession.shared
//        session.configuration.timeoutIntervalForRequest = 120
//        session.configuration.timeoutIntervalForResource = 20
        
        // Create network request
        session.dataTask(with: request) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                completion(false, nil, error, nil)
                return
            }
            
            /*GUARD: Did e receive Data? */
            guard let data = data else {
                fatalError("No data received from Server!, kindly try again")
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(false, "The repsonse is not between 200 and 299!", nil, nil)
                return
            }
            
            let responseFromFlickr = decodeJson(using: FlickResponse.self, and: data)
            
            /* GUARD: Did Flickr return an error (stat != ok)? */
            guard (responseFromFlickr.stat == Constants.FlickrResponseValues.OKStatus) else {
                completion(false, "There was failure processing your request!", nil, nil)
                return
            }
            
            var images: [String] = []
            
            for image in responseFromFlickr.photos.photo {
                let imageUrl = image.url_m?.absoluteString
                images.append(imageUrl!)
            }
            completion(true, nil, nil, images)
        }.resume()
    }
    
    //MARK Flickr bbox
    static func bboxString(latitude: Double, longitude: Double) -> String {
        // ensure bbox is bounded by minimum and maximums
        let minimumLon = max(longitude - Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.0)
        let minimumLat = max(latitude - Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.0)
        let maximumLon = min(longitude + Constants.Flickr.SearchBBoxHalfWidth, Constants.Flickr.SearchLonRange.1)
        let maximumLat = min(latitude + Constants.Flickr.SearchBBoxHalfHeight, Constants.Flickr.SearchLatRange.1)
        return "\(minimumLon),\(minimumLat),\(maximumLon),\(maximumLat)"
    }
}
