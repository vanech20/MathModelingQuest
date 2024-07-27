//
//  LogInController.swift
//  mmq
//
//  Created by Desarrollo on 23/07/24.
//

import UIKit
import Firebase

class LogInController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var warningLbl: UILabel!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pass: UITextField!
    
    let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func logInBtn(_ sender: Any) {
        guard let correo = email.text, let password = pass.text else {
            displayWarning(message: "Por favor, completa todos los campos")
            return
        }
        
        if correo.isEmpty || password.isEmpty {
            displayWarning(message: "Por favor, completa todos los campos")
            return
        }
        
        if !matchRegex(pattern: emailPattern, input: correo){
            displayWarning(message: "Correo electrónico inválido")
            return
        }
        
        Auth.auth().signIn(withEmail: correo, password: password){ [weak self] (user, error) in
            guard let self = self else { return }
            
            if let error = error {
                self.displayWarning(message: "Correo y/o contraseña incorrectos.")
                print("Error al iniciar sesiónA: \(error.localizedDescription)")
                return
            }
            
            print("Inicio de sesión exitoso.")
        }
    }
    
    func matchRegex(pattern: String, input: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let range = NSRange(location: 0, length: input.utf16.count)
            return regex.firstMatch(in: input, options: [], range: range) != nil
        } catch {
            print("Error al compilar la expresión regular: \(error.localizedDescription)")
            return false
        }
    }
    
    func displayWarning(message: String){
        warningLbl.textColor = UIColor.red
        warningLbl.text = message
    }

}
