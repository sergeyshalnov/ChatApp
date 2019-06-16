//
//  ConversationViewController.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 05/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import UIKit
import CoreData

class ConversationViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var conversationTableView: UITableView!
  
  // MARK: - Variables
  
  private let incomingID = String("IncomingCell")
  private let outgoingID = String("OutgoingCell")
  
  
  // MARK: - Private variables
  
  private var peer: Peer?
  private var online: Bool = true
  
  // MARK: - ConversationListDelegate
  
  var conversationListDelegate: ConversationListDelegate?
  
  // MARK: - Current conversation id
  
  var currentConversationId: String?
  
  // MARK: - Services & Assembly
  
  private var presentationAssembly: IPresentationAssembly
  private var communicationStorageService: ICommunicationStorageService
  private var messageFetchResultsController: NSFetchedResultsController<Message>
  
  // MARK: - Message input views
  
  let messageContainerView: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 150, width: 154, height: 54))
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.white
    
    return view
  }()
  
  let messageView: UIView = {
    let view = UIView(frame: CGRect(x: 0, y: 150, width: 44, height: 144))
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.clipsToBounds = true
    view.layer.borderWidth = 0.7
    view.layer.borderColor = UIColor.Palette.Bubble.grey.cgColor
    view.heightAnchor.constraint(equalToConstant: 44).isActive = true
    
    return view
  }()
  
  let messageButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
    
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = UIColor.lightGray
    button.setTitle("S", for: .normal)
    button.isEnabled = true
    button.widthAnchor.constraint(equalToConstant: 34).isActive = true
    button.heightAnchor.constraint(equalToConstant: 34).isActive = true
    
    button.addTarget(self, action: #selector(sendMessageButtonTouchUpInside), for: .touchUpInside)
    
    return button
  }()
  
  let messageField: UITextField = {
    let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
    
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.placeholder = "Message..."
    textField.addTarget(self, action: #selector(messageFieldChanged), for: .editingChanged)
    
    return textField
  }()
  
  // MARK: - Message input constraints
  
  lazy var messageInputBottomConstraint = NSLayoutConstraint(item: messageContainerView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottomMargin, multiplier: 1, constant: 0)
  
  
  // MARK: - Init
  
  init(title: String?, currentConversation: String, conversationListDelegate: ConversationListDelegate,presentationAssembly: IPresentationAssembly, communicationStorageService: ICommunicationStorageService, messageFetchResultsController: NSFetchedResultsController<Message>) {
    
    self.currentConversationId = currentConversation
    self.conversationListDelegate = conversationListDelegate
    
    self.presentationAssembly = presentationAssembly
    self.communicationStorageService = communicationStorageService
    self.messageFetchResultsController = messageFetchResultsController
    
    super.init(nibName: nil, bundle: nil)
    
    self.navigationItem.title = title
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  
  // MARK: - Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setup()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    messageButton.layer.cornerRadius = messageButton.bounds.height / 2
    messageView.layer.cornerRadius = messageView.bounds.height / 2
  }
  
  
  // MARK: - Setup Assembly
  
  func setupAssembly(presentationAssembly: IPresentationAssembly, communicationStorageService: ICommunicationStorageService, messageFetchResultsController: NSFetchedResultsController<Message>) {
    self.presentationAssembly = presentationAssembly
    self.communicationStorageService = communicationStorageService
    self.messageFetchResultsController = messageFetchResultsController
  }
  
  
  // MARK: - Private setup functions
  
  private func setup() {
    setupFetchResultsController()
    setupKeyboardAppearance()
    setupNavigationBar()
    setupInputLayout()
    setupTableView()
  }
  
  private func setupFetchResultsController() {
    messageFetchResultsController.delegate = self
    
    do {
      try messageFetchResultsController.performFetch()
    } catch {
      print("Fetch fail")
    }
  }
  
  private func setupKeyboardAppearance() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
  }
  
  private func setupTableView() {
    conversationTableView.register(UINib(nibName: incomingID, bundle: nil), forCellReuseIdentifier: incomingID)
    conversationTableView.register(UINib(nibName: outgoingID, bundle: nil), forCellReuseIdentifier: outgoingID)
    
    conversationTableView.separatorStyle = .none
    conversationTableView.dataSource = self
    conversationTableView.delegate = self
    conversationTableView.rowHeight = UITableView.automaticDimension
    conversationTableView.estimatedRowHeight = 60
    conversationTableView.allowsSelection = false
    
    // Setup conversationTableView layout
    conversationTableView.translatesAutoresizingMaskIntoConstraints = false
    conversationTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    conversationTableView.bottomAnchor.constraint(equalTo: messageContainerView.topAnchor).isActive = true
    conversationTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    conversationTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    
    // Reverse tableView
    conversationTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
  }
  
  private func setupNavigationBar() {
    navigationItem.largeTitleDisplayMode = .never
  }
  
  private func setupInputLayout() {
    messageField.delegate = self
    
    // Add subviews
    messageView.addSubview(messageField)
    messageView.addSubview(messageButton)
    messageContainerView.addSubview(messageView)
    view.addSubview(messageContainerView)
    view.addConstraint(messageInputBottomConstraint)
    
    // Setup messageView layout
    messageView.leadingAnchor.constraint(equalTo: messageContainerView.leadingAnchor, constant: 15).isActive = true
    messageView.trailingAnchor.constraint(equalTo: messageContainerView.trailingAnchor, constant: -15).isActive = true
    messageView.bottomAnchor.constraint(equalTo: messageContainerView.bottomAnchor, constant: -10).isActive = true
    messageView.topAnchor.constraint(equalTo: messageContainerView.topAnchor, constant: 10).isActive = true
    
    // Setup messageContainerView layout
    messageContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    messageContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    
    // Setup messageField layout
    messageField.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 15).isActive = true
    messageField.trailingAnchor.constraint(equalTo: messageButton.leadingAnchor, constant: -5).isActive = true
    messageField.centerYAnchor.constraint(equalTo: messageView.centerYAnchor).isActive = true
    messageField.heightAnchor.constraint(equalTo: messageView.heightAnchor).isActive = true
    
    // Setup messageButton layout
    messageButton.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -5).isActive = true
    messageButton.centerYAnchor.constraint(equalTo: messageView.centerYAnchor).isActive = true
    
    // Change sendButton state
    changeButtonState(isEnable: false)
  }
  
  
  // MARK: - Setup Keyboard appearance
  
  @objc func keyboardWillShow(notification: NSNotification) {
    if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
      
      UIView.animate(withDuration: 0.5) {
        self.messageInputBottomConstraint.constant = -keyboardSize.height
        self.view.layoutIfNeeded()
      }
      
    }
  }
  
  @objc func keyboardWillHide(notification: NSNotification) {
    messageInputBottomConstraint.constant = 0
    view.layoutIfNeeded()
  }
  
  
  // MARK: - Button Status Animation
  
  private func changeButtonState(isEnable: Bool) {
    messageButton.isEnabled = isEnable && online
    
    UIView.transition(with: messageButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
      self.messageButton.backgroundColor = isEnable && self.online ? self.view.tintColor : UIColor.lightGray
    })
  }
  
  
  // MARK: - Button functions
  
  @objc func sendMessageButtonTouchUpInside() {
    guard let text = messageField.text else { return }
    guard let currentConversationId = currentConversationId else { return }
    guard let peer = peer else { return }
    
    let date = NSDate()
    let id = Generator.id()
    let message = MessageData(messageId: id, conversationId: currentConversationId, text: text, date: date, incoming: false)
    
    communicationStorageService.add(message: message)
    conversationListDelegate?.conversationList(sentMessage: message, toPeer: peer)
    
    messageField.text = ""
    changeButtonState(isEnable: false)
  }
  
  
  // MARK: - TextFiled Change
  
  @objc func messageFieldChanged() {
    changeButtonState(isEnable: messageField.text != "")
  }
  
}


