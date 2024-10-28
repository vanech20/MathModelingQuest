//
//  StoreController.swift
//  mmq
//
//  Created by Desarrollo on 05/09/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class StoreController: UIViewController {
    
    @IBOutlet weak var coins: UILabel!
    @IBOutlet weak var accesorios: UIScrollView!
    @IBOutlet weak var btnMap: UIButton!
    @IBOutlet weak var btnAvatar: UIButton!
    @IBOutlet weak var btnShop: UIButton!
    
    var db: Firestore!
    var mAuth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        setupUI()
        
        // Enable Firestore cache
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        db.settings = settings
        
        mAuth = Auth.auth()
        
        // Check the current user
        if let user = mAuth.currentUser {
            let userId = user.uid
            print("User ID: \(userId)")
            loadUserAvatarItems(userId: userId)
            getCoins() // Llama a getCoins solo si el usuario está autenticado
        } else {
            print("User not authenticated")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sesionVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
            self.present(sesionVC, animated: true, completion: nil)
            return
        }
        
        btnMap.addTarget(self, action: #selector(openMap), for: .touchUpInside)
        btnAvatar.addTarget(self, action: #selector(openAvatar), for: .touchUpInside)
    }
    
    func setupUI() {
        btnMap.backgroundColor = UIColor(named: "boton")
        btnAvatar.backgroundColor = UIColor(named: "boton")
        btnShop.backgroundColor = UIColor(named: "fondoBoton")
    }
        
    @objc func openMap() {
        let mapVC = storyboard?.instantiateViewController(withIdentifier: "MapViewController")
        navigationController?.pushViewController(mapVC!, animated: true)
    }
        
    @objc func openAvatar() {
        let avatarVC = storyboard?.instantiateViewController(withIdentifier: "AvatarViewController")
        navigationController?.pushViewController(avatarVC!, animated: true)
    }
        
    func getCoins() {
        guard let user = mAuth.currentUser else { return }
        db.collection("Usuario").document(user.uid).addSnapshotListener { [weak self] snapshot, error in
            if let error = error {
                print("Error al escuchar cambios en Firestore: \(error)")
                return
            }
            if let snapshot = snapshot, snapshot.exists {
                if let coinsValue = snapshot.get("monedas") as? NSNumber {
                    self?.coins.text = String(coinsValue.intValue)
                } else {
                    print("Valor de 'monedas' no es numérico")
                }
            } else {
                print("No hay datos actuales (snapshot es null o no existe)")
            }
        }
    }
        
    func loadUserAvatarItems(userId: String) {
        db.collection("UsuarioAvatar").document(userId).getDocument { [weak self] snapshot, error in
            if let document = snapshot, document.exists {
                if let avatarItems = document.data() as? [String: Bool] {
                    self?.createButtonsForAvatarItems(avatarItems)
                }
            } else {
                print("No existe tal documento en la colección UsuarioAvatar")
            }
        }
    }
        
    func createButtonForAvatarItem(itemName: String) {
        db.collection("Avatar").document(itemName).getDocument { [weak self] snapshot, error in
            guard let document = snapshot, document.exists else {
                print("No existe tal documento en la colección Avatar")
                return
            }
            
            if let price = document.get("precio") as? NSNumber {
                let imageButton = UIButton()
                let imageResource = UIImage(named: itemName)
                imageButton.setImage(imageResource, for: .normal)
                imageButton.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.7)
                imageButton.frame.size = CGSize(width: 50, height: 50)
                imageButton.addTarget(self, action: #selector(self?.showPurchaseDialog(_:)), for: .touchUpInside)
                
                if let scrollView = self?.accesorios {
                    scrollView.addSubview(imageButton)
                    
                    // Posición de los botones en el scroll
                    let buttonIndex = scrollView.subviews.count - 1
                    let xPosition = CGFloat(buttonIndex % 2) * (imageButton.frame.width + 10)
                    let yPosition = CGFloat(buttonIndex / 2) * (imageButton.frame.height + 10)
                    imageButton.frame.origin = CGPoint(x: xPosition, y: yPosition)
                    
                    scrollView.contentSize = CGSize(width: scrollView.frame.width, height: yPosition + imageButton.frame.height + 20)
                }
            }
        }
    }
        
    func createButtonsForAvatarItems(_ avatarItems: [String: Bool]) {
        for (itemName, unlocked) in avatarItems where !unlocked {
            createButtonForAvatarItem(itemName: itemName)
        }
    }
        
    @objc func showPurchaseDialog(_ sender: UIButton) {
        let alert = UIAlertController(title: "¿Quieres comprar esta prenda?", message: "Precio: \(coins.text ?? "0") monedas", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Comprar", style: .default) { _ in
            // Lógica de compra
        })
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        present(alert, animated: true)
    }
        
    func purchaseAvatarItem(itemName: String, price: Int) {
        guard let user = mAuth.currentUser else { return }
        
        db.collection("Usuario").document(user.uid).getDocument { [weak self] snapshot, error in
            if let document = snapshot, document.exists, let currentCoins = document.get("monedas") as? Int, currentCoins >= price {
                self?.db.collection("Usuario").document(user.uid).updateData(["monedas": currentCoins - price]) { error in
                    if error == nil {
                        self?.db.collection("UsuarioAvatar").document(user.uid).updateData([itemName: true]) { error in
                            if error == nil {
                                self?.getCoins()
                                print("Compra realizada con éxito")
                            }
                        }
                    } else {
                        print("Error al actualizar monedas: \(error?.localizedDescription ?? "")")
                    }
                }
            } else {
                print("No tienes suficientes monedas")
            }
        }
    }
}
