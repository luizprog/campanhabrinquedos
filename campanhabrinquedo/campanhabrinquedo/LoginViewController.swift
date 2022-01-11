//
//  LoginViewController.swift
//  campanhabrinquedo
//
//  Created by user204576 on 1/10/22.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var TextFieldNome: UITextField!
    
    @IBOutlet weak var TextFieldEmail: UITextField!
    
    @IBOutlet weak var TextFieldSenha: UITextField!
    
    @IBOutlet weak var ButtonEntrar: UIButton!
    @IBOutlet weak var ButtonCriarConta: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let _ = Auth.auth().currentUser{
            goToMainScreen(isLoggedIn:true)
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func entrarFirebase(_ sender: Any) {
        Auth.auth().signIn(withEmail: TextFieldEmail.text!, password: TextFieldSenha.text!) { result, error in
            guard let user = result?.user else {return}
            self.updateUserAndProceed(user: user)
        }
        
    }
    
    @IBAction func cadastrarNoFirebase(_ sender: Any) {
        Auth.auth().createUser(withEmail: TextFieldEmail.text!, password: TextFieldSenha.text!) { result, error in
            if let error = error {
                let authErrorCode = AuthErrorCode(rawValue: error._code)
                switch authErrorCode {
                case .emailAlreadyInUse:
                    print("Este e-mail ja esta em uso")
                default:
                    print(authErrorCode)
                }
            }else{
                if let user = result?.user{
                    self.updateUserAndProceed(user: user)
                }
            }
        }
    }
    
    func updateUserAndProceed(user: User){
        if TextFieldNome.text!.isEmpty{
            goToMainScreen(isLoggedIn:  false)
        }else{
            let request = user.createProfileChangeRequest()
            request.displayName = TextFieldNome.text!
            request.commitChanges{ _ in self.goToMainScreen(isLoggedIn: false)
            }
        }
    }
    
    func goToMainScreen(isLoggedIn:Bool){
        guard let listTableViewController = storyboard?.instantiateViewController(
                withIdentifier: "RegistrosTableViewControllerID") else{
            return
        }
        !isLoggedIn ? show(listTableViewController, sender: nil) :
            navigationController?.pushViewController(listTableViewController, animated: false)
    }
}
