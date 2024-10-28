//
//  AvatarController.swift
//  mmq
//
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class AvatarController: UIViewController {
    
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var btnAvatar: UIButton!
    @IBOutlet weak var btnShop: UIButton!
    @IBOutlet weak var btnEdit: UIButton!
    
    @IBOutlet weak var actualHead: UIImageView!
    @IBOutlet weak var actualFace: UIImageView!
    @IBOutlet weak var actualFeet: UIImageView!
    @IBOutlet weak var actualNeck: UIImageView!
    
    var db: Firestore!
    var mAuth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        // Enable Firestore cache
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        
        mAuth = Auth.auth()
        
        // Check the current user
        if let user = mAuth.currentUser {
            let userId = user.uid
            print("User ID: \(userId)")
        } else {
            print("User not authenticated")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sesionVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
            self.present(sesionVC, animated: true, completion: nil)
            return
        }
        
        // Button actions
        btnEdit.addTarget(self, action: #selector(editAvatar), for: .touchUpInside)
        btnMap.addTarget(self, action: #selector(goToMap), for: .touchUpInside)
        btnShop.addTarget(self, action: #selector(goToShop), for: .touchUpInside)
        
        verificarVestimenta()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh the avatar images when the view appears
        verificarVestimenta()
    }
    
    @objc func editAvatar() {
            performSegue(withIdentifier: "EditSegue", sender: self)
        }
        
        @objc func goToMap() {
            performSegue(withIdentifier: "MapSegue", sender: self)
        }
        
        @objc func goToShop() {
            performSegue(withIdentifier: "ShopSegue", sender: self)
        }
    
    func verificarVestimenta() {
        guard let user = mAuth.currentUser else { return }
        let userId = user.uid
        let userDocRef = db.collection("UsuarioAvatar").document(userId)
        
        // Use snapshot listener to listen for real-time updates
        userDocRef.addSnapshotListener { document, error in
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
            
            if let document = document, document.exists, let userData = document.data() {
                let actualFace = userData["actualFace"] as? String
                let actualFeet = userData["actualFeet"] as? String
                let actualHead = userData["actualHead"] as? String
                let actualNeck = userData["actualNeck"] as? String
                
                self.setImageViewResource(imageName: actualFace, imageView: self.actualFace)
                self.setImageViewResource(imageName: actualFeet, imageView: self.actualFeet)
                self.setImageViewResource(imageName: actualHead, imageView: self.actualHead)
                self.setImageViewResource(imageName: actualNeck, imageView: self.actualNeck)
            } else {
                print("Document does not exist")
            }
        }
    }
        
    func setImageViewResource(imageName: String?, imageView: UIImageView) {
        if let imageName = imageName {
            if let image = UIImage(named: imageName) {
                imageView.image = image
            } else {
                print("Resource not found for: \(imageName)")
            }
        } else {
            print("Image name is nil")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMapSegue" {
            // Pass data to MapaViewController if needed
            if let destinationVC = segue.destination as? MapController {
                // destinationVC.someProperty = someValue
            }
        } else if segue.identifier == "goToShopSegue" {
            // Pass data to TiendaViewController if needed
            if let destinationVC = segue.destination as? StoreController {
                // destinationVC.someProperty = someValue
            }
        } else if segue.identifier == "editAvatarSegue" {
            // Pass data to EditarViewController if needed
            if let destinationVC = segue.destination as? EditController {
                // destinationVC.someProperty = someValue
            }
        }
    }
}
