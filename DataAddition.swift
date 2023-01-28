//
//  DataAddition.swift
//  Staff CheckIn
//
//  Created by Berlin Raj on 23/03/18.
//  Copyright © 2018 SRS Web Solutions. All rights reserved.
//

import Foundation

extension NSMutableData
{
    //MARK:- //Service manager helper class
    class func postData () -> NSMutableData {
        let data = NSMutableData ()
        data.appendPostBoundary()
        return data
    }
    
    func appendPostBoundary () {
        let data = "\r\n--0xBhEmRbLuIdNrS".data(using: String.Encoding.utf8)
        self.append(data!)
    }
    
    func addValue (_ value : AnyObject , key : String) {
        if value.isKind(of: NSDictionary.self) {
            for (objKey, objValue) in value as? [String: AnyObject] ?? [:] {
                self.append("\r\nContent-Disposition: form-data; name=\"\(key)[\(objKey)]\"\r\n\r\n\(objValue)".data(using: String.Encoding.utf8)!)
                self.appendPostBoundary()
            }
        } else {
            self.append("\r\nContent-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".data(using: String.Encoding.utf8)!)
            self.appendPostBoundary()
        }
    }
    
    func addValue (_ value : AnyObject? , key : String , filename : String, mimeType: String = "image/jpeg") {
        self.append("\r\nContent-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"".data(using: String.Encoding.utf8)!)
        self.append("\r\nContent-Type: \(mimeType)\r\n\r\n".data(using: String.Encoding.utf8)!)
        if let _: AnyObject = value {
            self.append(value as! Data)
        }
        self.appendPostBoundary()
    }
    
    func endData() {
        self.append("--\r\n".data(using: String.Encoding.utf8)!)
    }
}
