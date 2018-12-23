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
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - Variables
    
    private let incomingID = String("IncomingCell")
    private let outgoingID = String("OutgoingCell")
    
 
    // MARK: - Private variables
    
    private var peer: Peer?
    private var online: Bool = true
    
    // MARK: - ConversationListDelegate
    
    var conversationListDelegate: ConversationListDelegate?
    
    // MARK: - messageFRC
    
    var conversationId: String?
    
    ////////////
    
    private var presentationAssembly: IPresentationAssembly?
    private var communicationStorageService: ICommunicationStorageService?
    private var messageFetchResultsController: NSFetchedResultsController<Message>?

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        
        changeButtonStatus(flag: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        sendButton.layer.cornerRadius = sendButton.bounds.height / 2
        
        messageTextField.clipsToBounds = true
        messageTextField.layer.borderWidth = 0.5
        messageTextField.layer.borderColor = UIColor.greyBubble.cgColor
        messageTextField.layer.cornerRadius = messageTextField.bounds.height / 2
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 1) {
            self.navigationItem.titleView?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }
        
        
    }
    
    
    // MARK: - Setup Assembly
    
    func setupAssembly(presentationAssembly: IPresentationAssembly, communicationStorageService: ICommunicationStorageService, messageFetchResultsController: NSFetchedResultsController<Message>) {
        self.presentationAssembly = presentationAssembly
        self.communicationStorageService = communicationStorageService
        self.messageFetchResultsController = messageFetchResultsController
    }
    
    
    // MARK: - Private functions
    
    private func setup() {
        conversationTableView.register(UINib(nibName: incomingID, bundle: nil), forCellReuseIdentifier: incomingID)
        conversationTableView.register(UINib(nibName: outgoingID, bundle: nil), forCellReuseIdentifier: outgoingID)
        
        conversationTableView.separatorStyle = .none
        conversationTableView.dataSource = self
        conversationTableView.delegate = self
        
        conversationTableView.rowHeight = UITableViewAutomaticDimension
        conversationTableView.estimatedRowHeight = 60
        
        conversationTableView.allowsSelection = false
        
        sendButton.backgroundColor = self.view.tintColor
        sendButton.setTitleColor(UIColor.white, for: .normal)
        
        messageFetchResultsController?.delegate = self
        
        do {
            try messageFetchResultsController?.performFetch()
        } catch {
            print("Fetch fail")
        }
    }
    
    // MARK: - Button Status Animation
    
    private func changeButtonStatus(flag: Bool) {
        sendButton.isEnabled = flag && online
        
        let colorAnimation: () -> Void = {
            self.sendButton.backgroundColor = flag && self.online ? self.view.tintColor : UIColor.red
        }
        
        UIView.transition(with: sendButton, duration: 0.5, options: .transitionCrossDissolve, animations: colorAnimation)
        UIView.animate(withDuration: 0.5) {
            self.sendButton.transform = flag && self.online ? .identity : CGAffineTransform(scaleX: 1.15, y: 1.15)
        }
    }
    
    // MARK: - User Status Animation
    
    private func changeUserStatus(online: Bool) {
        guard let label = self.navigationItem.titleView as? UILabel else { return }
        
        UIView.transition(with: label, duration: 1, options: .transitionCrossDissolve, animations: {
            label.textColor = online ? UIColor.greenPantone : UIColor.black
        }, completion: nil)

        UIView.animate(withDuration: 1) {
            label.transform = online ? CGAffineTransform(scaleX: 1.1, y: 1.1) : .identity
        }
        
    }
    
    
    // MARK: - Button functions

    @IBAction func sendMessageButtonTouch(_ sender: Any) {
        guard let text = messageTextField.text else { return }
        guard let conversationId = conversationId else { return }
        guard let peer = peer else { return }
        let date = NSDate()
        let id = Generator.id()

        let message = MessageData(messageId: id, conversationId: conversationId, text: text, date: date, incoming: false)
        communicationStorageService?.add(message: message)
        
        conversationListDelegate?.conversationList(sentMessage: message, toPeer: peer)
    }
    
    // MARK: - TextFiled Change
    
    @IBAction func changeEDIT(_ sender: Any) {
        changeButtonStatus(flag: messageTextField.text != "")
    }
    
}

extension ConversationViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(gestureRecognizer.description)
        return true
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
            changeUserStatus(online: false)
        }
    }
    
    
}

extension ConversationViewController: UITableViewDataSource {
    
    // MARK: - TableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = messageFetchResultsController?.sections else { return 0 }
        
        let sectionInfo = sections[section]
        return sectionInfo.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let message = messageFetchResultsController?.object(at: indexPath) else { fatalError() }
        let incoming = message.incoming
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: incoming ? incomingID : outgoingID, for: indexPath) as? ConversationCell else {
            return UITableViewCell()
        }
        
        cell.message = message.text
        cell.incoming = incoming
        
        return cell
    }
}

extension ConversationViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if messageTextField.text == "" {
            changeButtonStatus(flag: false)
        }
    }
    
}

// MARK: - TableViewDelegate

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
