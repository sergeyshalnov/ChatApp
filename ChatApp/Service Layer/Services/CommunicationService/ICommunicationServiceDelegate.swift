//
//  ICommunicationServiceDelegate.swift
//  ChatApp
//
//  Created by Шальнов Сергей Сергеевич on 19/08/2019.
//  Copyright © 2019 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ICommunicationServiceDelegate: class {
  
  func communicationService(_ communicationService: ICommunicationService,
                            didFoundPeer peer: MCPeerID)
  
  func communicationService(_ communicationService: ICommunicationService,
                            didLostPeer peer: MCPeerID)
  
  func communicationService(_ communicationService: ICommunicationService,
                            didNotStartBrowsingForPeers error: Error)
  
  func communicationService(_ communicationService: ICommunicationService,
                            didReceiveMessage message: MessageModel,
                            from peer: MCPeerID)
  
  func communicationService(_ communicationService: ICommunicationService,
                            didReceiveInviteFromPeer peer: MCPeerID,
                            invintationClosure: @escaping (Bool) -> Void)
  
  func communicationService(_ communicationService: ICommunicationService,
                            didNotStartAdvertisingForPeers error: Error)
  
  func communicationService(_ communicationService: ICommunicationService,
                            didChange state: MCSessionState,
                            from peer: MCPeerID)
  
}

// MARK: - Optional

extension ICommunicationServiceDelegate {
  
  func communicationService(_ communicationService: ICommunicationService,
                            didNotStartBrowsingForPeers error: Error) { }
  
  func communicationService(_ communicationService: ICommunicationService,
                            didNotStartAdvertisingForPeers error: Error) { }
  
  func communicationService(_ communicationService: ICommunicationService,
                            didChange state: MCSessionState,
                            from peer: MCPeerID) { }
  
}
