//
//  OtherProfileFilterVC.swift
//  Escalate
//
//  Created by call soft on 20/07/18.
//  Copyright © 2018 call soft. All rights reserved.
//

import UIKit

class OtherProfileFilterVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
//    override var prefersStatusBarHidden: Bool {
//        return true
//    }
    
    
    @IBAction func btnBackTapped(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    


}
