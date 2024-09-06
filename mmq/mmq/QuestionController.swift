//
//  QuestionController.swift
//  mmq
//
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import AVFoundation

class QuestionController: UIViewController {
    
    @IBOutlet weak var questionImage: UIImageView!
    @IBOutlet weak var response1: UIImageView!
    @IBOutlet weak var response2: UIImageView!
    @IBOutlet weak var response3: UIImageView!
    @IBOutlet weak var response4: UIImageView!
    @IBOutlet weak var coinsLbl: UILabel!
    @IBOutlet weak var coffeeBtn: UIImageView!
    @IBOutlet weak var eraserBtn: UIImageView!
    @IBOutlet weak var candyBtn: UIImageView!
    @IBOutlet weak var coffeeLbl: UILabel!
    @IBOutlet weak var eraserLbl: UILabel!
    @IBOutlet weak var candyLbl: UILabel!
    @IBOutlet weak var categoriaLbl: UILabel!
    @IBOutlet weak var emotionsImage: UIImageView!
    
    var responseViews: [UIImageView] = []
    var correctText: String?
    var db: Firestore!
    var mAuth: Auth!
    var imgCorrect: String?
    var imgIncorrect: String?
    var c1: Double = 0.0
    var c2: Double = 0.0
    var c3: Double = 0.0
    var isla: String?
    var base: String?
    var baseP: String?
    var level: String?
    var question: String?
    var estado: String?
    
    var mediaPlayer: AVAudioPlayer?
    var incorrectMediaPlayer: AVAudioPlayer?
    var puntosPregunta: Double?
    var monedasPregunta: Double?
    var param1: String?
    var param2: String?
    var param3: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        mAuth = Auth.auth()
        
        // Initialize media players
        
        // Set up the views
        responseViews = [response1, response2, response3, response4]
        
        if let user = mAuth.currentUser{
            let userId = user.uid
            print("Usuario ID: \(userId)")
            
            let userDocRef = db.collection("Usuario").document(userId)
            userDocRef.getDocument{ (document, error) in
                if let document = document, document.exists {
                    self.c1 = document.get("c1") as? Double ?? 0.0
                    self.c2 = document.get("c2") as? Double ?? 0.0
                    self.c3 = document.get("c3") as? Double ?? 0.0
                    print("c1: \(self.c1), c2: \(self.c2), c3: \(self.c3)")
                } else {
                    print("El documento Usuario no existe")
                }
            }
        } else {
            print("Usuario no autenticado")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController")
            self.present(loginVC, animated: true, completion: nil)
        }
    }
}
