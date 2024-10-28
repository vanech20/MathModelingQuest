//
//  StoreController.swift
//  mmq
//
//  Created by Desarrollo on 05/09/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class StoreController: UIViewController {
    
    @IBOutlet weak var coins: UILabel!
    @IBOutlet weak var accesorios: UIScrollView!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var btnAvatar: UIButton!
    @IBOutlet weak var btnShop: UIButton!
    
    var db: Firestore!
    var mAuth: Auth!
    
    override func viewDidLoad() {
    }
}
