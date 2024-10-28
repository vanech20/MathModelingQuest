//
//  QuestionController.swift
//  mmq
//
//

import UIKit
import Firebase
import SDWebImage
import AVFoundation

class QuestionController: UIViewController {
    
    @IBOutlet weak var questionImage: UIImageView!
    @IBOutlet weak var response1: UIImageView!
    @IBOutlet weak var response2: UIImageView!
    @IBOutlet weak var response3: UIImageView!
    @IBOutlet weak var response4: UIImageView!
    @IBOutlet weak var coinsLbl: UILabel!
    @IBOutlet weak var categoriaLbl: UILabel!
    @IBOutlet weak var emotionsImage: UIImageView!
    
    var responseViews: [UIImageView] = []
    var correctText: String?
    var imgCorrect: String?
    var imgIncorrect: String?
    var isla: String?
    var base: String?
    var baseP: String?
    var level: String?
    var question: String?
    var estado: String?
    
    var mediaPlayer: AVAudioPlayer?
    var incorrectMediaPlayer: AVAudioPlayer?
    var puntosPregunta: Double = 0.0
    var monedasPregunta: Double = 0.0
    var param1: String?
    var param2: String?
    var param3: String?
    
    let db = Firestore.firestore()
    let mAuth = Auth.auth()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        initializeMediaPlayers()
        checkCurrentUser()
        fetchParams()
        setupEdgeToEdge()
        getData()
        getQuestion(param1: param1!, param2: param2!)
        getElements()
    }
    func setupViews() {
        responseViews = [response1, response2, response3, response4]
    }
    func initializeMediaPlayers() {
        if let correctSound = Bundle.main.url(forResource: "correct", withExtension: "mp3") {
            mediaPlayer = try? AVAudioPlayer(contentsOf: correctSound)
        }
        if let wrongSound = Bundle.main.url(forResource: "wrong", withExtension: "mp3") {
            incorrectMediaPlayer = try? AVAudioPlayer(contentsOf: wrongSound)
        }
    }
    func checkCurrentUser() {
        if let user = mAuth.currentUser {
            let userId = user.uid
            db.collection("Usuario").document(userId).getDocument { (document, error) in
                if let document = document, document.exists {
                    print("Usuario ID: \(userId)")
                } else {
                    print("Usuario no autenticado")
                    self.navigateToSesion()
                }
            }
        } else {
            print("Usuario no autenticado")
            navigateToSesion()
        }
    }
    func navigateToSesion() {
        // Assuming `SesionActivity` is your login screen.
        // You'll need to instantiate and navigate to it.
        let sesionVC = storyboard?.instantiateViewController(identifier: "LogInController") as! LogInController
        self.present(sesionVC, animated: true, completion: nil)
    }
    func fetchParams() {
        param1 = self.getParam(forKey: "isla")
        param2 = self.getParam(forKey: "pregunta")
        param3 = self.getParam(forKey: "estado")
        
        if let param1 = param1, let param2 = param2, let param3 = param3 {
            print("Params: \(param1), \(param2), \(param3)")
        } else {
            print("No se recibieron los parámetros esperados.")
        }
    }
    func getParam(forKey key: String) -> String? {
        return self.navigationController?.topViewController?.value(forKey: key) as? String
    }
    func setupEdgeToEdge() {
        if #available(iOS 13.0, *) {
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            windowScene?.windows.first?.overrideUserInterfaceStyle = .dark
        }
    }
    func getQuestion(param1: String, param2: String) {
        db.collection(param1).document(param2).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let value = snapshot?.data() {
                let questionText = value["pregunta"] as? String
                self.correctText = value["correcta"] as? String
                let incorrect1Text = value["incorrecta1"] as? String
                let incorrect2Text = value["incorrecta2"] as? String
                let incorrect3Text = value["incorrecta3"] as? String
                let video = value["link"] as? String
                self.puntosPregunta = value["puntos"] as? Double ?? 0.0
                
                var responses = [self.correctText, incorrect1Text, incorrect2Text, incorrect3Text].compactMap { $0 }
                responses.shuffle()
                
                self.questionImage.sd_setImage(with: URL(string: questionText ?? ""), completed: nil)
                self.loadImageIntoView(url: responses[0], imageView: self.response1)
                self.loadImageIntoView(url: responses[1], imageView: self.response2)
                self.loadImageIntoView(url: responses[2], imageView: self.response3)
                self.loadImageIntoView(url: responses[3], imageView: self.response4)
                
                self.setupResponseActions(correctAnswer: self.correctText, video: video)
            }
        }
    }
    func loadImageIntoView(url: String, imageView: UIImageView) {
        if let imageURL = URL(string: url) {
            imageView.sd_setImage(with: imageURL, completed: nil)
            imageView.tag = url.hash // Setting the tag as a unique identifier
        }
    }
    func setupResponseActions(correctAnswer: String?, video: String?) {
        let responseTap1 = UITapGestureRecognizer(target: self, action: #selector(handleResponse(_:)))
        response1.addGestureRecognizer(responseTap1)
        response1.isUserInteractionEnabled = true
        
        let responseTap2 = UITapGestureRecognizer(target: self, action: #selector(handleResponse(_:)))
        response2.addGestureRecognizer(responseTap2)
        response2.isUserInteractionEnabled = true
        
        let responseTap3 = UITapGestureRecognizer(target: self, action: #selector(handleResponse(_:)))
        response3.addGestureRecognizer(responseTap3)
        response3.isUserInteractionEnabled = true
        
        let responseTap4 = UITapGestureRecognizer(target: self, action: #selector(handleResponse(_:)))
        response4.addGestureRecognizer(responseTap4)
        response4.isUserInteractionEnabled = true
    }
    @objc func handleResponse(_ sender: UITapGestureRecognizer) {
        if let selectedView = sender.view as? UIImageView {
            let selectedAnswer = selectedView.tag.description
            if selectedAnswer == correctText {
                selectedView.layer.borderColor = UIColor.green.cgColor
                selectedView.layer.borderWidth = 2.0
                mediaPlayer?.play()
                updatePoints()
            } else {
                selectedView.layer.borderColor = UIColor.red.cgColor
                selectedView.layer.borderWidth = 2.0
                incorrectMediaPlayer?.play()
                showIncorrectAnswerDialog(correctText: correctText, video: nil)
            }
        }
    }
    func updatePoints() {
        if let user = mAuth.currentUser {
            let userId = user.uid
            let userDocRef = db.collection("Usuario").document(userId)
            userDocRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    var currentPoints = document.get("puntos") as? Double ?? 0.0
                    var currentCoins = document.get("monedas") as? Double ?? 0.0
                    
                    currentPoints += self.puntosPregunta
                    currentCoins += self.monedasPregunta
                    
                    userDocRef.updateData(["puntos": currentPoints, "monedas": currentCoins]) { error in
                        if let error = error {
                            print("Error updating points: \(error)")
                        } else {
                            print("Points updated successfully")
                        }
                    }
                }
            }
        }
    }
    func getData() {
        if let user = mAuth.currentUser {
            let userId = user.uid
            db.collection("Usuario").document(userId).addSnapshotListener { (snapshot, error) in
                if let error = error {
                    print("Firestore error: \(error)")
                    return
                }
                if let snapshot = snapshot {
                    let coinsValue = snapshot.get("monedas") as? Int ?? 0
                    self.coinsLbl.text = "\(coinsValue)"
                }
            }
        }
    } 
    func getElements() {
        db.collection("Elementos").document("elementos").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("Error fetching elements: \(error)")
                return
            }
            if let value = snapshot?.data() {
                self.imgCorrect = value["correct"] as? String
                self.imgIncorrect = value["incorrect"] as? String
            }
        }
    }
        
    func showIncorrectAnswerDialog(correctText: String?, video: String?) {
        let alert = UIAlertController(title: "Respuesta incorrecta", message: "Por favor, intenta nuevamente", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reintentar", style: .default, handler: { _ in
            self.resetResponses()
        }))
        present(alert, animated: true, completion: nil)
    }
        
    func resetResponses() {
        for response in responseViews {
            response.layer.borderColor = UIColor.clear.cgColor
            response.layer.borderWidth = 0.0
            response.isUserInteractionEnabled = true
        }
    }
}
