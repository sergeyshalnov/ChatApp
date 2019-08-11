//
//  CommunicationService.swift
//  ChatApp
//
//  Created by Sergey Shalnov on 26/10/2018.
//  Copyright © 2018 Sergey Shalnov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class CommunicationService: NSObject {
  
  // MARK: - Delegate
  
  weak var delegate: ICommunicationServiceDelegate?
  
  // MARK: - Variables
  
  private let peer: MCPeerID
  private let session: MCSession
  private let browser: MCNearbyServiceBrowser
  private let advertiser: MCNearbyServiceAdvertiser
  private let discoveryInfo: [String: String]
  
  private let serviceType = "text-chat"
  
  
  // MARK: - Initialization & Deinitialization
  
  init(username: String) {
    discoveryInfo = ["userName": username]
    
    peer = MCPeerID(displayName: username)
    session = MCSession(peer: peer, securityIdentity: nil, encryptionPreference: .none)
    browser = MCNearbyServiceBrowser(peer: peer, serviceType: serviceType)
    advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: discoveryInfo, serviceType: serviceType)
    
    super.init()
    
    session.delegate = self
    browser.delegate = self
    advertiser.delegate = self
  }
  
  deinit {
    stop()
  }
  
}

// MARK: - ICommunicationService

extension CommunicationService: ICommunicationService {
  
  func start() {
    browser.startBrowsingForPeers()
    advertiser.startAdvertisingPeer()
  }
  
  func stop() {
    browser.stopBrowsingForPeers()
    advertiser.stopAdvertisingPeer()
  }
  
  func send(_ message: MessageData, to peer: MCPeerID) {
    do {
      let json = ["eventType": "TextMessage", "messageId": Generator.id(), "text": message.text]
      let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
      
      try session.send(jsonData, toPeers: [peer], with: .reliable)
    } catch {
      print("Error when send message to \(peer.description)")
      return
    }
  }
}

// MARK: - MCSessionDelegate

extension CommunicationService: MCSessionDelegate {
  
  func session(_ session: MCSession, didReceive: Data, fromPeer: MCPeerID) {
//    let peer = Peer(identifier: fromPeer, name: fromPeer.displayName)
    
    do {
      guard let json = try JSONSerialization.jsonObject(with: didReceive, options: []) as? [String: String] else { return }
      
      guard let messageId = json["messageId"] else { return }
      guard let text = json["text"] else { return }
      
      let message = MessageData(id: messageId, text: text, date: NSDate(), isIncoming: true)
      
      
      DispatchQueue.main.async {
        self.delegate?.communicationService(self, didReceiveMessage: message, from: fromPeer)
      }
    } catch {
      print("Error while receive message")
      return
    }
    
    
  }
  
  func session(_ session: MCSession,
               didStartReceivingResourceWithName: String,
               fromPeer: MCPeerID,
               with: Progress) {
    
    #if DEBUG
    let log = """
      Peer \"\(fromPeer.displayName)\" did start receiving resource with name
      \"\(didStartReceivingResourceWithName)\", progress: \(with.debugDescription)"
      """
    
    print(log)
    #endif
  }
  
  func session(_ session: MCSession,
               didFinishReceivingResourceWithName: String,
               fromPeer: MCPeerID,
               at: URL?,
               withError: Error?) {
    
    #if DEBUG
    let log = """
      Peer \"\(fromPeer.displayName)\" did finish receiving resource
      with name \"\(didFinishReceivingResourceWithName)\"
      """
    
    print(log)
    #endif
  }
  
  func session(_ session: MCSession,
               didReceive: InputStream,
               withName: String,
               fromPeer: MCPeerID) {
    
    #if DEBUG
    print("Peer \"\(fromPeer.displayName)\" did receive stream with name \"\(withName)\"")
    #endif
  }
  
  func session(_ session: MCSession,
               peer peerID: MCPeerID,
               didChange: MCSessionState) {
    
    #if DEBUG
    switch didChange {
    case .connected:
      print("Peer \"\(peerID.displayName)\" connected")
    case .connecting:
      print("Peer \"\(peerID.displayName)\" is connecting")
    case .notConnected:
      print("Peer \"\(peerID.displayName)\" not connected")
    @unknown default:
      print("Peer \"\(peerID.displayName)\" have unknow MCSessionState")
    }
    #endif
  }
  
}

// MARK: - MCNearbyServiceAdvertiserDelegate

extension CommunicationService: MCNearbyServiceAdvertiserDelegate {
  
  func advertiser(_ advertiser: MCNearbyServiceAdvertiser,
                  didReceiveInvitationFromPeer peerID: MCPeerID,
                  withContext context: Data?,
                  invitationHandler: @escaping (Bool, MCSession?) -> Void) {

    invitationHandler(true, session)
  }
  
}

// MARK: - MCNearbyServiceBrowserDelegate

extension CommunicationService: MCNearbyServiceBrowserDelegate {
  
  func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
    delegate?.communicationService(self, didLostPeer: peerID)
  }
  
  func browser(_ browser: MCNearbyServiceBrowser,
               foundPeer peerID: MCPeerID,
               withDiscoveryInfo info: [String : String]?) {
    
    browser.invitePeer(peerID, to: session, withContext: nil, timeout: 300)
    delegate?.communicationService(self, didFoundPeer: peerID)
  }
  
}