// MARK: - ConversationDelegate

extension ConversationViewController: ConversationDelegate {
  
  func conversation(didSelectPeer peer: Peer) {
    self.peer = peer
  }
  
  func conversation(didLostPeer peer: Peer) {
    if self.peer?.identifier == peer.identifier {
      online = false
      changeButtonState(isEnable: false)
    }
  }
  
}

extension ConversationViewController: UITableViewDataSource {
  
  // MARK: - TableViewDataSource
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = messageFetchResultsController.sections else { return 0 }
    
    let sectionInfo = sections[section]
    return sectionInfo.numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let message = messageFetchResultsController.object(at: indexPath)
    let incoming = message.incoming
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: incoming ? incomingID : outgoingID, for: indexPath) as? ConversationCell else {
      return UITableViewCell()
    }
    
    cell.message = message.text
    cell.incoming = incoming
    cell.transform = CGAffineTransform(scaleX: 1, y: -1)
    
    return cell
  }
}


// MARK: - UITextFieldDelegate

extension ConversationViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    self.view.endEditing(true)
    return false
  }
  
}


// MARK: - UITableViewDelegate

extension ConversationViewController: UITableViewDelegate {
  
  // ---
  
}


// MARK: - NSFetchedResultsControllerDelegate

extension ConversationViewController: NSFetchedResultsControllerDelegate{
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    conversationTableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    
    if let indexPath = indexPath {
      
      switch type {
      case .update:
        conversationTableView.reloadRows(at: [indexPath], with: .automatic)
      case .move:
        guard let newIndexPath = newIndexPath else { return }
        conversationTableView.moveRow(at: indexPath, to: newIndexPath)
      case .delete:
        conversationTableView.deleteRows(at: [indexPath], with: .automatic)
      default:
        break
      }
    } else {
      if let newIndexPath = newIndexPath {
        switch type {
        case .insert:
          conversationTableView.insertRows(at: [newIndexPath], with: .top)
        default:
          break
        }
      }
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    conversationTableView.endUpdates()
  }
  
}
