//
//  ProfileViewController.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 21.09.2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var exitButton: UIButton!
  @IBOutlet weak var profileImageButton: UIButton!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var informationLabel: UILabel!
  @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
  
  // MARK: - Variables
  
  private var username: String? {
    didSet {
      let value = username == "" ? nil : username
      usernameLabel.text = value ?? "Enter your name"
    }
  }
  
  private var information: String? {
    didSet {
      let value = information == "" ? nil : information
      informationLabel.text = value ?? "Please enter some information about yourself"
    }
  }
  
  private var image: UIImage? {
    didSet {
      if oldValue == nil {
        self.profileImageView.image = self.image
      } else {
        UIView.transition(with: self.profileImageView, duration: 0.5, options: .transitionCrossDissolve, animations: {
          self.profileImageView.image = self.image ?? UIImage(named: "profileImage")
        }, completion: nil)
      }
    }
  }
  
  
  // MARK: - Assembly Variables
  
  private var presentationAssembly: IPresentationAssembly
  private var profileStorageService: IProfileStorageService
  
  
  // MARK: - Init
  
  init(presentationAssembly: IPresentationAssembly, profileStorageService: IProfileStorageService) {
    self.presentationAssembly = presentationAssembly
    self.profileStorageService = profileStorageService
    
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  
  // MARK: - LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    loadProfile()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    adaptiveLayout()
  }
  
  
  // MARK: - Setup Assembly
  
  func setupAssembly(presentationAssembly: IPresentationAssembly, profileStorageService: IProfileStorageService) {
    self.presentationAssembly = presentationAssembly
    self.profileStorageService = profileStorageService
  }
  
  
  // MARK: - Setup interface
  
  private func setup() {
    editButton.layer.cornerRadius = 10
    editButton.layer.borderWidth = 1
    
    exitButton.layer.cornerRadius = 10
    exitButton.layer.borderWidth = 1
    
    activityIndicator.hidesWhenStopped = true
  }
  
  
  
  
  // MARK: - Load profile information
  
  func loadProfile() {
    activityIndicator.startAnimating()
    
    profileStorageService.load { [weak self] profile in
      DispatchQueue.main.async {
        if let profile = profile {
          self?.username = profile.username
          self?.information = profile.information
          self?.image = profile.image
          
          self?.activityIndicator.stopAnimating()
        }
      }
    }
  }
  
  
  // MARK: - Adaptive layout
  
  private func adaptiveLayout() {
    let buttonWidth = profileImageButton.bounds.size.width
    
    profileImageView.layer.cornerRadius = buttonWidth / 2
    profileImageView.layer.masksToBounds = true
  }
  
  
  // MARK: - Button functions
  
  @IBAction func editProfileButtonTouch(_ sender: Any) {
    let controller = presentationAssembly.editProfileViewController(temporaryProfileImage: self.image)
    self.present(controller, animated: false)
  }
  
  @IBAction func exitProfileButtonTouch(_ sender: Any) {
    self.dismiss(animated: true, completion: nil)
  }
}

