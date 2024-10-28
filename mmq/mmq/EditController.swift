//
//  EditController.swift
//  mmq
//
//  Created by Desarrollo on 05/09/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class EditController: UIViewController {
    
    @IBOutlet weak var btnHat: UIImageView!
    @IBOutlet weak var btnGlasses: UIImageView!
    @IBOutlet weak var btnShirt: UIImageView!
    @IBOutlet weak var btnShoes: UIImageView!
    @IBOutlet weak var btnGuardar: UIButton!
    @IBOutlet weak var things: UIStackView!
    @IBOutlet weak var ActualFace: UIImageView!
    @IBOutlet weak var ActualNeck: UIImageView!
    @IBOutlet weak var ActualFeet: UIImageView!
    @IBOutlet weak var ActualHead: UIImageView!
    
    private let db = Firestore.firestore()
    private let mAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add tap gesture recognizers to UIImageViews
        let shirtTapGesture = UITapGestureRecognizer(target: self, action: #selector(onShirtTap))
        btnShirt.addGestureRecognizer(shirtTapGesture)
        btnShirt.isUserInteractionEnabled = true
        
        let shoesTapGesture = UITapGestureRecognizer(target: self, action: #selector(onShoesTap))
        btnShoes.addGestureRecognizer(shoesTapGesture)
        btnShoes.isUserInteractionEnabled = true
        
        let glassesTapGesture = UITapGestureRecognizer(target: self, action: #selector(onGlassesTap))
        btnGlasses.addGestureRecognizer(glassesTapGesture)
        btnGlasses.isUserInteractionEnabled = true
        
        let hatTapGesture = UITapGestureRecognizer(target: self, action: #selector(onHatTap))
        btnHat.addGestureRecognizer(hatTapGesture)
        btnHat.isUserInteractionEnabled = true
        
        btnGuardar.addTarget(self, action: #selector(onGuardarClick), for: .touchUpInside)
        
        verificarVestimenta()
        
        if let mainView = view {
            mainView.insetsLayoutMarginsFromSafeArea = true
        }
    }
    @objc func onShirtTap() {
        resetImageViewColors()
        btnShirt.backgroundColor = UIColor(named: "gris")
        loadAvatarItems(category: "neck", actualImageView: ActualNeck)
    }
    
    @objc func onShoesTap() {
        resetImageViewColors()
        btnShoes.backgroundColor = UIColor(named: "gris")
        loadAvatarItems(category: "feet", actualImageView: ActualFeet)
    }
    
    @objc func onGlassesTap(){
        resetImageViewColors()
        btnGlasses.backgroundColor = UIColor(named: "gris")
        loadAvatarItems(category: "face", actualImageView: ActualFace)
    }
    
    @objc func onHatTap(){
        resetImageViewColors()
        btnHat.backgroundColor = UIColor(named: "gris")
        loadAvatarItems(category: "head", actualImageView: ActualHead)
    }
    
    @objc func onGuardarClick() {
        guardarCambios()
        // Use popViewController if you're in a UINavigationController
        navigationController?.popViewController(animated: true)
        Toast.show("Avatar editado con Éxito", controller: self)
    }
    
    func loadAvatarItems(category: String, actualImageView: UIImageView) {
        guard let user = mAuth.currentUser else { return }
        let userId = user.uid
        db.collection("UsuarioAvatar").document(userId).getDocument { document, error in
            if let document = document, document.exists, let userData = document.data() {
                let itemNames = userData.keys.filter { key in
                    (userData[key] as? Bool ?? false) && key.starts(with: category)
                }
                self.loadDescriptionsAndCreateButtons(itemNames: Array(itemNames), actualImageView: actualImageView)
            } else {
                print("Document does not exist or failed to load.")
            }
        }
    }
    
    func loadDescriptionsAndCreateButtons(itemNames: [String], actualImageView: UIImageView) {
        things.subviews.forEach { $0.removeFromSuperview() }
        for itemName in itemNames {
            db.collection("Avatar").document(itemName).getDocument { document, error in
                if let document = document, document.exists, let description = document.get("descripcion") as? String {
                    let itemButton = UIButton(type: .system)
                    itemButton.setTitle(description, for: .normal)
                    itemButton.setTitleColor(.white, for: .normal)
                    itemButton.backgroundColor = UIColor(named: "buttonBackground")
                    itemButton.layer.cornerRadius = 8
                    itemButton.translatesAutoresizingMaskIntoConstraints = false
                    
                    itemButton.addAction(UIAction { [weak self] _ in
                        self?.setImageViewResource(imageName: itemName, imageView: actualImageView)
                    }, for: .touchUpInside)
                    
                    self.things.addArrangedSubview(itemButton)
                } else {
                    print("No document for item: \(itemName)")
                }
            }
        }
    }
    
    func verificarVestimenta() {
        guard let user = mAuth.currentUser else { return }
        let userId = user.uid
        db.collection("UsuarioAvatar").document(userId).getDocument { document, error in
            if let document = document, document.exists, let userData = document.data() {
                let actualFace = userData["actualFace"] as? String
                let actualFeet = userData["actualFeet"] as? String
                let actualHead = userData["actualHead"] as? String
                let actualNeck = userData["actualNeck"] as? String
                
                print("Actual Face: \(actualFace ?? "nil")")
                print("Actual Feet: \(actualFeet ?? "nil")")
                print("Actual Head: \(actualHead ?? "nil")")
                print("Actual Neck: \(actualNeck ?? "nil")")
                
                self.setImageViewResource(imageName: actualFace, imageView: self.ActualFace)
                self.setImageViewResource(imageName: actualFeet, imageView: self.ActualFeet)
                self.setImageViewResource(imageName: actualHead, imageView: self.ActualHead)
                self.setImageViewResource(imageName: actualNeck, imageView: self.ActualNeck)
            } else {
                print("Failed to load document or it doesn't exist.")
            }
        }
    }
    
    func setImageViewResource(imageName: String?, imageView: UIImageView) {
        guard let imageName = imageName, !imageName.isEmpty else {
            print("Error: Image name is nil or empty")
            return
        }
        
        if let image = UIImage(named: imageName) {
            imageView.image = image
            imageView.accessibilityIdentifier = imageName // Set the identifier here
        } else {
            print("Resource not found for: \(imageName)")
        }
    }
    
    func guardarCambios() {
        guard let user = mAuth.currentUser else { return }
        let userId = user.uid
        
        let actualFaceName = getResourceName(for: ActualFace)
        let actualFeetName = getResourceName(for: ActualFeet)
        let actualHeadName = getResourceName(for: ActualHead)
        let actualNeckName = getResourceName(for: ActualNeck)
        
        // Check if any image name is empty
        if actualFaceName.isEmpty || actualFeetName.isEmpty || actualHeadName.isEmpty || actualNeckName.isEmpty {
            print("Error: One or more image names are empty.")
            return
        }
        
        let updates: [String: Any] = [
            "actualFace": actualFaceName,
            "actualFeet": actualFeetName,
            "actualHead": actualHeadName,
            "actualNeck": actualNeckName
        ]
        
        db.collection("UsuarioAvatar").document(userId).updateData(updates) { error in
            if let error = error {
                print("Error updating data: \(error)")
            } else {
                print("Data successfully updated.")
            }
        }
    }
    
    func getResourceName(for imageView: UIImageView) -> String {
        return imageView.image?.accessibilityIdentifier ?? ""
    }
    
    func resetImageViewColors() {
        [btnHat, btnGlasses, btnShirt, btnShoes].forEach { $0?.backgroundColor = .white }
    }
    
}
