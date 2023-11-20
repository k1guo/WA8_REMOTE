//
//  SignUpController.swift
//  WA8
//
//  Created by 郭 on 2023/11/14.
//

import UIKit

class RegisterViewController: UIViewController {

    let registerScreen = RegisterScreen()
    
    override func loadView() {
        view = registerScreen
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        registerScreen.buttonRegister.addTarget(self, action: #selector(onRegisterTapped), for: .touchUpInside)
        title = "Register"
    }
    @objc func onRegisterTapped(){
        //MARK: creating a new user on Firebase...
        //registerNewAccount()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
