//
//  NetworkProtocols.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 26/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity.MCPeerID

enum inviteState {
  case confirmed
  case rejected
}

protocol ICommunicationService {
  
  var delegate: ICommunicationServiceDelegate? { get set }
  
  func start()
  func stop()
  
  func send(_ message: MessageData, to peer: MCPeerID)
  
}

protocol ICommunicationServiceDelegate: class {
  
  func communicationService(_ communicationService: ICommunicationService,
                            didFoundPeer peer: MCPeerID)
  
  func communicationService(_ communicationService: ICommunicationService,
                            didLostPeer peer: MCPeerID)
  
  func communicationService(_ communicationService: ICommunicationService,
                            didNotStartBrowsingForPeers error: Error)
  
  func communicationService(_ communicationService: ICommunicationService,
                            didReceiveMessage message: MessageData,
                            from peer: MCPeerID)
  
  func communicationService(_ communicationService: ICommunicationService,
                            didReceiveInviteFromPeer peer: MCPeerID,
                            invintationClosure: @escaping (Bool) -> Void)
  
  func communicationService(_ communicationService: ICommunicationService,
                            didNotStartAdvertisingForPeers error: Error)
  
  func communicationService(_ communicationService: ICommunicationService,
                            didChange state: inviteState,
                            from peer: MCPeerID)
  
}

// MARK: - Optional

extension ICommunicationServiceDelegate {
  
  func communicationService(_ communicationService: ICommunicationService,
                            didNotStartBrowsingForPeers error: Error) { }
  
  func communicationService(_ communicationService: ICommunicationService,
                            didReceiveInviteFromPeer peer: MCPeerID,
                            invintationClosure: @escaping (Bool) -> Void) { }
  
  func communicationService(_ communicationService: ICommunicationService,
                            didNotStartAdvertisingForPeers error: Error) { }
  
  func communicationService(_ communicationService: ICommunicationService,
                            didChange state: inviteState,
                            from peer: MCPeerID) { }
  
}

