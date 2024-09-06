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
    @IBOutlet weak var coffeeLbl: UILabel!
    @IBOutlet weak var eraserLbl: UILabel!
    @IBOutlet weak var candyLbl: UILabel!
    
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
        
        guard let user = mAuth.currentUser else {
            // Redirect to login screen if the user is not authenticated
            let loginVC = storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInController
            self.navigationController?.pushViewController(loginVC, animated: true)
            return
        }
        if let receivedIsla = isla, receivedIsla == "I1" {
            btnLevel3.isHidden = true
        }
        // Configurar OnClickListeners para los botones de nivel
        btnLevel1.addTarget(self, action: #selector(level1Tapped), for: .touchUpInside)
        btnLevel2.addTarget(self, action: #selector(level2Tapped), for: .touchUpInside)
        btnLevel3.addTarget(self, action: #selector(level3Tapped), for: .touchUpInside)
        
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "FirstIslandSegue",
               let destinationVC = segue.destination as? FirstIslandController {
                destinationVC.isla = isla
                destinationVC.base = base
                destinationVC.baseP = baseP
                destinationVC.level = level
            }
        }
    private func navigateToLevel(level: String) {
            self.level = level
            performSegue(withIdentifier: "FirstIslandSegue", sender: self)
        }
    private func getData() {
        guard let user = mAuth.currentUser else { return }
        let userId = user.uid
        db.collection("Usuario").document(userId)
            .addSnapshotListener { [weak self] (snapshot, error) in
                guard let self = self else { return }
                if let error = error {
                    print("Listen failed: \(error)")
                    return
                }
                
                if let snapshot = snapshot, snapshot.exists {
                    let data = snapshot.data()
                    self.coinsLbl.text = "\(data?["monedas"] as? Int ?? 0)"
                    self.coffeeLbl.text = "\(data?["c1"] as? Int ?? 0)"
                    self.eraserLbl.text = "\(data?["c2"] as? Int ?? 0)"
                    self.candyLbl.text = "\(data?["c3"] as? Int ?? 0)"
                } else {
                    print("No data found")
                }
            }
    }
}

