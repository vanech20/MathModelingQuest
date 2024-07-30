//
//  StartController.swift
//  mmq
//
//

import UIKit
import FirebaseAuth

class StartController: UIViewController {
    
    private var mAuth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mAuth = Auth.auth()
    }
    
    @IBAction func playBtn(_ sender: Any) {
        
        performSegue(withIdentifier: "playSegue", sender: self)
        
    }
    
    @IBAction func exitBtn(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Cerrar Sesión", message: "¿Desea cerrar sesión?", preferredStyle: .alert)

           // Agregar acciones (botones) a la alerta
           let cancelAction = UIAlertAction(title: "No", style: .cancel) { _ in
               // Handle the cancel action if needed
           }
           alertController.addAction(cancelAction)
        
        let deleteAction = UIAlertAction(title: "Sí", style: .destructive) { [weak self] _ in
            let defaults = UserDefaults.standard
            if defaults.value(forKey: "uid") is String {
                UserDefaults.standard.removeObject(forKey: "uid")
                UserDefaults.standard.synchronize()
            }

            do {
                try Auth.auth().signOut()
                // Cierre de sesión exitoso
                self?.performSegue(withIdentifier: "exitSegue", sender: self)
            } catch let signOutError as NSError {
                print("Error al cerrar sesión: \(signOutError)")
                // Handle the sign-out error if needed
            }
        }
        alertController.addAction(deleteAction)

        present(alertController, animated: true, completion: nil)
    }
    
    
}
