//
//  ProfileController.swift
//  mmq
//
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import SDWebImage


class ProfileController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var pointsLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var levelLbl: UILabel!
    @IBOutlet weak var btnEditPhoto: UIImageView!
    
    private var db: Firestore!
    private var mAuth: Auth!
    private var mStorage: StorageReference!
    private let imagePicker = UIImagePickerController()
    private let GALLERY_INTENT = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        mAuth = Auth.auth()
        mStorage = Storage.storage().reference()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = ["public.image"]
        
        if let user = mAuth.currentUser {
            let userId = user.uid
            print ("Usuario ID: \(userId)")
            getUserData()
        } else {
            print("Usuario no autenticado")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let sesionVC = storyboard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInController
            navigationController?.pushViewController(sesionVC, animated: true)
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editPhotoTapped))
        btnEditPhoto.isUserInteractionEnabled = true
        btnEditPhoto.addGestureRecognizer(tapGestureRecognizer)
        
        // For handling window insets (if required)
        if #available(iOS 13.0, *) {
            let mainView = view
            mainView?.directionalLayoutMargins = NSDirectionalEdgeInsets(
                top: view.safeAreaInsets.top,
                leading: view.safeAreaInsets.left,
                bottom: view.safeAreaInsets.bottom,
                trailing: view.safeAreaInsets.right
            )
        }
    }
    
    @objc func editPhotoTapped() {
            present(imagePicker, animated: true, completion: nil)
        }
    func getUserData(){
        if let user = mAuth.currentUser{
            let userId = user.uid
            db.collection("Usuario").document(userId).addSnapshotListener{ snapshot, error in
                if let error = error {
                    print("Listen failed: \(error)")
                    return
                }
                
                if let snapshot = snapshot, snapshot.exists {
                    let nombre = snapshot.get("nombre") as? String ?? ""
                    let pointsValue = snapshot.get("puntos") as? Int ?? 0
                    
                    self.userNameLbl.text = nombre
                    self.pointsLbl.text = "\(pointsValue)"
                    
                    let (level, title) = self.getLevelAndTitle(for : pointsValue)
                    self.levelLbl.text = level
                    self.titleLbl.text = title
                    
                    if let profileImageURL = snapshot.get("profileImageURL") as? String {
                        self.profileImageView.sd_setImage(with: URL(string: profileImageURL), completed: nil)
                        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width / 2
                        self .profileImageView.clipsToBounds = true
                    }
                } else {
                    print("Current data: null")
                }
            }
        }
    }
    
    func getLevelAndTitle(for points: Int) -> (String, String) {
        switch points {
        case 0...500:
            return ("1", "Principiante")
        case 501...1000:
            return ("2", "Aprendiz")
        case 1001...2000:
            return ("3", "Intermedio")
        case 2001...3500:
            return ("4", "Avanzado")
        case 3501...5000:
            return ("5", "Experto")
        case 5001...7000:
            return ("6", "Maestro")
        case 7001...9000:
            return ("7", "Gran Maestro")
        case 9001...12000:
            return ("8", "Sabio")
        case 12001...15000:
            return ("9", "Gurú de las Matemáticas")
        default:
            return ("10", "Leyenda Matemática")
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[.originalImage] as? UIImage, let user = mAuth.currentUser else {
            Toast.show("No se seleccionó ninguna imagen", controller: self)
            return
        }
        
        let progressDialog = ProgressDialog.show(in: self, title: "Subiendo...", message: "Subiendo foto de perfil")
        
        let userId = user.uid
        let filePath = mStorage.child("fotos").child(userId)
        
        // Eliminar la imagen existente
        filePath.delete { error in
            if error != nil {
                print("Error al eliminar la imagen anterior: \(error!.localizedDescription)")
            }
            
            // Subir la nueva imagen
            self.uploadNewImage(selectedImage, filePath: filePath, userId: userId, progressDialog: progressDialog)
        }
    }
    func uploadNewImage(_ image: UIImage, filePath: StorageReference, userId: String, progressDialog: ProgressDialog) {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { return }
        
        filePath.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                print("Error al subir la foto: \(error.localizedDescription)")
                Toast.show("Error al subir la foto", controller: self)
                progressDialog.dismiss()
                return
            }
            
            filePath.downloadURL { url, error in
                guard let downloadUrl = url?.absoluteString else {
                    print("Error al obtener la URL de descarga: \(error!.localizedDescription)")
                    Toast.show("Error al obtener la URL de descarga", controller: self)
                    progressDialog.dismiss()
                    return
                }
                
                self.db.collection("Usuario").document(userId).updateData(["profileImageUrl": downloadUrl]) { error in
                    if let error = error {
                        print("Error al guardar la URL: \(error.localizedDescription)")
                        Toast.show("Error al guardar la URL", controller: self)
                    } else {
                        self.profileImageView.sd_setImage(with: URL(string: downloadUrl), completed: nil)
                        Toast.show("Foto subida exitosamente", controller: self)
                    }
                    progressDialog.dismiss()
                }
            }
        }
    }
}
class ProgressDialog {
    private let alertController: UIAlertController

    private init(alertController: UIAlertController) {
        self.alertController = alertController
    }

    static func show(in viewController: UIViewController, title: String, message: String) -> ProgressDialog {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        viewController.present(alertController, animated: true, completion: nil)
        return ProgressDialog(alertController: alertController)
    }

    func dismiss() {
        alertController.dismiss(animated: true, completion: nil)
    }
}

class Toast {
    static func show(_ message: String, controller: UIViewController) {
        let toastLabel = UILabel(frame: CGRect(x: controller.view.frame.size.width/2 - 75, y: controller.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        controller.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}
