
import UIKit

class FurnitureDetailViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var furniture: Furniture?
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var choosePhotoButton: UIButton!
    @IBOutlet var furnitureTitleLabel: UILabel!
    @IBOutlet var furnitureDescriptionLabel: UILabel!
    
    init?(coder: NSCoder, furniture: Furniture?) {
        self.furniture = furniture
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView()
    }
    
    func updateView() {
        guard let furniture = furniture else {return}
        if let imageData = furniture.imageData,
            let image = UIImage(data: imageData) {
            photoImageView.image = image
        } else {
            photoImageView.image = nil
        }
        
        furnitureTitleLabel.text = furniture.name
        furnitureDescriptionLabel.text = furniture.description
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            photoImageView.image = image
            furniture?.imageData = image.jpegData(compressionQuality: 0.9)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choosePhotoButtonTapped(_ sender: Any) {
        //image picker controller
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        //alert controller
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        //creating alert actions
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let takePhotoAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            alert.addAction(takePhotoAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let choosePhotoAction = UIAlertAction(title: "Choose Photo", style: .default) { _ in
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            
            alert.addAction(choosePhotoAction)
        }
        
        present(alert, animated: true, completion: nil)
    }

    @IBAction func actionButtonTapped(_ sender: Any) {
        //initializing furniture
        guard let furniture = furniture else { return }
        
        //stores everything that we are going to share
        var itemsToShare: [Any] = []
        
        //stores the description so we share it
        itemsToShare.append(description)
        
        //gets the imageData, then appends to the items to share list so we cna share it
        if let imageData = furniture.imageData, let image = UIImage(data: imageData){
            itemsToShare.append(image)
        }
        
        //creating the UIActivityViewController, then animating it
        let activityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
        

        
    }
    
}
