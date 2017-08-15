//
//  HTTPClient.swift
//  ChatBot
//
//  Created by Corey Davis on 8/7/17.
//  Copyright © 2017 Corey Davis. All rights reserved.
//

import Foundation
import os.log

var sharedClient: HTTPClient?

class HTTPClient {
    class var shared: HTTPClient? {
        get {
            if(sharedClient == nil) {
                sharedClient = HTTPClient()
            }

            return(sharedClient)
        }
    }

    func makeRequest(to urlString: String, with question: String, completion: @escaping (Data?) -> ()) {
        guard let parameterString = question.addingPercentEncodingForURLQueryValue() else {
            return
        }

        if let requestURL = URL(string:"\(urlString)?text=\(parameterString)") {
            let request = NSMutableURLRequest(url: requestURL)
            request.httpMethod = "POST"

            URLSession.shared.dataTask(with: request as URLRequest) {
                (data, response, error) in
                if error != nil {
                    os_log("request failed to complete", type: .error)
                    return completion(nil)
                } else  {
                    return completion(data)
                }
            }.resume()
        }
    }


    // for testing
    func jsonAsDictionary() -> [AnyHashable: Any?]? {
        var dict = [AnyHashable: Any?]()

        do {
            if let file = Bundle.main.url(forResource: "response", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [AnyHashable: Any?] {
                    dict = object
                }
            } else {
                os_log("JSON is invalid")
            }
        } catch {
            os_log("No file found")
        }

        return dict
    }

}


extension String {

    /// Percent escapes values to be added to a URL query as specified in RFC 3986
    ///
    /// This percent-escapes all characters besides the alphanumeric character set and "-", ".", "_", and "~".
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: Returns percent-escaped string.

    func addingPercentEncodingForURLQueryValue() -> String? {
        let allowedCharacters = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")

        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }

}

extension Dictionary {

    /// Build string representation of HTTP parameter dictionary of keys and objects
    ///
    /// This percent escapes in compliance with RFC 3986
    ///
    /// http://www.ietf.org/rfc/rfc3986.txt
    ///
    /// :returns: String representation in the form of key1=value1&key2=value2 where the keys and values are percent escaped

    func stringFromHttpParameters() -> String {
        let parameterArray = self.map { (key, value) -> String in
            let percentEscapedKey = (key as! String).addingPercentEncodingForURLQueryValue()!
            let percentEscapedValue = (value as! String).addingPercentEncodingForURLQueryValue()!
            return "\(percentEscapedKey)=\(percentEscapedValue)"
        }

        return parameterArray.joined(separator: "&")
    }
    
}
