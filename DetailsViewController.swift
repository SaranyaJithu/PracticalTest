//
//  DetailsViewController.swift
//  PracticalTest
//
//  Created by Saranya JayaKumar on 27/01/23.
//

import UIKit

class DetailsViewController: UIViewController {

    @IBOutlet weak var textViewDescription: UITextView!
    @IBOutlet weak var labelProductId: UILabel!
    @IBOutlet weak var labelProductName: UILabel!
    @IBOutlet weak var labelProduct: UILabel!
    
    var id: String = ""
    let productdetails: [String] = ""

    override func viewDidLoad() {
        super.viewDidLoad()
       getDetails()
        // Do any additional setup after loading the view.
    }
    
    func getDetails(){
        
        self.showLoadingDialog(message: "Please wait...")

        let urlStr = "http://59.163.241.38:8080/product/get/(id)"

               
        let headers : HTTPHeaders = ["Content-Type":"application/json"]

                Alamofire.request(urlStr, method: .get, parameters: param, encoding: JSONEncoding.default, headers:headers).responseJSON{
                    response in
                    switch response.result{
                    case .success:
                        self.hideLoadingDialog {
                            if let json = response.result.value as! [String:Any]?{
                                     if let responseValue = json["results"] as! [[String:Any]]?{
                                         self.productdetails = responseValue
                                         self.labelProductId.text = productdetails.id
                                         self.labelProductName.text = productdetails.name
                                         self.description.text = productdetails.description
                                     }
                        }
                        break

                    case .failure(let error):
                        self.hideLoadingDialog {
                          
                            self.showAlert(error?.localizedDescription ?? "Error")
                        }                    }
                }
    }

   

}
