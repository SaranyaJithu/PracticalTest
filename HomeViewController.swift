//
//  HomeViewController.swift
//  PracticalTest
//
//  Created by Saranya JayaKumar on 27/01/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var homeCollectionView: UICollectionView!
    let details: [String] = ""
    override func viewDidLoad() {
        super.viewDidLoad()
         getData()
        // Do any additional setup after loading the view.
    }
    

    func getData(){
        
        self.showLoadingDialog(message: "Please wait...")

        let urlStr = "http://59.163.241.38:8080/home"

               
        let headers : HTTPHeaders = ["Content-Type":"application/json"]

                Alamofire.request(urlStr, method: .get, parameters: param, encoding: JSONEncoding.default, headers:headers).responseJSON{
                    response in
                    switch response.result{
                    case .success:
                        self.hideLoadingDialog {
                            if let json = response.result.value as! [String:Any]?{
                                     if let responseValue = json["results"] as! [[String:Any]]?{
                                         self.details = responseValue
                                         self.homeCollectionView.reloadData()
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
extension HomeViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        details.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = homeCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCell", for: indexPath)
        productlist = details[indexPath.row]
        cell.labelProductname . text = productlist.name
        cell.labelProductRate.text = productlist.value

        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width/CGFloat(self.details?.count ?? 0)
        return CGSize(width: width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "ProdectViewController") as! ProdectViewController
        
       
        self.present(VC, animated: true, completion: nil)
    }

}
