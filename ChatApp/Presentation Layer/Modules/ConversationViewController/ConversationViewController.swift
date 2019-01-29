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
        
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 54)
        
        view.addConstraint(heightConstraint)
        
        return view
    }()
    
    let messageView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 150, width: 44, height: 144))
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.borderWidth = 0.7
        view.layer.borderColor = UIColor.greyBubble.cgColor
        
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 44)
        
        view.addConstraint(heightConstraint)
        
        return view
    }()
    
    let messageButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 34, height: 34))
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = UIColor.lightGray
        button.setTitle("S", for: .normal)
        button.isEnabled = true
        
        let widthButtonConstraint = NSLayoutConstraint(item: button, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 34)
        let heightButtonConstraint = NSLayoutConstraint(item: button, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 34)
        
        button.addConstraints([widthButtonConstraint, heightButtonConstraint])
        
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
        setupNavigationBar()
        setupSendButton()
        setupTableView()
        setupFetchResultsController()
        
        setupMessageInputView()
        setupKeyboardAppearance()
    }
    
    private func setupFetchResultsController() {
        messageFetchResultsController.delegate = self
        
        do {
            try messageFetchResultsController.performFetch()
        } catch {
            print("Fetch fail")
        }
    }
    
    private func setupSendButton() {
        changeButtonStatus(flag: false)
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
    }
    
    private func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
    }
    
    
    private func setupMessageInputView() {
        messageField.delegate = self
        
        messageView.addSubview(messageField)
        messageView.addSubview(messageButton)
        messageContainerView.addSubview(messageView)
        
        view.addSubview(messageContainerView)
        
        let leadingConstraint = NSLayoutConstraint(item: messageView, attribute: .leading, relatedBy: .equal, toItem: messageContainerView, attribute: .leading, multiplier: 1, constant: 15)
        let trailingConstraint = NSLayoutConstraint(item: messageView, attribute: .trailing, relatedBy: .equal, toItem: messageContainerView, attribute: .trailing, multiplier: 1, constant: -15)
        let bottomConstraint = NSLayoutConstraint(item: messageView, attribute: .bottom, relatedBy: .equal, toItem: messageContainerView, attribute: .bottom, multiplier: 1, constant: -10)
        
        view.addConstraints([leadingConstraint, trailingConstraint, bottomConstraint])
        
        let leadingContainerConstraint = NSLayoutConstraint(item: messageContainerView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 0)
        let trailingContainerConstraint = NSLayoutConstraint(item: messageContainerView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: 0)
        
        view.addConstraints([messageInputBottomConstraint, leadingContainerConstraint, trailingContainerConstraint])
        
        let leadingFieldConstraint = NSLayoutConstraint(item: messageField, attribute: .leading, relatedBy: .equal, toItem: messageView, attribute: .leading, multiplier: 1, constant: 15)
        let trailingFieldConstraint = NSLayoutConstraint(item: messageField, attribute: .trailing, relatedBy: .equal, toItem: messageButton, attribute: .leading, multiplier: 1, constant: -5)
        let trailingButtonConstraint = NSLayoutConstraint(item: messageButton, attribute: .trailing, relatedBy: .equal, toItem: messageView, attribute: .trailing, multiplier: 1, constant: -5)
        let verticalFieldConstraint = NSLayoutConstraint(item: messageField, attribute: .centerY, relatedBy: .equal, toItem: messageView, attribute: .centerY, multiplier: 1, constant: 0)
        let verticalButtonConstraint = NSLayoutConstraint(item: messageButton, attribute: .centerY, relatedBy: .equal, toItem: messageView, attribute: .centerY, multiplier: 1, constant: 0)
        let heightFieldConstraint = NSLayoutConstraint(item: messageField, attribute: .height, relatedBy: .equal, toItem: messageView, attribute: .height, multiplier: 1, constant: 0)
        
        messageView.addConstraints([leadingFieldConstraint, trailingFieldConstraint, trailingButtonConstraint, verticalFieldConstraint, verticalButtonConstraint, heightFieldConstraint])
    }
    
    
    // MARK: - Setup Keyboard Appearance
    
    private func setupKeyboardAppearance() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
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
    
    private func changeButtonStatus(flag: Bool) {
        messageButton.isEnabled = flag && online
        
        UIView.transition(with: messageButton, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.messageButton.backgroundColor = flag && self.online ? self.view.tintColor : UIColor.lightGray
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
    }
    
    // MARK: - TextFiled Change
    
    @objc func messageFieldChanged() {
        changeButtonStatus(flag: messageField.text != "")
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
            changeButtonStatus(flag: false)
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

// MARK: - FRC Delegate

extension ConversationViewController: NSFetchedResultsControllerDelegate{
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        
        
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
            conversationTableView.reloadData()
            
        } else {
            if let newIndexPath = newIndexPath {
                switch type {
                case .insert:
                    conversationTableView.insertRows(at: [newIndexPath], with: .automatic)
                default:
                    break
                }
                conversationTableView.reloadData()
            }
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        conversationTableView.endUpdates()
    }
    
}
