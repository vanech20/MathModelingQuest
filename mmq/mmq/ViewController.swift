//
//  ViewController.swift
//  mmq
//
//  Created by Desarrollo on 06/06/24.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "RegisterSegue", sender: self)
    }
    
}

