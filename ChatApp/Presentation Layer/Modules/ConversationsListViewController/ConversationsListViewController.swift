//
//  ConversationsListViewController.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 03/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//


import UIKit
import CoreData
import MultipeerConnectivity

class ConversationsListViewController: UIViewController {
  
  // MARK: - Outlets
  
  @IBOutlet weak var tableView: UITableView!
  
  // MARK: - Variables
  
  private let sections: [String] = ["Online", "History"]
  private let identifier = String(describing: ConversationsListCell.self)
  
  // MARK: - Covnersation delegate
  
  private var conversationDelegate: ConversationDelegate?
  private var currentPeerConversation: Peer?
  
  
  // MARK: - Assembly variables
  
  private var presentationAssembly: IPresentationAssembly
  private var communicationService: ICommunicationService
  private var communicationStorageService: ICommunicationStorageService
  private var profileStorageService: IProfileStorageService
  private var conversationFetchResultsController: NSFetchedResultsController<Conversation>
  
  // MARK: Temporary user storage
  
  private lazy var temporaryUserStorage: ITemporaryUserStorage = TemporaryUserStorage()
  
  
  // MARK: - Init
  
  init(presentationAssembly:IPresentationAssembly, communicationService: ICommunicationService, communicationStorageService: ICommunicationStorageService, profileStorageService: IProfileStorageService, conversationFetchResultsController: NSFetchedResultsController<Conversation>) {
    
    self.presentationAssembly = presentationAssembly
    self.communicationService = communicationService
    self.communicationStorageService = communicationStorageService
    self.profileStorageService = profileStorageService
    self.conversationFetchResultsController = conversationFetchResultsController
    
    super.init(nibName: nil, bundle: nil)
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
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    currentPeerConversation = nil
    conversationDelegate = nil
  }
  
  
  // MARK: - Setup Assembly
  
  func setupAssembly(presentationAssembly:IPresentationAssembly, communicationService: ICommunicationService, communicationStorageService: ICommunicationStorageService, profileStorageService: IProfileStorageService, conversationFetchResultsController: NSFetchedResultsController<Conversation>) {
    
    self.presentationAssembly = presentationAssembly
    self.communicationService = communicationService
    self.communicationStorageService = communicationStorageService
    self.profileStorageService = profileStorageService
    self.conversationFetchResultsController = conversationFetchResultsController
  }
  
  
  // MARK: - Private setup
  
  private func setup() {
    setupTableView()
    setupCommunicationService()
    setupFetchResultsController()
    setupNavigationBar()
  }
  
  private func setupCommunicationService() {
    communicationService.delegate = self
    communicationService.start()
  }
  
  private func setupFetchResultsController() {
    conversationFetchResultsController.delegate = self
    
    do {
      try conversationFetchResultsController.performFetch()
    } catch {
      print("Error while setup FetchResultsController")
      return
    }
  }
  
  private func setupTableView() {
    tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    
    tableView.separatorStyle = .none
    tableView.dataSource = self
    tableView.delegate = self
  }
  
  private func setupNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationController?.navigationBar.isTranslucent = true
    
    let searchController = UISearchController(searchResultsController: nil)
    navigationItem.searchController = searchController
    navigationItem.title = "Chats"
    
    setupProfileButton()
  }
  
  private func setupProfileButton() {
    let profileButton = UIButton(type: .system)
    
    profileButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
    profileButton.setImage(UIImage(named: "Contact")?.withRenderingMode(.alwaysOriginal), for: .normal)
    profileButton.addTarget(self, action: #selector(profileButtonTouch), for: .touchUpInside)
    
    profileButton.imageView?.contentMode = .scaleAspectFit
    profileButton.contentHorizontalAlignment = .right
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
  }
  
  
  // MARK: - Profile button
  
  @objc func profileButtonTouch() {
    let viewController = presentationAssembly.profileViewController()
    self.present(viewController, animated: true, completion: nil)
  }
}



// MARK: - UITableViewDataSource

extension ConversationsListViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    guard let sections = conversationFetchResultsController.sections else { return 0 }
    return sections.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = conversationFetchResultsController.sections else {
      fatalError("No sections in fetchedResultsController")
    }
    
    let sectionInfo = sections[section]
    return sectionInfo.numberOfObjects
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 44
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return sections[section]
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? ConversationsListCell else {
      return UITableViewCell()
    }
    
    let conversation = conversationFetchResultsController.object(at: indexPath)
    let user = conversation.user
    
    if let online = user?.online {
      cell.online = online
    }
    
    cell.name = user?.name
    
    cell.date = conversation.lastMessageDate as Date?
    cell.message = conversation.lastMessage
    cell.conversationId = conversation.conversationId
    
    cell.wasUnreadMessages = conversation.wasUnreadMessages
    
    return cell
  }
}



// MARK: - UITableViewDelegate

