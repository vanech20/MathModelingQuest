//
//  LevelsViewController.swift
//  mmq
//
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LevelsViewController: UIViewController {
    
    @IBOutlet weak var btnLevel1: UIButton!
    @IBOutlet weak var btnLevel2: UIButton!
    @IBOutlet weak var btnLevel3: UIButton!
    @IBOutlet weak var backBtn: UIBarButtonItem!
    @IBOutlet weak var coinsLbl: UILabel!
    
    var mAuth: Auth!
    var db: Firestore!
    var isla: String?
    var base: String?
    var baseP: String?
    var level: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        mAuth = Auth.auth()
        
        // Check if the user is authenticated
        guard mAuth.currentUser != nil else {
            // Redirect to login screen if not authenticated
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let loginVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as? LogInController {
                self.present(loginVC, animated: true, completion: nil)
            }
            return
        }
        
        backBtn.target = self
        backBtn.action = #selector(backButtonTapped)
        
        // Configurar OnClickListeners para los botones de nivel
        btnLevel1.addTarget(self, action: #selector(level1Tapped), for: .touchUpInside)
        btnLevel2.addTarget(self, action: #selector(level2Tapped), for: .touchUpInside)
        btnLevel3.addTarget(self, action: #selector(level3Tapped), for: .touchUpInside)
        
        // Get passed parameters from previous view controller
        if let receivedIsla = self.isla, let _ = self.base, let _ = self.baseP {
            configureLevelVisibility(isla: receivedIsla)
        }
        
        // Set up back button action
        //backBtn.action = #selector(backButtonTapped)
        
        getData()
    }
    @objc func level1Tapped() {
            navigateToLevel(level: "L1")
        }
    @objc func level2Tapped() {
            navigateToLevel(level: "L2")
        }
    @objc func level3Tapped() {
            navigateToLevel(level: "L3")
        }
    
    func configureLevelVisibility(isla: String) {
        if isla == "I1" || isla == "I92" || isla == "I5" || isla == "I6" {
            btnLevel3.isHidden = true
        }
    }
    @objc func backButtonTapped() {
        if let navigationController = self.navigationController {
            // This will pop the current view controller from the navigation stack
            navigationController.popViewController(animated: true)
        } else {
            // Fallback: Present MapController manually if not embedded in a navigation controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let mapaVC = storyboard.instantiateViewController(withIdentifier: "MapController") as? MapController {
                self.present(mapaVC, animated: true, completion: nil)
            }
        }
    }
    func navigateToLevel(level: String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let firstIslandVC = storyboard.instantiateViewController(withIdentifier: "FirstIslandViewController") as? FirstIslandController {
            firstIslandVC.isla = self.isla
            firstIslandVC.base = self.base
            firstIslandVC.baseP = self.baseP
            firstIslandVC.level = self.level
            self.present(firstIslandVC, animated: true, completion: nil)
        }
    }
    func getData() {
        if let user = mAuth.currentUser {
            let userId = user.uid
            db.collection("Usuario").document(userId).addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Listen failed: \(error)")
                    return
                }
                if let snapshot = snapshot, snapshot.exists {
                    if let coinsValue = snapshot.get("monedas") as? NSNumber {
                        self.coinsLbl.text = coinsValue.stringValue
                    } else {
                        print("The value of 'monedas' is not numeric")
                    }
                } else {
                    print("No current data (snapshot is null or does not exist)")
                }
            }
        }
    }
}

