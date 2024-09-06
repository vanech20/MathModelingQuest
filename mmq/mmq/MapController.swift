//
//  MapController.swift
//  mmq
//
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseAuth

class MapController: UIViewController {
    
    @IBOutlet weak var isla1: UIButton!
    @IBOutlet weak var isla2: UIButton!
    @IBOutlet weak var isla3: UIButton!
    @IBOutlet weak var isla4: UIButton!
    @IBOutlet weak var isla5: UIButton!
    @IBOutlet weak var isla6: UIButton!
    @IBOutlet weak var isla7: UIButton!
    @IBOutlet weak var isla8: UIButton!
    @IBOutlet weak var isla9: UIButton!
    @IBOutlet weak var isla10: UIButton!
    
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var avatarBtn: UIButton!
    @IBOutlet weak var tiendaBtn: UIButton!
    
    @IBOutlet weak var coffeeLbl: UILabel!
    @IBOutlet weak var eraserLbl: UILabel!
    @IBOutlet weak var candyLbl: UILabel!
    @IBOutlet weak var coinsLbl: UILabel!
    
    @IBOutlet weak var isla82: UIButton!
    @IBOutlet weak var isla83: UIButton!
    @IBOutlet weak var isla92: UIButton!
    @IBOutlet weak var isla102: UIButton!
    
    @IBOutlet weak var extraLevelsBtn: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    var db: Firestore!
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        auth = Auth.auth()
        setupUI()
        loadData()

        // Add gesture recognizer to the profile image
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGesture)
    }
    
    private func setupUI() {
            tiendaBtn.addTarget(self, action: #selector(tiendaBtnTapped), for: .touchUpInside)
            avatarBtn.addTarget(self, action: #selector(avatarBtnTapped), for: .touchUpInside)
        let islandButtons = [isla1, isla2, isla3, isla4, isla5, isla6, isla7, isla8, isla9, isla10]
                for button in islandButtons {
                    button?.addTarget(self, action: #selector(islandButtonTapped(_:)), for: .touchUpInside)
                }
                
                extraLevelsBtn.addTarget(self, action: #selector(toggleExtraLevels), for: .touchUpInside)
        // Ocultar los botones de niveles extra al inicio
                let extraIslands = [isla82, isla83, isla92, isla102]
                extraIslands.forEach { $0?.isHidden = true }
        }

        @objc private func tiendaBtnTapped() {
            performSegue(withIdentifier: "tiendaSegue", sender: self)
        }

        @objc private func avatarBtnTapped() {
            performSegue(withIdentifier: "AvatarSegue", sender: self)
        }

        @objc private func profileImageTapped() {
            performSegue(withIdentifier: "ProfileSegue", sender: self)
        }
    
        @objc private func islandButtonTapped(_ sender: UIButton) {
            let islandIdentifiers = [
                isla1: ("I1", "UsuarioPrimera", "Primera"),
                isla2: ("I2", "UsuarioSegunda", "Segunda"),
                isla3: ("I3", "UsuarioTercera", "Tercera"),
                isla4: ("I4", "UsuarioCuarta", "Cuarta"),
                isla5: ("I5", "UsuarioQuinta", "Quinta"),
                isla6: ("I6", "UsuarioSexta", "Sexta"),
                isla7: ("I7", "UsuarioSeptima", "Septima"),
                isla8: ("I81", "UsuarioOctava", "Octava1"),
                isla9: ("I91", "UsuarioNovena", "Novena1"),
                isla10: ("I101", "UsuarioDecima", "Decima1"),
                isla82: ("I82", "UsuarioOctava", "Octava2"),
                isla83: ("I83", "UsuarioOctava", "Octava3"),
                isla92: ("I92", "UsuarioNovena", "Novena2"),
                isla102: ("I102", "UsuarioDecima", "Decima2")
            ]
            if let (isla, base, baseP) = islandIdentifiers[sender] {
                print("Navigating to \(isla) with base: \(base), baseP: \(baseP)")
                performSegue(withIdentifier: "LevelsSegue", sender: (isla, base, baseP))
            } else {
                    print("Error: Island not found")
            }
        }
    @objc private func toggleExtraLevels(){
        let extraIslands = [isla82, isla83, isla92, isla102]
        extraIslands.forEach { $0?.isHidden.toggle() }
        
        let regularIslands = [isla1, isla2, isla3, isla4, isla5, isla6, isla7, isla8, isla9, isla10]
        regularIslands.forEach { $0?.isHidden.toggle() }
        
        let title = extraIslands.first??.isHidden == true ? "Niveles Extra" : "Volver"
        extraLevelsBtn.setTitle(title, for: .normal)
    }
    
    private func loadData() {
        guard let user = auth.currentUser else { return }
        db.collection("Usuario").document(user.uid).addSnapshotListener {
            [weak self] snapshot, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching data: \(error)")
                return
            }
            guard let data = snapshot?.data() else {
                print("No data found")
                return
            }
            
            if let coins = data["monedas"] as? Int {
                self.coinsLbl.text = "\(coins)"
            }
            if let c1 = data["c1"] as? Int {
                self.coffeeLbl.text = "\(c1)"
            }
            if let c2 = data["c2"] as? Int {
                self.eraserLbl.text = "\(c2)"
            }
            if let c3 = data["c3"] as? Int {
                self.candyLbl.text = "\(c3)"
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "LevelsSegue" {
            print("Preparing for segue to LevelsViewController")
            if let destinationVC = segue.destination as? LevelsViewController,
               let (isla, base, baseP) = sender as? (String, String, String) {
                print("Passing data: isla=\(isla), base=\(base), baseP=\(baseP)")
                destinationVC.isla = isla
                destinationVC.base = base
                destinationVC.baseP = baseP
            } else {
                        print("Error: Data not in expected format")
            }
        } else if segue.identifier == "ProfileSegue" {
                print("Preparing for segue to ProfileViewController")
        } else {
            print("Unexpected segue: \(segue.identifier ?? "nil")")
        }
    }
}
