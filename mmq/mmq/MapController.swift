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
    @IBOutlet weak var coffeLbl: UILabel!
    @IBOutlet weak var eraserLbl: UILabel!
    @IBOutlet weak var candyLbl: UILabel!
    @IBOutlet weak var coinsLbl: UILabel!
    
    var db: Firestore!
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db = Firestore.firestore()
        auth = Auth.auth()
        setupUI()
        loadData()

    }
    
    private func setupUI() {
            tiendaBtn.addTarget(self, action: #selector(tiendaBtnTapped), for: .touchUpInside)
            avatarBtn.addTarget(self, action: #selector(avatarBtnTapped), for: .touchUpInside)
            isla1.addTarget(self, action: #selector(islandButtonTapped(_:)), for: .touchUpInside)
            isla2.addTarget(self, action: #selector(islandButtonTapped(_:)), for: .touchUpInside)
            isla3.addTarget(self, action: #selector(islandButtonTapped(_:)), for: .touchUpInside)
            isla4.addTarget(self, action: #selector(islandButtonTapped(_:)), for: .touchUpInside)
            isla5.addTarget(self, action: #selector(islandButtonTapped(_:)), for: .touchUpInside)
            isla6.addTarget(self, action: #selector(islandButtonTapped(_:)), for: .touchUpInside)
            isla7.addTarget(self, action: #selector(islandButtonTapped(_:)), for: .touchUpInside)
            isla8.addTarget(self, action: #selector(islandButtonTapped(_:)), for: .touchUpInside)
            isla9.addTarget(self, action: #selector(islandButtonTapped(_:)), for: .touchUpInside)
            isla10.addTarget(self, action: #selector(islandButtonTapped(_:)), for: .touchUpInside)
        }

        @objc private func tiendaBtnTapped() {
            performSegue(withIdentifier: "", sender: self)
        }

        @objc private func avatarBtnTapped() {
            performSegue(withIdentifier: "AvatarSegue", sender: self)
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
                isla10: ("I101", "UsuarioDecima", "Decima1")
            ]
            if let (isla, base, baseP) = islandIdentifiers[sender] {
                performSegue(withIdentifier: "LevelsSegue", sender: (isla, base, baseP))
            }
        }
    
    private func loadData() {
            guard let user = auth.currentUser else { return }
            db.collection("Usuario").document(user.uid).addSnapshotListener { [weak self] snapshot, error in
                if let error = error {
                    print("Error fetching data: \(error)")
                    return
                }

                guard let data = snapshot?.data() else {
                    print("No data found")
                    return
                }

                if let coins = data["monedas"] as? Int {
                    self?.coinsLbl.text = "\(coins)"
                }

                if let c1 = data["c1"] as? Int {
                    self?.coffeLbl.text = "\(c1)"
                }

                if let c2 = data["c2"] as? Int {
                    self?.eraserLbl.text = "\(c2)"
                }

                if let c3 = data["c3"] as? Int {
                    self?.candyLbl.text = "\(c3)"
                }
            }
        }

    //override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       // if segue.identifier == "LevelsSegue" {
         //   if let (isla, base, baseP) = sender as? (String, String, String) {
           //     if let destinationVC = segue.destination as? LevelsViewController {
             //       destinationVC.isla = isla
               //     destinationVC.base = base
                 //   destinationVC.baseP = baseP
         //       }
           // }
      //  }
   // }

}
