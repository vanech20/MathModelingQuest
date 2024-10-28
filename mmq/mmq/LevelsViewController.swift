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
    
    var mAuth = Auth.auth()
    var db = Firestore.firestore()
    var isla: String?
    var base: String?
    var baseP: String?
    var level: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Check if the user is authenticated
        guard let currentUser = mAuth.currentUser else {
            redirectToLogin()
            return
        }
        
        setupButtons()
        
        // Get passed parameters from previous view controller
        if let receivedIsla = self.isla, base != nil, baseP != nil {
            configureLevelVisibility(isla: receivedIsla)
        }
        
        getData(for: currentUser.uid)
    }
    
    private func setupButtons() {
        backBtn.target = self
        backBtn.action = #selector(backButtonTapped)
        
        btnLevel1.addTarget(self, action: #selector(level1Tapped), for: .touchUpInside)
        btnLevel2.addTarget(self, action: #selector(level2Tapped), for: .touchUpInside)
        btnLevel3.addTarget(self, action: #selector(level3Tapped), for: .touchUpInside)
    }
    
    private func redirectToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let loginVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as? LogInController {
            self.present(loginVC, animated: true, completion: nil)
        }
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
        if ["I1", "I92", "I5", "I6"].contains(isla) {
            btnLevel3.isHidden = true
        }
    }
    
    @objc func backButtonTapped() {
        if let navigationController = self.navigationController {
            navigationController.popViewController(animated: true)
        } else {
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
            firstIslandVC.level = level  // Pass the selected level here
            self.present(firstIslandVC, animated: true, completion: nil)
        }
    }
    
    func getData(for userId: String) {
        db.collection("Usuario").document(userId).addSnapshotListener { [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Listen failed: \(error)")
                return
            }
            if let snapshot = snapshot, snapshot.exists, let coinsValue = snapshot.get("monedas") as? NSNumber {
                self.coinsLbl.text = coinsValue.stringValue
            } else {
                print("No current data or 'monedas' is not numeric")
            }
        }
    }
}

