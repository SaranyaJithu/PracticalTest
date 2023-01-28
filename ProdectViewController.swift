//
//  ProdectViewController.swift
//  PracticalTest
//
//  Created by Saranya JayaKumar on 27/01/23.
//

import UIKit

class ProdectViewController: UIViewController {

    @IBOutlet weak var productlistTableView: UITableView!
    let productdetails: [String] = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    func getProductDetails(){
        
        self.showLoadingDialog(message: "Please wait...")

        let urlStr = "http://59.163.241.38:8080/product"

               
        let headers : HTTPHeaders = ["Content-Type":"application/json"]

                Alamofire.request(urlStr, method: .get, parameters: param, encoding: JSONEncoding.default, headers:headers).responseJSON{
                    response in
                    switch response.result{
                    case .success:
                        self.hideLoadingDialog {
                            if let json = response.result.value as! [String:Any]?{
                                     if let responseValue = json["results"] as! [[String:Any]]?{
                                         self.productdetails = responseValue
                                         self.productlistTableView.reloadData()
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
extension ProdectViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return productdetails.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as? ProductTableViewCell  else {
            fatalError("Unexpected Indexpath")
            productlist = productdetails[indexPath.row]
            cell.labelProductId.texr = productdetails.id
            cell.labelProductName.text = productdetails.name
            HomeCell.labelProductRate.text = productdetails.price
            return cell
        }
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
       return UITableViewAutomaticDimension
}
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        productlist = productdetails[indexPath.row]

        let VC = self.storyboard?.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        
        vc.id = productdetails.id
        self.present(VC, animated: true, completion: nil)
    }
