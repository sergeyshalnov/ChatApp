//
//  CACommunicationController.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 11/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity.MCPeerID

final class CACommunicationController {
  
  private var storageService: IStorageService
  private var communicationService: ICommunicationService
  
  weak var delegate: ICACommunicationControllerDelegate?
  
  var session: MCSession {
    return communicationService.session
  }
  
  // MARK: - Init 
  
  init(communicationService: ICommunicationService,
       storageService: IStorageService) {
    
    self.communicationService = communicationService
    self.storageService = storageService
    
    setup()
  }
  
  deinit {
    communicationService.stop()
  }
  
}

extension CACommunicationController {
  
  func invite(peer: MCPeerID) {
    communicationService.invite(peer: peer)
  }
  
}

// MARK: - Setup

private extension CACommunicationController {
  
  func setup() {
    communicationService.delegate = self
    communicationService.start()
  }
  
}

// MARK: - ICommunicationServiceDelegate

extension CACommunicationController: ICommunicationServiceDelegate {
  
  func communicationService(_ communicationService: ICommunicationService,
                            didFoundPeer peer: MCPeerID) {
    
    storageService.add(user: peer)
  }
  
  func communicationService(_ communicationService: ICommunicationService,
                            didLostPeer peer: MCPeerID) {
    
    storageService.delete(user: peer)
  }
  
  func communicationService(_ communicationService: ICommunicationService,
                            didReceiveMessage message: MessageModel,
                            from peer: MCPeerID) {
    
    storageService.add(message: message, from: peer)
  }
  
  func communicationService(_ communicationService: ICommunicationService,
                            didReceiveInviteFromPeer peer: MCPeerID,
                            invintationClosure: @escaping (Bool) -> Void) {
    
    delegate?.communicationController(self, peer: peer) { (isAccepted) in
      invintationClosure(isAccepted)
    }
  }
  
  func communicationService(_ communicationService: ICommunicationService,
                            didChange state: MCSessionState,
                            from peer: MCPeerID) {
    switch state {
    case .connected:
      storageService.edit(user: UserModel(peer: peer, isOnline: true, isConfirmed: true))
    case .notConnected:
      storageService.delete(user: peer)
    default:
      break
    }
  }
  
}
