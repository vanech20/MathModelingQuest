//
//  SignUpController.swift
//  mmq
//
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
    
    let emailPattern = "^a\\d{8}@tec\\.mx$"
    let passwordPattern = "^(?=.*[A-Z])(?=.*[a-z])(?=.*\\d).{8,}$"
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
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
        /*if !matchRegex(pattern: emailPattern, input: correo) {
            displayWarning(message: "Correo institucional inválido")
            return
        }*/
        
        if !matchRegex(pattern: passwordPattern, input: password) {
            displayWarning(message: "La contraseña debe tener al menos 8 caracteres, una letra mayúscula, una letra minúscula y un número.")
            return
        }
        let puntos = 0
        let monedas = 100
        
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
                        "monedas": monedas
                    ]
                    let db = Firestore.firestore()
                    db.collection("Usuario").document(id).setData(userData) { error in
                        if let error = error {
                            print("Error al guardar los datos del usuario en Firestore:\(error.localizedDescription)")
                        } else {
                            print("Datos del usuario guardados en Firestore correctamente")
                        }
                        self.createUserAvatar(userId: id)
                        self.createUsuarioPrimera(userId: id)
                        self.createUsuarioSegunda(userId: id)
                        self.createUsuarioTercera(userId: id)
                        self.createUsuarioCuarta(userId: id)
                        self.createUsuarioQuinta(userId: id)
                        self.createUsuarioSexta(userId: id)
                        self.createUsuarioSeptima(userId: id)
                        self.createUsuarioOctava(userId: id)
                        self.createUsuarioNovena(userId: id)
                        self.createUsuarioDecima(userId: id)
                        self.createUsuarioOctava2(userId: id)
                        self.createUsuarioOctava3(userId: id)
                        self.createUsuarioNovena2(userId: id)
                        self.createUsuarioDecima2(userId: id)
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
    func createUserAvatar(userId: String) {
        let avatarMap: [String: Any] = [
            "actualFace": "",
            "actualFeet": "",
            "actualHead": "",
            "actualNeck": "",
            "face1": false,
            "face2": false,
            "face3": false,
            "face4": false,
            "feet1": false,
            "feet2": false,
            "feet3": false,
            "feet4": false,
            "head1": false,
            "head2": false,
            "head3": false,
            "neck1": false,
            "neck2": false,
            "neck3": false,
            "neck4": false
        ]
        let db = Firestore.firestore()
        db.collection("UsuarioAvatar").document(userId).setData(avatarMap) { error in
            if let error = error {
                print("Error al guardar avatar: \(error.localizedDescription)")
                self.displayWarning(message: "Error al guardar avatar: \(error.localizedDescription)")
            } else {
                print("Avatar guardado correctamente en Firestore")
            }
        }
    }
    func createUsuarioPrimera(userId: String) {
        let avatarMap: [String: Any] = [
            // Isla 1 nivel 1
            "R1I1L1": false,
            "R2I1L1": false,
            "R3I1L1": false,
            "R4I1L1": false,
            "R5I1L1": false,
            "R6I1L1": false,
            "R7I1L1": false,
            "R8I1L1": false,
            "R9I1L1": false,
            "R10I1L1": false,
            // Isla 1 nivel 2
            "R1I1L2": false,
            "R2I1L2": false,
            "R3I1L2": false,
            "R4I1L2": false,
            "R5I1L2": false,
            "R6I1L2": false,
            "R7I1L2": false,
            "R8I1L2": false,
            "R9I1L2": false,
            "R10I1L2": false
        ]
        let db = Firestore.firestore()
        db.collection("UsuarioPrimera").document(userId).setData(avatarMap) { error in
            if let error = error {
                print("Error al guardar primera: \(error.localizedDescription)")
                self.displayWarning(message: "Error al guardar primera: \(error.localizedDescription)")
            } else {
                print("Primera guardado correctamente en Firestore")
            }
        }
    }
    
    func createUsuarioSegunda(userId: String){
        let avatarMap: [String: Any] = [
            // Isla 2 nivel 1
            "R1I2L1": false,
            "R2I2L1": false,
            "R3I2L1": false,
            "R4I2L1": false,
            "R5I2L1": false,
            "R6I2L1": false,
            "R7I2L1": false,
            "R8I2L1": false,
            "R9I2L1": false,
            "R10I2L1": false,
            // Isla 2 nivel 2
            "R1I2L2": false,
            "R2I2L2": false,
            "R3I2L2": false,
            "R4I2L2": false,
            "R5I2L2": false,
            "R6I2L2": false,
            "R7I2L2": false,
            "R8I2L2": false,
            "R9I2L2": false,
            "R10I2L2": false,
            // Isla 2 nivel 3
            "R1I2L3": false,
            "R2I2L3": false,
            "R3I2L3": false,
            "R4I2L3": false,
            "R5I2L3": false,
            "R6I2L3": false,
            "R7I2L3": false,
            "R8I2L3": false,
            "R9I2L3": false,
            "R10I2L3": false
        ]
        let db = Firestore.firestore()
        db.collection("UsuarioSegunda").document(userId).setData(avatarMap) { error in
            if let error = error {
                print("Error al guardar segunda: \(error.localizedDescription)")
                self.displayWarning(message: "Error al guardar segunda: \(error.localizedDescription)")
            } else {
                print("Segunda guardado correctamente en Firestore")
            }
        }
    }
    
    func createUsuarioTercera(userId: String){
        let avatarMap: [String: Any] = [
            // Isla 3 nivel 1
            "R1I3L1": false,
            "R2I3L1": false,
            "R3I3L1": false,
            "R4I3L1": false,
            "R5I3L1": false,
            "R6I3L1": false,
            "R7I3L1": false,
            "R8I3L1": false,
            "R9I3L1": false,
            "R10I3L1": false,
            // Isla 3 nivel 2
            "R1I3L2": false,
            "R2I3L2": false,
            "R3I3L2": false,
            "R4I3L2": false,
            "R5I3L2": false,
            "R6I3L2": false,
            "R7I3L2": false,
            "R8I3L2": false,
            "R9I3L2": false,
            "R10I3L2": false,
            // Isla 3 nivel 3
            "R1I3L3": false,
            "R2I3L3": false,
            "R3I3L3": false,
            "R4I3L3": false,
            "R5I3L3": false,
            "R6I3L3": false,
            "R7I3L3": false,
            "R8I3L3": false,
            "R9I3L3": false,
            "R10I3L3": false
        ]
        let db = Firestore.firestore()
        db.collection("UsuarioTercera").document(userId).setData(avatarMap) { error in
            if let error = error {
                print("Error al guardar tercera: \(error.localizedDescription)")
                self.displayWarning(message: "Error al guardar tercera: \(error.localizedDescription)")
            } else {
                print("Tercera guardado correctamente en Firestore")
            }
        }
    }
    
    func createUsuarioCuarta(userId: String){
        let avatarMap: [String: Any] = [
            // Isla 4 nivel 1
            "R1I4L1": false,
            "R2I4L1": false,
            "R3I4L1": false,
            "R4I4L1": false,
            "R5I4L1": false,
            "R6I4L1": false,
            "R7I4L1": false,
            "R8I4L1": false,
            "R9I4L1": false,
            "R10I4L1": false,
            // Isla 4 nivel 2
            "R1I4L2": false,
            "R2I4L2": false,
            "R3I4L2": false,
            "R4I4L2": false,
            "R5I4L2": false,
            "R6I4L2": false,
            "R7I4L2": false,
            "R8I4L2": false,
            "R9I4L2": false,
            "R10I4L2": false,
            // Isla 4 nivel 3
            "R1I4L3": false,
            "R2I4L3": false,
            "R3I4L3": false,
            "R4I4L3": false,
            "R5I4L3": false,
            "R6I4L3": false,
            "R7I4L3": false,
            "R8I4L3": false,
            "R9I4L3": false,
            "R10I4L3": false
        ]
        let db = Firestore.firestore()
        db.collection("UsuarioCuarta").document(userId).setData(avatarMap) { error in
            if let error = error {
                print("Error al guardar cuarta: \(error.localizedDescription)")
                self.displayWarning(message: "Error al guardar cuarta: \(error.localizedDescription)")
            } else {
                print("Cuarta guardado correctamente en Firestore")
            }
        }
    }
    
    func createUsuarioQuinta(userId: String){
        let avatarMap: [String: Any] = [
            // Isla 5 nivel 1
            "R1I5L1": false,
            "R2I5L1": false,
            "R3I5L1": false,
            "R4I5L1": false,
            "R5I5L1": false,
            "R6I5L1": false,
            "R7I5L1": false,
            "R8I5L1": false,
            "R9I5L1": false,
            "R10I5L1": false,
            // Isla 5 nivel 2
            "R1I5L2": false,
            "R2I5L2": false,
            "R3I5L2": false,
            "R4I5L2": false,
            "R5I5L2": false,
            "R6I5L2": false,
            "R7I5L2": false,
            "R8I5L2": false,
            "R9I5L2": false,
            "R10I5L2": false,
            // Isla 5 nivel 3
            "R1I5L3": false,
            "R2I5L3": false,
            "R3I5L3": false,
            "R4I5L3": false,
            "R5I5L3": false,
            "R6I5L3": false,
            "R7I5L3": false,
            "R8I5L3": false,
            "R9I5L3": false,
            "R10I5L3": false
        ]
        let db = Firestore.firestore()
        db.collection("UsuarioQuinta").document(userId).setData(avatarMap) { error in
            if let error = error {
                print("Error al guardar quinta: \(error.localizedDescription)")
                self.displayWarning(message: "Error al guardar quinta: \(error.localizedDescription)")
            } else {
                print("Quinta guardado correctamente en Firestore")
            }
        }
    }
    
    func createUsuarioSexta(userId: String){
        let avatarMap: [String: Any] = [
            // Isla 6 nivel 1
            "R1I6L1": false,
            "R2I6L1": false,
            "R3I6L1": false,
            "R4I6L1": false,
            "R5I6L1": false,
            "R6I6L1": false,
            "R7I6L1": false,
            "R8I6L1": false,
            "R9I6L1": false,
            "R10I6L1": false,
            // Isla 6 nivel 2
            "R1I6L2": false,
            "R2I6L2": false,
            "R3I6L2": false,
            "R4I6L2": false,
            "R5I6L2": false,
            "R6I6L2": false,
            "R7I6L2": false,
            "R8I6L2": false,
            "R9I6L2": false,
            "R10I6L2": false,
            // Isla 6 nivel 3
            "R1I6L3": false,
            "R2I6L3": false,
            "R3I6L3": false,
            "R4I6L3": false,
            "R5I6L3": false,
            "R6I6L3": false,
            "R7I6L3": false,
            "R8I6L3": false,
            "R9I6L3": false,
            "R10I6L3": false
        ]
        let db = Firestore.firestore()
        db.collection("UsuarioSexta").document(userId).setData(avatarMap) { error in
            if let error = error {
                print("Error al guardar sexta: \(error.localizedDescription)")
                self.displayWarning(message: "Error al guardar sexta: \(error.localizedDescription)")
            } else {
                print("Sexta guardado correctamente en Firestore")
            }
        }
    }
    
    func createUsuarioSeptima(userId: String){
        let avatarMap: [String: Any] = [
            // Isla 7 nivel 1
            "R1I7L1": false,
            "R2I7L1": false,
            "R3I7L1": false,
            "R4I7L1": false,
            "R5I7L1": false,
            "R6I7L1": false,
            "R7I7L1": false,
            "R8I7L1": false,
            "R9I7L1": false,
            "R10I7L1": false,
            // Isla 7 nivel 2
            "R1I7L2": false,
            "R2I7L2": false,
            "R3I7L2": false,
            "R4I7L2": false,
            "R5I7L2": false,
            "R6I7L2": false,
            "R7I7L2": false,
            "R8I7L2": false,
            "R9I7L2": false,
            "R10I7L2": false,
            // Isla 7 nivel 3
            "R1I7L3": false,
            "R2I7L3": false,
            "R3I7L3": false,
            "R4I7L3": false,
            "R5I7L3": false,
            "R6I7L3": false,
            "R7I7L3": false,
            "R8I7L3": false,
            "R9I7L3": false,
            "R10I7L3": false
        ]
        let db = Firestore.firestore()
        db.collection("UsuarioSeptima").document(userId).setData(avatarMap) { error in
            if let error = error {
                print("Error al guardar septima: \(error.localizedDescription)")
                self.displayWarning(message: "Error al guardar septima: \(error.localizedDescription)")
            } else {
                print("Septima guardado correctamente en Firestore")
            }
        }
    }
    
    func createUsuarioOctava(userId: String) {
        let avatarMap: [String: Any] = [
            // Isla 8 nivel 1
            "R1I81L1": false,
            "R2I81L1": false,
            "R3I81L1": false,
            "R4I81L1": false,
            "R5I81L1": false,
            "R6I81L1": false,
            "R7I81L1": false,
            "R8I81L1": false,
            "R9I81L1": false,
            "R10I81L1": false,
            // Isla 8 nivel 2
            "R1I81L2": false,
            "R2I81L2": false,
            "R3I81L2": false,
            "R4I81L2": false,
            "R5I81L2": false,
            "R6I81L2": false,
            "R7I81L2": false,
            "R8I81L2": false,
            "R9I81L2": false,
            "R10I81L2": false,
            // Isla 8 nivel 3
            "R1I81L3": false,
            "R2I81L3": false,
            "R3I81L3": false,
            "R4I81L3": false,
            "R5I81L3": false,
            "R6I81L3": false,
            "R7I81L3": false,
            "R8I81L3": false,
            "R9I81L3": false,
            "R10I81L3": false
        ]

        let db = Firestore.firestore()
        db.collection("UsuarioOctava").document(userId).setData(avatarMap) { error in
            if let error = error {
                print("Error al guardar octava: \(error.localizedDescription)")
                self.displayWarning(message: "Error al guardar octava: \(error.localizedDescription)")
            } else {
                print("Octava guardado correctamente en Firestore")
                // Perform navigation to main screen or other actions upon success
            }
        }
    }

    func createUsuarioOctava2(userId: String) {
        let avatarMap: [String: Any] = [
            // Isla 82 nivel 1
            "R1I82L1": false,
            "R2I82L1": false,
            "R3I82L1": false,
            "R4I82L1": false,
            "R5I82L1": false,
            "R6I82L1": false,
            "R7I82L1": false,
            "R8I82L1": false,
            "R9I82L1": false,
            "R10I82L1": false,
            // Isla 82 nivel 2
            "R1I82L2": false,
            "R2I82L2": false,
            "R3I82L2": false,
            "R4I82L2": false,
            "R5I82L2": false,
            "R6I82L2": false,
            "R7I82L2": false,
            "R8I82L2": false,
            "R9I82L2": false,
            "R10I82L2": false,
            // Isla 82 nivel 3
            "R1I82L3": false,
            "R2I82L3": false,
            "R3I82L3": false,
            "R4I82L3": false,
            "R5I82L3": false,
            "R6I82L3": false,
            "R7I82L3": false,
            "R8I82L3": false,
            "R9I82L3": false,
            "R10I82L3": false
        ]

        let db = Firestore.firestore()
        db.collection("UsuarioOctava2").document(userId).setData(avatarMap) { error in
            if let error = error {
                print("Error al guardar octava 2: \(error.localizedDescription)")
                self.displayWarning(message: "Error al guardar octava 2: \(error.localizedDescription)")
            } else {
                print("Octava 2 guardado correctamente en Firestore")
                // Perform navigation to main screen or other actions upon success
            }
        }
    }

    func createUsuarioOctava3(userId: String) {
        let avatarMap: [String: Any] = [
            // Isla 83 nivel 1
            "R1I83L1": false,
            "R2I83L1": false,
            "R3I83L1": false,
            "R4I83L1": false,
            "R5I83L1": false,
            "R6I83L1": false,
            "R7I83L1": false,
            "R8I83L1": false,
            "R9I83L1": false,
            "R10I83L1": false,
            // Isla 83 nivel 2
            "R1I83L2": false,
            "R2I83L2": false,
            "R3I83L2": false,
            "R4I83L2": false,
            "R5I83L2": false,
            "R6I83L2": false,
            "R7I83L2": false,
            "R8I83L2": false,
            "R9I83L2": false,
            "R10I83L2": false,
            // Isla 83 nivel 3
            "R1I83L3": false,
            "R2I83L3": false,
            "R3I83L3": false,
            "R4I83L3": false,
            "R5I83L3": false,
            "R6I83L3": false,
            "R7I83L3": false,
            "R8I83L3": false,
            "R9I83L3": false,
            "R10I83L3": false
        ]

        let db = Firestore.firestore()
        db.collection("UsuarioOctava3").document(userId).setData(avatarMap) { error in
            if let error = error {
                print("Error al guardar octava 3: \(error.localizedDescription)")
                self.displayWarning(message: "Error al guardar octava 3: \(error.localizedDescription)")
            } else {
                print("Octava 3 guardado correctamente en Firestore")
                // Perform navigation to main screen or other actions upon success
            }
        }
    }
    
    // Crear documento en "UsuarioNovena"
    func createUsuarioNovena(userId: String) {
        let avatarMap: [String: Any] = [
            // Isla 9 nivel 1
            "R1I91L1": false,
            "R2I91L1": false,
            "R3I91L1": false,
            "R4I91L1": false,
            "R5I91L1": false,
            "R6I91L1": false,
            "R7I91L1": false,
            "R8I91L1": false,
            "R9I91L1": false,
            "R10I91L1": false,
            // Isla 9 nivel 2
            "R1I91L2": false,
            "R2I91L2": false,
            "R3I91L2": false,
            "R4I91L2": false,
            "R5I91L2": false,
            "R6I91L2": false,
            "R7I91L2": false,
            "R8I91L2": false,
            "R9I91L2": false,
            "R10I91L2": false,
            // Isla 9 nivel 3
            "R1I91L3": false,
            "R2I91L3": false,
            "R3I91L3": false,
            "R4I91L3": false,
            "R5I91L3": false,
            "R6I91L3": false,
            "R7I91L3": false,
            "R8I91L3": false,
            "R9I91L3": false,
            "R10I91L3": false
        ]

        let db = Firestore.firestore()
        db.collection("UsuarioNovena").document(userId).setData(avatarMap) { error in
            if let error = error {
                print("Error al guardar octava: \(error.localizedDescription)")
                self.displayWarning(message: "Error al guardar novena: \(error.localizedDescription)")
            } else {
                print("Novena guardado correctamente en Firestore")
                // Perform navigation to main screen or other actions upon success
            }
        }
    }

    func createUsuarioNovena2(userId: String) {
        let avatarMap: [String: Any] = [
            // Isla 92 nivel 1
            "R1I92L1": false,
            "R2I92L1": false,
            "R3I92L1": false,
            "R4I92L1": false,
            "R5I92L1": false,
            "R6I92L1": false,
            "R7I92L1": false,
            "R8I92L1": false,
            "R9I92L1": false,
            "R10I92L1": false,
            // Isla 82 nivel 2
            "R1I92L2": false,
            "R2I92L2": false,
            "R3I92L2": false,
            "R4I92L2": false,
            "R5I92L2": false,
            "R6I92L2": false,
            "R7I92L2": false,
            "R8I92L2": false,
            "R9I92L2": false,
            "R10I92L2": false,
            // Isla 82 nivel 3
            "R1I92L3": false,
            "R2I92L3": false,
            "R3I92L3": false,
            "R4I92L3": false,
            "R5I92L3": false,
            "R6I92L3": false,
            "R7I92L3": false,
            "R8I92L3": false,
            "R9I92L3": false,
            "R10I92L3": false
        ]

        let db = Firestore.firestore()
        db.collection("UsuarioNovena2").document(userId).setData(avatarMap) { error in
            if let error = error {
                print("Error al guardar novena 2: \(error.localizedDescription)")
                self.displayWarning(message: "Error al guardar octava 2: \(error.localizedDescription)")
            } else {
                print("Novena 2 guardado correctamente en Firestore")
                // Perform navigation to main screen or other actions upon success
            }
        }
    }

    func createUsuarioDecima(userId: String) {
        let avatarMap: [String: Any] = [
            // Isla 10 nivel 1
            "R1I101L1": false,
            "R2I101L1": false,
            "R3I101L1": false,
            "R4I101L1": false,
            "R5I101L1": false,
            "R6I101L1": false,
            "R7I101L1": false,
            "R8I101L1": false,
            "R9I101L1": false,
            "R10I101L1": false,
            // Isla 10 nivel 2
            "R1I101L2": false,
            "R2I101L2": false,
            "R3I101L2": false,
            "R4I101L2": false,
            "R5I101L2": false,
            "R6I101L2": false,
            "R7I101L2": false,
            "R8I101L2": false,
            "R9I101L2": false,
            "R10I101L2": false,
            // Isla 10 nivel 3
            "R1I101L3": false,
            "R2I101L3": false,
            "R3I101L3": false,
            "R4I101L3": false,
            "R5I101L3": false,
            "R6I101L3": false,
            "R7I101L3": false,
            "R8I101L3": false,
            "R9I101L3": false,
            "R10I101L3": false
        ]

        let db = Firestore.firestore()
        db.collection("UsuarioDecima").document(userId).setData(avatarMap) { error in
            if let error = error {
                print("Error al guardar decima: \(error.localizedDescription)")
                self.displayWarning(message: "Error al guardar decima: \(error.localizedDescription)")
            } else {
                print("Decima guardado correctamente en Firestore")
                // Perform navigation to main screen or other actions upon success
            }
        }
    }

    func createUsuarioDecima2(userId: String) {
        let avatarMap: [String: Any] = [
            // Isla 102 nivel 1
            "R1I102L1": false,
            "R2I102L1": false,
            "R3I102L1": false,
            "R4I102L1": false,
            "R5I102L1": false,
            "R6I102L1": false,
            "R7I102L1": false,
            "R8I102L1": false,
            "R9I102L1": false,
            "R10I102L1": false,
            // Isla 102 nivel 2
            "R1I102L2": false,
            "R2I102L2": false,
            "R3I102L2": false,
            "R4I102L2": false,
            "R5I102L2": false,
            "R6I102L2": false,
            "R7I102L2": false,
            "R8I102L2": false,
            "R9I102L2": false,
            "R10I102L2": false,
            // Isla 102 nivel 3
            "R1I102L3": false,
            "R2I102L3": false,
            "R3I102L3": false,
            "R4I102L3": false,
            "R5I102L3": false,
            "R6I102L3": false,
            "R7I102L3": false,
            "R8I102L3": false,
            "R9I102L3": false,
            "R10I102L3": false
        ]

        let db = Firestore.firestore()
        db.collection("UsuarioDecima2").document(userId).setData(avatarMap) { error in
            if let error = error {
                print("Error al guardar decima: \(error.localizedDescription)")
                self.displayWarning(message: "Error al guardar decima 2: \(error.localizedDescription)")
            } else {
                print("Decima 2 guardado correctamente en Firestore")
                // Perform navigation to main screen or other actions upon success
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
    
    

