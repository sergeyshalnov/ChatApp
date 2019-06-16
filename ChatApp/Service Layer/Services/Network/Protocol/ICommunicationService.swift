//
//  NetworkProtocols.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 26/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation

enum inviteState {
  case confirmed
  case rejected
}

protocol ICommunicationService {
  
  var delegate: CommunicationServiceDelegate? { get set }
  
  // Start browsing & advertising for peers
  func start()
  // Stop browsing & advertising for peers
  func stop()
  
  // Send message to peer
  func send(_ message: MessageData, to peer: Peer)
  // Invite peer to conversation
  func invite(_ message: MessageData?, to peer: Peer)
  
}

protocol CommunicationServiceDelegate: class {
  
  // MARK: - Browsing
  func communicationService(_ communicationService: ICommunicationService, didFoundPeer peer: Peer)
  func communicationService(_ communicationService: ICommunicationService, didLostPeer peer: Peer)
  func communicationService(_ communicationService: ICommunicationService, didNotStartBrowsingForPeers error: Error)
  
  // MARK: - Advertising
  func communicationService(_ communicationService: ICommunicationService, didReceiveInviteFromPeer peer: Peer,
                            invintationClosure: @escaping (Bool) -> Void)
  func communicationService(_ communicationService: ICommunicationService, didNotStartAdvertisingForPeers error: Error)
  
  // MARK: - Messages
  func communicationService(_ communicationService: ICommunicationService, didReceiveMessage message: MessageData, from peer: Peer)
  
  // MARK: - Invite
  func communicationService(_ communicationService: ICommunicationService, didChange state: inviteState, from peer: Peer)
  
}

