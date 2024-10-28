import UIKit
import FirebaseAuth
import FirebaseFirestore

class FirstIslandController: UIViewController {
    
    @IBOutlet weak var coins: UILabel!
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
    var buttonToImageViewMap: [String: UIImageView] = [:]
    
    var isla: String?
    var base: String?
    var baseP: String?
    var level: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        // Firebase initialization
        //        db = Firestore.firestore()
        //        mAuth = Auth.auth()
        //
        //        // Recuperar parámetros del segue
        //        if let isla = UserDefaults.standard.string(forKey: "isla") {
        //            self.isla = isla
        //        }
        //        if let base = UserDefaults.standard.string(forKey: "base") {
        //            self.base = base
        //        }
        //        if let baseP = UserDefaults.standard.string(forKey: "baseP") {
        //            self.baseP = baseP
        //        }
        //        if let nivel = UserDefaults.standard.string(forKey: "nivel") {
        //            self.level = nivel
        //        }
        //
        //        // Asociar botones a sus ImageViews
        //        initializeButtonToImageViewMap()
        //        verificarAvance()
        //        getData()
        //        setBackground(nivel: )
        //
        //
        //        // Asignar acciones a las preguntas
        //        pregunta1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(questionTapped(_:))))
        //        pregunta2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(questionTapped(_:))))
        //        pregunta3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(questionTapped(_:))))
        //        pregunta4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(questionTapped(_:))))
        //        pregunta5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(questionTapped(_:))))
        //        pregunta6.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(questionTapped(_:))))
        //        pregunta7.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(questionTapped(_:))))
        //        pregunta8.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(questionTapped(_:))))
        //        pregunta9.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(questionTapped(_:))))
        //        pregunta10.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(questionTapped(_:))))
        //    }
        //    @objc func questionTapped(_ sender: UITapGestureRecognizer) {
        //        guard let imageView = sender.view as? UIImageView else { return }
        //        let preguntaID = buttonToImageViewMap.first(where: { $0.value == imageView })?.key ?? ""
        //
        //        let intentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionController
        //        intentVC.isla = baseP! + nivel
        //        intentVC.question = preguntaID
        //        intentVC.estado = base
        //        self.present(intentVC, animated: true, completion: nil)
        //    }
        //
        //    func initializeButtonToImageViewMap() {
        //        buttonToImageViewMap["R1\(isla)\(nivel)"] = pregunta1
        //        buttonToImageViewMap["R2\(isla)\(nivel)"] = pregunta2
        //        buttonToImageViewMap["R3\(isla)\(nivel)"] = pregunta3
        //        buttonToImageViewMap["R4\(isla)\(nivel)"] = pregunta4
        //        buttonToImageViewMap["R5\(isla)\(nivel)"] = pregunta5
        //        buttonToImageViewMap["R6\(isla)\(nivel)"] = pregunta6
        //        buttonToImageViewMap["R7\(isla)\(nivel)"] = pregunta7
        //        buttonToImageViewMap["R8\(isla)\(nivel)"] = pregunta8
        //        buttonToImageViewMap["R9\(isla)\(nivel)"] = pregunta9
        //        buttonToImageViewMap["R10\(isla)\(nivel)"] = pregunta10
        //    }
        //
        //    func verificarAvance() {
        //        guard let user = mAuth.currentUser else {
        //            self.performSegue(withIdentifier: "toSesion", sender: self)
        //            return
        //        }
        //
        //        let userId = user.uid
        //        db.collection(base!).document(userId).addSnapshotListener { (documentSnapshot, error) in
        //            guard let document = documentSnapshot, document.exists, let data = document.data() else {
        //                print("Documento no encontrado o error de conexión: \(error?.localizedDescription ?? "Desconocido")")
        //                return
        //            }
        //            self.actualizarEstadoBotones(userData: data)
        //        }
        //    }
        //
        //    func actualizarEstadoBotones(userData: [String: Any]) {
        //        var estadoAnterior = true // Inicia como habilitado para la primera pregunta
        //
        //        for i in 1...10 {
        //            let preguntaKey = "R\(i)\(isla)\(nivel)"
        //            if let pregunta = buttonToImageViewMap[preguntaKey] {
        //                let estado = userData[preguntaKey] as? Bool ?? false
        //                pregunta.isUserInteractionEnabled = estadoAnterior
        //                estadoAnterior = estado
        //            }
        //        }
        //    }
        //
        //    func getData() {
        //        guard let user = mAuth.currentUser else { return }
        //        let userId = user.uid
        //        db.collection("Usuario").document(userId).addSnapshotListener { (snapshot, error) in
        //            guard let snapshot = snapshot, snapshot.exists else {
        //                print("No se encontró el documento: \(error?.localizedDescription ?? "Desconocido")")
        //                return
        //            }
        //            if let coinsValue = snapshot.get("monedas") as? Int {
        //                self.coins.text = "\(coinsValue)"
        //            } else {
        //                print("El campo 'monedas' no es un valor numérico")
        //            }
        //        }
        //    }
        
        //    func setBackground(nivel: String) {
        //        switch nivel {
        //        case "L1":
        //            mainView.backgroundColor = UIColor(patternImage: UIImage(named: "backl1")!)
        //        case "L2":
        //            mainView.backgroundColor = UIColor(patternImage: UIImage(named: "backl2")!)
        //        default:
        //            mainView.backgroundColor = UIColor(patternImage: UIImage(named: "backl3")!)
        //        }
        //    }
    }
    
}
