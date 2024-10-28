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
    @IBOutlet weak var backBtn: UIBarButtonItem!
    
    private var db = Firestore.firestore()
    private var mAuth = Auth.auth()
    private var buttonToImageViewMap = [String: UIImageView]()
    
    var isla: String?
    var base: String?
    var baseP: String?
    var level: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up back button action
        backBtn.target = self
        backBtn.action = #selector(didTapBackButton)
        
        // Initialize button to ImageView mapping
        initializeButtonToImageViewMap()
        
        // Retrieve intent parameters
        if let params = navigationController?.viewControllers.first as? LevelsViewController {
            isla = params.isla
            base = params.base
            baseP = params.baseP
            level = params.level
        }
        
        // Check if user is authenticated
        if let user = mAuth.currentUser {
            print("User ID: \(user.uid)")
        } else {
            print("User not authenticated")
            let sesionVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MapViewController")
            self.present(sesionVC, animated: true, completion: nil)
            return
        }
        
        // Set up tap gestures for ImageViews
        setupTapGestures()
        
        verificarAvance()
        getData()
        setBackground(for: level)
    }
    
    @objc func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    private func setupTapGestures() {
        [pregunta1, pregunta2, pregunta3, pregunta4, pregunta5,
         pregunta6, pregunta7, pregunta8, pregunta9, pregunta10].enumerated().forEach { index, imageView in
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapPregunta(_:)))
            imageView?.isUserInteractionEnabled = true
            imageView?.tag = index + 1
            imageView?.addGestureRecognizer(tapGesture)
        }
    }
    
    @objc func didTapPregunta(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view else { return }
        let preguntaIndex = imageView.tag
        guard let baseP = baseP, let nivel = level, let isla = isla, let base = base else { return }
        
        let preguntaActivity = storyboard?.instantiateViewController(identifier: "QuestionViewController") as! QuestionController
        preguntaActivity.isla = baseP + nivel
        preguntaActivity.question = "R\(preguntaIndex)\(isla)\(nivel)"
        preguntaActivity.estado = base
        navigationController?.pushViewController(preguntaActivity, animated: true)
    }
    
    private func initializeButtonToImageViewMap() {
        guard let isla = isla, let nivel = level else { return }
        buttonToImageViewMap = [
            "R1\(isla)\(nivel)": pregunta1,
            "R2\(isla)\(nivel)": pregunta2,
            "R3\(isla)\(nivel)": pregunta3,
            "R4\(isla)\(nivel)": pregunta4,
            "R5\(isla)\(nivel)": pregunta5,
            "R6\(isla)\(nivel)": pregunta6,
            "R7\(isla)\(nivel)": pregunta7,
            "R8\(isla)\(nivel)": pregunta8,
            "R9\(isla)\(nivel)": pregunta9,
            "R10\(isla)\(nivel)": pregunta10
        ]
    }
    
    private func actualizarEstadoBotones(_ userData: [String: Any]) {
        var estadoAnterior = true
        for i in 1...10 {
            let preguntaKey = "R\(i)\(isla ?? "")\(level ?? "")"
            if let pregunta = buttonToImageViewMap[preguntaKey] {
                if let estado = userData[preguntaKey] as? Bool {
                    pregunta.isUserInteractionEnabled = estadoAnterior
                    estadoAnterior = estado
                } else {
                    pregunta.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    private func verificarAvance() {
        guard let user = mAuth.currentUser else {
            print("User not authenticated")
            return
        }
        
        db.collection(base ?? "").document(user.uid).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Error retrieving document: \(error)")
                return
            }
            guard let data = snapshot?.data() else {
                print("No document data available.")
                return
            }
            self.actualizarEstadoBotones(data)
            for (key, value) in data {
                if let estado = value as? Bool, estado, let imageView = self.buttonToImageViewMap[key] {
                    imageView.image = UIImage(named: "green")
                }
            }
        }
    }
    
    private func getData() {
        guard let user = mAuth.currentUser else { return }
        
        db.collection("Usuario").document(user.uid).addSnapshotListener { snapshot, error in
            if let error = error {
                print("Firestore error: \(error)")
                return
            }
            if let coinsValue = snapshot?.data()?["monedas"] as? Int {
                self.coins.text = "\(coinsValue)"
            }
        }
    }
    
    private func setBackground(for nivel: String?) {
        switch nivel {
        case "L1":
            view.backgroundColor = UIColor(patternImage: UIImage(named: "Back1")!)
        case "L2":
            view.backgroundColor = UIColor(patternImage: UIImage(named: "Back2")!)
        default:
            view.backgroundColor = UIColor(patternImage: UIImage(named: "Back3")!)
        }
    }
}
