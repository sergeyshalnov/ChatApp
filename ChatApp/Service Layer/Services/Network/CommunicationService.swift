//
//  CommunicationService.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 26/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class CommunicationService: NSObject, ICommunicationService {
  
  // MARK: - Delegate
  
  weak var delegate: CommunicationServiceDelegate?
  
  // MARK: - Variables
  
  private let peer: MCPeerID
  private let session: MCSession
  private let browser: MCNearbyServiceBrowser
  private let advertiser: MCNearbyServiceAdvertiser
  private let discoveryInfo: [String: String]
  
  private let serviceType = "text-chat"
  
  
  // MARK: - Initialization & Deinitialization
  
  init(username: String) {
    self.discoveryInfo = ["userName": username]
    
    self.peer = MCPeerID(displayName: username)
    self.session = MCSession(peer: self.peer, securityIdentity: nil, encryptionPreference: .none)
    self.browser = MCNearbyServiceBrowser(peer: self.peer, serviceType: serviceType)
    self.advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: discoveryInfo, serviceType: serviceType)
    
    super.init()
    
    self.session.delegate = self
    self.browser.delegate = self
    self.advertiser.delegate = self
  }
  
  deinit {
    self.stop()
  }
  
  
  // MARK: - Browsing & Advertising functions
  
  func start() {
    browser.startBrowsingForPeers()
    advertiser.startAdvertisingPeer()
  }
  
  func stop() {
    browser.stopBrowsingForPeers()
    advertiser.stopAdvertisingPeer()
  }
  
  
  // MARK: - Communication functions
  
  func invite(_ message: MessageData?, to peer: Peer) {
    browser.invitePeer(peer.identifier, to: session, withContext: message?.text.data(using: .utf8), timeout: 300)
  }
  
  func send(_ message: MessageData, to peer: Peer) {
    do {
      let json = ["eventType": "TextMessage", "messageId": Generator.id(), "text": message.text]
      let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
      
      try session.send(jsonData, toPeers: [peer.identifier], with: .reliable)
    } catch {
      print("Error when send message to \(peer.identifier.description)")
      return
    }
  }
}

// MARK: - Session Delegate

extension CommunicationService: MCSessionDelegate {
  
  func session(_ session: MCSession, didReceive: Data, fromPeer: MCPeerID) {
    let peer = Peer(identifier: fromPeer, name: fromPeer.displayName)
    
    do {
      guard let json = try JSONSerialization.jsonObject(with: didReceive, options: []) as? [String: String] else { return }
      
      guard let messageId = json["messageId"] else { return }
      guard let text = json["text"] else { return }
      
      let message = MessageData(messageId: messageId, conversationId: "", text: text, date: NSDate(), incoming: true)
      
      
      DispatchQueue.main.async {
        self.delegate?.communicationService(self, didReceiveMessage: message, from: peer)
      }
    } catch {
      print("Error while receive message")
      return
    }
    
    
  }
  
  func session(_ session: MCSession, didStartReceivingResourceWithName: String, fromPeer: MCPeerID, with: Progress) { }
  func session(_ session: MCSession, didFinishReceivingResourceWithName: String, fromPeer: MCPeerID, at: URL?, withError: Error?) { }
  func session(_ session: MCSession, didReceive: InputStream, withName: String, fromPeer: MCPeerID) { }
  
  func session(_ session: MCSession, peer peerID: MCPeerID, didChange: MCSessionState) {
    let peer = Peer(identifier: peerID, name: peerID.displayName)
    delegate?.communicationService(self, didChange: didChange.rawValue == 0 ? .rejected : .confirmed, from: peer)
  }
}

// MARK: - Advertiser Delegate

extension CommunicationService: MCNearbyServiceAdvertiserDelegate {
  
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
    let peer: Peer = Peer(identifier: peerID, name: peerID.displayName)
    delegate?.communicationService(self, didReceiveInviteFromPeer: peer) { [weak self] accept in
      invitationHandler(accept, self?.session)
    }
  }
  
}

// MARK: - Browser Delegate

extension CommunicationService: MCNearbyServiceBrowserDelegate {
  func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
    let peer: Peer = Peer(identifier: peerID, name: peerID.displayName)
    delegate?.communicationService(self, didFoundPeer: peer)
  }
  
  func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    let peer: Peer = Peer(identifier: peerID, name: peerID.displayName)
    delegate?.communicationService(self, didLostPeer: peer)
  }
  
  
}
