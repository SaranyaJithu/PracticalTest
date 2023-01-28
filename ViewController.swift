//
//  ViewController.swift
//  PracticalTest
//
//  Created by Saranya JayaKumar on 27/01/23.
//

import UIKit
import Alamofire
class ViewController: UIViewController {
    
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldUserName: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        getLoginDetails()
        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func loginAction(_ sender: Any) {
        self.showLoadingDialog(message: "Please wait...")

        let urlStr = "http://59.163.241.38:8080/auth/login"
        let param = ["username":textFieldUserName.text,"password":textFieldPassword.text]

               
        let headers : HTTPHeaders = ["Content-Type":"application/json"]

                Alamofire.request(urlStr, method: .post, parameters: param, encoding: JSONEncoding.default, headers:headers).responseJSON{
                    response in
                    switch response.result{
                    case .success:
                        self.hideLoadingDialog {
                            self.showAlert((result?["message"] as? String) ?? (error?.localizedDescription ?? "Login Failed"))
                            
                            getLoginDetails()
                        }
                        break

                    case .failure(let error):
                        self.hideLoadingDialog {
                            self.textFieldOTP.text = ""
                            self.showAlert(error?.localizedDescription ?? "Login Failed")
                        }                    }
                }
    }
    
    
    ///59.163.241.38:8080","basePath":"/","tags"
    func getLoginDetails(){
        let VC = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
       
        self.present(VC, animated: true, completion: nil)
        
            }
    
    func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    func initView(){
        textFieldUserName.layer.cornerRadius = 15.0
        textFieldUserName.layer.borderWidth = 1.0
        textFieldUserName.layer.borderColor = UIColor.systemGreen.cgColor
        textFieldPassword.layer.cornerRadius = 15.0
        textFieldPassword.layer.borderWidth = 1.0
        textFieldPassword.layer.borderColor = UIColor.systemGreen.cgColor
        buttonLogin.layer.cornerRadius = 15.0
        
    }
   
   
   
   }
