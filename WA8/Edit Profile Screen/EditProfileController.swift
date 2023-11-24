//
//  EditProfileController.swift
//  WA8
//
//  Created by 郭 on 2023/11/24.
//

import UIKit

class EditProfileController: UIViewController {
    
    let editScreen = EditProfile()
    
    override func loadView() {
        view = editScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        editScreen.buttonSave.addTarget(self, action: #selector(onSaveTapped), for: .touchUpInside)
    }
    
    @objc func onSaveTapped(){
        
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
