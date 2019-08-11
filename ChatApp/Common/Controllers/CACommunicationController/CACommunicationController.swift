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

private extension CACommunicationController {
  
  func setup() {
    communicationService.delegate = self
    communicationService.start()
  }
  
}

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
                            didReceiveMessage message: MessageData,
                            from peer: MCPeerID) {
    
    storageService.add(message: message, from: peer)
  }
  
}