extension ConversationsListViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    guard let cell = tableView.cellForRow(at: indexPath) as? ConversationsListCell else { return }
    guard let id = cell.conversationId else { return }
    
    guard let user = temporaryUserStorage.find(conversationId: id) else { return }
    let peer = Peer(identifier: user.peer, name: user.peer.displayName)
    
    if user.isConfirmed {
      let conversationViewController = presentationAssembly.conversationViewController(title: cell.name, conversationId: user.conversationId, conversationListDelegate: self)
      
      conversationDelegate = conversationViewController
      conversationDelegate?.conversation(didSelectPeer: peer)
      currentPeerConversation = peer
      
      let conversation = ConversationData(conversationId: user.conversationId)
      communicationStorageService.edit(conversation: conversation)
      
      navigationController?.pushViewController(conversationViewController, animated: true)
      
      tableView.reloadData()
    } else {
      communicationService.invite(nil, to: peer)
    }
  }
}



// MARK: - ConversationList Protocol & Add message function

extension ConversationsListViewController: ConversationListDelegate {
  
  // MARK: - Protocol functions
  
  func conversationList(sentMessage message: MessageData, toPeer peer: Peer) {
    communicationService.send(message, to: peer)
  }
}



// MARK: - Communication Service Delegate

extension ConversationsListViewController: CommunicationServiceDelegate {
  
  func communicationService(_ communicationService: ICommunicationService, didFoundPeer peer: Peer) {
    let user = UserData(username: peer.name)
    
    communicationStorageService.add(user: user) { [weak self] conversationId in
      guard let id = conversationId else { return }
      let user = TemporaryUser(conversationId: id, peer: peer.identifier)
      self?.temporaryUserStorage.add(user: user)
    }
  }
  
  func communicationService(_ communicationService: ICommunicationService, didLostPeer peer: Peer) {
    if let user = temporaryUserStorage.find(peer: peer.identifier) {
      communicationStorageService.delete(conversationId: user.conversationId)
      temporaryUserStorage.delete(conversationId: user.conversationId)
      conversationDelegate?.conversation(didLostPeer: peer)
      
      tableView.reloadData()
    }
    
  }
  
  func communicationService(_ communicationService: ICommunicationService, didNotStartBrowsingForPeers error: Error) {
    print("Error: \(error.localizedDescription)")
  }
  
  func communicationService(_ communicationService: ICommunicationService, didChange state: inviteState, from peer: Peer) {
    temporaryUserStorage.change(confirmed: state == .confirmed ? true : false, peer: peer.identifier)
  }
  
  func communicationService(_ communicationService: ICommunicationService, didReceiveInviteFromPeer peer: Peer, invintationClosure: @escaping (Bool) -> Void) {
    
    let left: (UIAlertAction) -> Void = { [weak self] UIAlertAction in
      guard let temporaryUserStorage = self?.temporaryUserStorage else { return }
      temporaryUserStorage.change(confirmed: true, peer: peer.identifier)
      invintationClosure(true)
    }
    
    let right: (UIAlertAction) -> Void = { UIAlertAction in
      invintationClosure(false)
    }
    
    let alert = UIAlertController(title: peer.name, message: "Пользователь прислал вам приглашение", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Принять", style: .default, handler: left))
    alert.addAction(UIAlertAction(title: "Отклонить", style: .default, handler: right))
    
    self.present(alert, animated: true, completion: nil)
    
  }
  
  func communicationService(_ communicationService: ICommunicationService, didNotStartAdvertisingForPeers error: Error) {
    print("Error: \(error.localizedDescription)")
  }
  
  func communicationService(_ communicationService: ICommunicationService, didReceiveMessage message: MessageData, from peer: Peer) {
    guard let user = temporaryUserStorage.find(peer: peer.identifier) else { return }
    
    let message = MessageData(messageId: message.messageId,
                              conversationId: user.conversationId,
                              text: message.text,
                              date: message.date,
                              incoming: message.incoming)
    
    communicationStorageService.add(message: message)
    
    if user.peer != currentPeerConversation?.identifier {
      let conversation = ConversationData(conversationId: user.conversationId, wasUnreadMessages: true)
      communicationStorageService.edit(conversation: conversation)
    }
    
    print("Receive message from \(peer.identifier.displayName): \(message.text)")
  }
}



// MARK: - NSFetchedResultsControllerDelegate

extension ConversationsListViewController: NSFetchedResultsControllerDelegate {
  
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                  didChange anObject: Any,
                  at indexPath: IndexPath?,
                  for type: NSFetchedResultsChangeType,
                  newIndexPath: IndexPath?) {
    
    if let indexPath = indexPath {
      
      switch type {
      case .update:
        tableView.reloadRows(at: [indexPath], with: .automatic)
      case .move:
        guard let newIndexPath = newIndexPath else { return }
        tableView.moveRow(at: indexPath, to: newIndexPath)
      case .delete:
        tableView.deleteRows(at: [indexPath], with: .automatic)
      default:
        break
      }
      
    } else {
      if let newIndexPath = newIndexPath {
        switch type {
        case .insert:
          tableView.insertRows(at: [newIndexPath], with: .automatic)
        default:
          break
        }
      }
    }
  }
  
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
  
}





