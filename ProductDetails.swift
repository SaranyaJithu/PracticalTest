//
//  ProductDetails.swift
//  PracticalTest
//
//  Created by Saranya JayaKumar on 28/01/23.
//

import Foundation
class productDetails: Codable {
    
    var  poduct: [productDetails]
}

class  productDetails: Codable {
    var description: String = ""
    var image: String = ""
    var id: String = ""
    var name: String = ""
    var price: String = ""
}
