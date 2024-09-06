//
//  FirstIslandController.swift
//  mmq
//
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class FirstIslandController: UIViewController {
    
    @IBOutlet weak var coinsLbl: UILabel!
    @IBOutlet weak var coffeeLbl: UILabel!
    @IBOutlet weak var eraserLbl: UILabel!
    @IBOutlet weak var candyLbl: UILabel!
    @IBOutlet weak var pregunta1: UIImageView!
    @IBOutlet weak var pregunta2: UIImageView!
    @IBOutlet weak var pregunta3: UIImageView!
    @IBOutlet weak var pregunta4: UIImageView!
    @IBOutlet weak var pregunta5: UIImageView!
    @IBOutlet weak var pregunta6: UIImageView!
    @IBOutlet weak var pregunta7: UIImageView!
    @IBOutlet weak var pregunta8: UIImageView!
    @IBOutlet weak var pregunta9: UIImageView!
    @IBOutlet weak var pregunta10: UIImageView!
    
    var db: Firestore!
    var mAuth: Auth!
    var buttonToImageViewMap = [String: UIImageView]()
    
    var isla: String?
    var base: String?
    var baseP: String?
    var level: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mAuth = Auth.auth()
        db = Firestore.firestore()
        
        if let user = mAuth.currentUser {
            let userId = user.uid
            print("Usuario ID: \(userId)")
        } else {
            print("Usuario no autenticado")
            let sesionVC = storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInController
            navigationController?.pushViewController(sesionVC, animated: true)
            return
        }
        if let intent = navigationController?.viewControllers.last as? QuestionController {
            isla = intent.isla
            base = intent.base
            baseP = intent.baseP
            level = intent.level
        }
        initializeButtonToImageViewMap()
        
        pregunta1.isUserInteractionEnabled = true
        pregunta1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleQuestionTap(_:))))
        
        pregunta2.isUserInteractionEnabled = true
        pregunta2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleQuestionTap(_:))))
        
        pregunta3.isUserInteractionEnabled = true
        pregunta3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleQuestionTap(_:))))
        
        pregunta4.isUserInteractionEnabled = true
        pregunta4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleQuestionTap(_:))))
        
        pregunta5.isUserInteractionEnabled = true
        pregunta5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleQuestionTap(_:))))
        
        pregunta6.isUserInteractionEnabled = true
        pregunta6.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleQuestionTap(_:))))
        
        pregunta7.isUserInteractionEnabled = true
        pregunta7.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleQuestionTap(_:))))
        
        pregunta8.isUserInteractionEnabled = true
        pregunta8.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleQuestionTap(_:))))
        
        pregunta9.isUserInteractionEnabled = true
        pregunta9.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleQuestionTap(_:))))
        
        pregunta10.isUserInteractionEnabled = true
        pregunta10.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleQuestionTap(_:))))
        
        verificarAvance()
        getData()
        print("LevelTag: \(level ?? "")")
    }
    @objc func handleQuestionTap(_ sender: UITapGestureRecognizer) {
            guard let questionTag = sender.view?.tag else { return }
            let intent = QuestionController()
            intent.isla = "\(baseP ?? "")\(level ?? "")"
            intent.question = "R\(questionTag)\(isla ?? "")\(level ?? "")"
            intent.estado = base
            navigationController?.pushViewController(intent, animated: true)
        }
    
    private func initializeButtonToImageViewMap() {
            buttonToImageViewMap["R1\(isla ?? "")\(level ?? "")"] = pregunta1
            buttonToImageViewMap["R2\(isla ?? "")\(level ?? "")"] = pregunta2
            buttonToImageViewMap["R3\(isla ?? "")\(level ?? "")"] = pregunta3
            buttonToImageViewMap["R4\(isla ?? "")\(level ?? "")"] = pregunta4
            buttonToImageViewMap["R5\(isla ?? "")\(level ?? "")"] = pregunta5
            buttonToImageViewMap["R6\(isla ?? "")\(level ?? "")"] = pregunta6
            buttonToImageViewMap["R7\(isla ?? "")\(level ?? "")"] = pregunta7
            buttonToImageViewMap["R8\(isla ?? "")\(level ?? "")"] = pregunta8
            buttonToImageViewMap["R9\(isla ?? "")\(level ?? "")"] = pregunta9
            buttonToImageViewMap["R10\(isla ?? "")\(level ?? "")"] = pregunta10
        }
    
    private func verificarAvance(){
        if let user = mAuth.currentUser{
            let userId = user.uid
            let userDocRef = db.collection(base ?? "").document(userId)
            
            userDocRef.addSnapshotListener{(documentSnapshot, error) in
                if let error = error {
                    print ("Error al obtener el documento: \(error)")
                    return
                }
                if let documentSnapshot = documentSnapshot, documentSnapshot.exists{
                    if let userData = documentSnapshot.data() {
                        self.actualizarEstadoBotones(userData)
                    }
                } else {
                    print("El documento no existe.")
                }
            }
        } else {
            print("Usuario no autenticado")
        }
    }
    
    private func actualizarEstadoBotones(_ userData: [String: Any]){
        var estadoAnterior = true
        for i in 1...10 {
            let questionKey = "R\(i)\(isla ?? "")\(level ?? "")"
            
            if let preguntaImageView = buttonToImageViewMap[questionKey]{
                if let estado = userData[questionKey] as? Bool {
                    preguntaImageView.isUserInteractionEnabled = estadoAnterior
                    estadoAnterior = estado
                } else {
                    preguntaImageView.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    private func getData(){
        if let user = mAuth.currentUser {
            let userId = user.uid
            db.collection("Usuario").document(userId).addSnapshotListener{ (snapshot, error) in
                if let error = error {
                    print("Listen failed: \(error)")
                    return
                }
                if let snapshot = snapshot, snapshot.exists{
                    let coinsValue = snapshot.data()?["monedas"] as? Int ?? 0
                    let c1Value = snapshot.data()?["c1"] as? Int ?? 0
                    let c2Value = snapshot.data()?["c2"] as? Int ?? 0
                    let c3Value = snapshot.data()?["c3"] as? Int ?? 0
                    
                    self.coinsLbl.text = "\(coinsValue)"
                    self.coffeeLbl.text = "\(c1Value)"
                    self.eraserLbl.text = "\(c2Value)"
                    self.candyLbl.text = "\(c3Value)"
                } else {
                    print("No hay datos actuales (snapshot es null o no existe)")
                }
            }
        }
    }
}
