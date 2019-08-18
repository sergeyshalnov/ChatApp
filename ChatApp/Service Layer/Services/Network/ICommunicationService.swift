//
//  NetworkProtocols.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 26/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ICommunicationService {
  
  var delegate: ICommunicationServiceDelegate? { get set }
  var session: MCSession? { get }
  
  func invite(peer: MCPeerID)
  func start(completion: @escaping Closure<Bool, ()>)
  func stop()
  
}

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

