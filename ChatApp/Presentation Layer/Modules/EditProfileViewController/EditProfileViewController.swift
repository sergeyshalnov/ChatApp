//
//  EditProfileViewController.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 18/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var informationTextView: UITextView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var profileImageButton: UIButton!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: - Custom placeholder
    
    private let textViewPlaceholder : UILabel = {
        let label = UILabel()
        label.text = "Enter information about yourself"
        
        label.font = UIFont.systemFont(ofSize: 17.0)
        label.sizeToFit()
        label.frame.origin = CGPoint(x: 0, y: 0)
        label.textColor = UIColor.lightGray
        
        return label
    }()
    
    // MARK: - Variables
    
    private var username: String? {
        didSet {
            usernameTextField.text = username
        }
    }
    
    private var information: String? {
        didSet {
            informationTextView.text = information
            textViewPlaceholder.isHidden = !informationTextView.text.isEmpty
        }
    }
    
    private var image: UIImage? {
        didSet {
            profileImageView.image = image ?? UIImage(named: "profileImage")
        }
    }
    
    
    // MARK: - Calculated variables
    
    private var isChange: Bool {
        get {
            return (informationTextView.text != information ?? "") ||
                   (usernameTextField.text != username ?? "") ||
                   (profileImageView.image != image)
        }
    }
    
    private var profile: ProfileData {
        get {
            let saveUsername: String? = usernameTextField.text != username ? usernameTextField.text ?? "" : nil
            let saveInformation: String? = informationTextView.text != information ? informationTextView.text ?? "" : nil
            let saveImage: UIImage? = profileImageView.image != image ? profileImageView.image : nil
            
            return ProfileData(username: saveUsername, information: saveInformation, image: saveImage)
        }
    }
    
    
    // MARK: - Assembly variables
    
    private var presentationAssembly: IPresentationAssembly?
    private var profileStorageService: IProfileStorageService?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    
    // MARK: - Setup Assembly
    
    func setupAssembly(presentationAssembly: IPresentationAssembly, profileStorageService: IProfileStorageService) {
        self.presentationAssembly = presentationAssembly
        self.profileStorageService = profileStorageService
    }
    
    
    // MARK: - Setup interface
    
    private func setup() {
        setupButtons()
        setupLayout()
        setupTextEdit()
        
        profileStorageService?.load { [weak self] profile in
            DispatchQueue.main.async {
                self?.username = profile?.username
                self?.information = profile?.information
                self?.image = profile?.image
            }
        }
        
        changeButtonState(enable: isChange, all: false)
        activityIndicator.hidesWhenStopped = true
    }
    
    private func setupTextEdit() {
        informationTextView.delegate = self
        informationTextView.textContainerInset = UIEdgeInsets.zero
        informationTextView.textContainer.lineFragmentPadding = 0
        informationTextView.addSubview(textViewPlaceholder)
    }
    
    private func setupButtons() {
        backButton.layer.cornerRadius = 10
        backButton.layer.borderWidth = 1
        
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderWidth = 1
        
        profileImageButton.backgroundColor = UIColor(red:0.25, green:0.47, blue:0.94, alpha:1.0)
    }
    
    private func setupLayout() {
        let buttonWidth = profileImageButton.bounds.size.width
        let edgeInsets = UIEdgeInsets(top: buttonWidth * 0.25, left: buttonWidth * 0.25,
                                      bottom: buttonWidth * 0.25, right: buttonWidth * 0.25)
        
        profileImageButton.layer.cornerRadius = buttonWidth / 2
        profileImageButton.imageEdgeInsets = edgeInsets
        profileImageButton.layer.masksToBounds = true
        
        profileImageView.layer.cornerRadius = buttonWidth / 2
        profileImageView.layer.masksToBounds = true
    }
    
    
    // MARK: - Buttons functions
    
    @IBAction func backButtonTouch(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func editProfileImageButtonTouch(_ sender: Any) {
        let alert = editImageAlert()
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func saveProfileButtonTouch(_ sender: Any) {
        saveProfile()
    }
    
    
    // MARK: - Private buttons functions
    
    private func changeButtonState(enable: Bool, all: Bool) {
        saveButton.isEnabled = enable
        
        backButton.isEnabled = all ? enable : backButton.isEnabled
        profileImageButton.isEnabled = all ? enable : profileImageButton.isEnabled
        
        saveButton.layer.borderColor = enable ? UIColor.black.cgColor : UIColor.lightGray.cgColor
        saveButton.setTitleColor(enable ? UIColor.black : UIColor.lightGray, for: .normal)
        
        
        if all {
            backButton.layer.borderColor = enable ? UIColor.black.cgColor : UIColor.lightGray.cgColor
            backButton.setTitleColor(enable ? UIColor.black : UIColor.lightGray, for: .normal)
        }
    }
    
    
    // MARK: - Save profile on button touch
    
    private func saveProfile() {
        activityIndicator.startAnimating()
        changeButtonState(enable: false, all: true)
        
        profileStorageService?.save(profile: profile) { [weak self] isSave in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                if isSave {
                    self?.username = self?.usernameTextField.text
                    self?.information = self?.informationTextView.text
                    self?.image = self?.profileImageView.image
                    
                    guard let isChange = self?.isChange else { return }
                    
                    self?.changeButtonState(enable: true, all: true)
                    self?.changeButtonState(enable: isChange, all: false)
                    
                    let alert = Alert.controller(type: .saveDone)
                    self?.present(alert, animated: true, completion: nil)
                    
                    print("Profile saved successfully")
                } else {
                    guard let alert = self?.reSaveProfileAlertController() else { return }
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    // MARK: - TextFiled change
    
    @IBAction func textFieldChange(_ sender: Any) {
        changeButtonState(enable: isChange, all: false)
    }

    
    // MARK: - Edit profile photo functions
    
    private func editImageAlert() -> UIAlertController {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let photoLibraryAction = UIAlertAction(title: "Photo library", style: .default) {
            [weak self] _ in self?.openPhotoLibrary()
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {
            [weak self] _ in self?.openCamera()
        }
        
        let pixabayPhotoLibrary = UIAlertAction(title: "Download", style: .default) {
            [weak self] _ in self?.openPixabayPhotoLibrary()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            alert.addAction(cameraAction)
        }
        
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            alert.addAction(photoLibraryAction)
        }
        
        alert.addAction(pixabayPhotoLibrary)
        alert.addAction(cancelAction)
        
        return alert
    }
    
    private func openCamera() {
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .fullScreen
            
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = Alert.controller(type: .cameraError)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func openPhotoLibrary() {
        if (UIImagePickerController.isSourceTypeAvailable(.photoLibrary)) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.modalPresentationStyle = .popover
            
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alert = Alert.controller(type: .libraryError, left: nil, right: nil)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func openPixabayPhotoLibrary() {
        guard let controller = presentationAssembly?.imagesViewController(imageDelegate: self) else { return }
        self.present(controller, animated: true, completion: nil)
    }

    
    // MARK: - Getting re-save profile AlertController
    
    private func reSaveProfileAlertController() -> UIAlertController {
       
        let left: (UIAlertAction) -> Void = {
            [weak self] UIAlertAction in
            
            guard let isChange = self?.isChange else { return }
            
            self?.changeButtonState(enable: true, all: true)
            self?.changeButtonState(enable: isChange, all: false)
        }
        
        let right: (UIAlertAction) -> Void = {
            [weak self] UIAlertAction in
            
            self?.saveProfile()
        }
        
        let alert = Alert.controller(type: Alert.Message.saveError, left: left, right: right)
        return alert
    }
}


// MARK: - ImageDelegate

extension EditProfileViewController: ImageDelegate {
    
    func setImage(image: UIImage?) {
        profileImageView.image = image
    }
    
}


// MARK: - TextViewDelegate

extension EditProfileViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        textViewPlaceholder.isHidden = !informationTextView.text.isEmpty
        changeButtonState(enable: isChange, all: false)
    }
}


// MARK: - ImagePickerControllerDelegate extension

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = (info[UIImagePickerControllerEditedImage] ?? info[UIImagePickerControllerOriginalImage]) as? UIImage {
            
            profileImageView.image = pickedImage
            changeButtonState(enable: isChange, all: false)
        } else {
            let alert = Alert.controller(type: .imageError)
            self.present(alert, animated: true, completion: nil)
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
