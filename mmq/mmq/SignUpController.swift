//
//  SignUpController.swift
//  mmq
//
//  Created by Desarrollo on 18/07/24.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpController: UIViewController{
    
    @IBOutlet weak var signUpName: UITextField!
    @IBOutlet weak var signUpLastName: UITextField!
    @IBOutlet weak var signUpMail: UITextField!
    @IBOutlet weak var signUpPass: UITextField!
    @IBOutlet weak var msgLbl: UILabel!
    
    var escapeF = false
    
    let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    let passwordPattern = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{8,}$"
    
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
    
    @IBAction func signUpBtn(_ sender: Any) {
        
        guard let nombre = signUpName.text, let apellidos = signUpLastName.text, let correo = signUpMail.text, let password = signUpPass.text
        else{
            displayWarning(message: "Por favor, completa todos los campos.")
            return
        }
        if correo.isEmpty || password.isEmpty || apellidos.isEmpty || nombre.isEmpty {
            displayWarning(message: "Por favor, completa todos los campos.")
            return
        }
        if !matchRegex(pattern: emailPattern, input: correo) {
            displayWarning(message: "Correo electrónico inválido.")
            return
        }
        
        if !matchRegex(pattern: passwordPattern, input: password) {
            displayWarning(message: "La contraseña debe tener al menos 8 caracteres, una letra mayúscula, una letra minúscula y un número.")
            return
        }
        let puntos = 0
        let monedas = 0
        let c1 = 0
        let c2 = 0
        let c3 = 0
        
        Auth.auth().createUser(withEmail: correo, password: password){ (result, error) in
            if let error = error as NSError? {
                if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                    self.displayWarning(message: "El correo electrónico ya está en uso")
                } else {
                    print("Error al registrar el usuario: \(error.localizedDescription)")
                }
                self.escapeF = true
            } else{
                print("Usuario registrado con éxito")
                
                if let id = result?.user.uid{
                    let userData: [String: Any] = [
                        "id": id,
                        "nombre": nombre,
                        "apellidos": apellidos,
                        "correo": correo,
                        "puntos": puntos,
                        "monedas": monedas,
                        "c1": c1,
                        "c2": c2,
                        "c3": c3
                    ]
                    let db = Firestore.firestore()
                    db.collection("Usuario").document(id).setData(userData) { error in
                        if let error = error {
                            print("Error al guardar los datos del usuario en Firestore:\(error.localizedDescription)")
                        } else {
                            print("Datos del usuario guardados en Firestore correctamente")
                        }
                        let alertController = UIAlertController(title: "Registro Completado", message: "El usuario fue registrado correctamente, ya puedes iniciar sesión", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "Iniciar Sesión", style: .default){ _ in
                            print("Botón OK presionado")
                            self.performSegue(withIdentifier: "postSignUp", sender: self)
                        }
                        alertController.addAction(okAction)
                        
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    func displayWarning(message: String){
        msgLbl.textColor = UIColor.red
        msgLbl.text = message
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
}
    
    

