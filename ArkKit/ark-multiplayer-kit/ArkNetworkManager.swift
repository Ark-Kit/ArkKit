//
//  ArkMultiplayerService.swift
//  ArkKit
//
//  Created by Ryan Peh on 31/3/24.
//

import MultipeerConnectivity

class ArkNetworkManager: NSObject {
    private let gameServiceType: String
    private let myPeerId = MCPeerID(displayName: UIDevice.current.name)
    private var serviceAdvertiser: MCNearbyServiceAdvertiser
    private var serviceBrowser: MCNearbyServiceBrowser
    var delegate: ArkNetworkDelegate?
    

    lazy var session: MCSession = {
        let session = MCSession(peer: myPeerId, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        return session
    }()
    
    init(serviceType: String = "ark") {
        self.gameServiceType = serviceType
        self.serviceAdvertiser = MCNearbyServiceAdvertiser(peer: myPeerId, discoveryInfo: nil, serviceType: gameServiceType)
        self.serviceBrowser = MCNearbyServiceBrowser(peer: myPeerId, serviceType: gameServiceType)

        super.init()

        self.serviceAdvertiser.delegate = self
        self.serviceBrowser.delegate = self

        self.serviceAdvertiser.startAdvertisingPeer()
    }

    deinit {
        self.serviceAdvertiser.stopAdvertisingPeer()
        self.serviceBrowser.stopBrowsingForPeers()
    }

    func startAdvertisingPeer() {
        self.serviceAdvertiser.startAdvertisingPeer()
    }
    
    func startBrowsingForPeers() {
        self.serviceBrowser.startBrowsingForPeers()
    }
    
    func sendGameData(data: Data) {
        if session.connectedPeers.count > 0 {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            } catch let error {
                print("Error sending data: \(error.localizedDescription)")
            }
        }
    }
    
    func sendGameAction(action: String) {
        if session.connectedPeers.count > 0 {
            do {
                let data = action.data(using: .utf8)!
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            } catch let error {
                print("Error sending action: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - MCSessionDelegate

extension ArkNetworkManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        delegate?.connectedDevicesChanged(manager: self, connectedDevices: session.connectedPeers.map { $0.displayName })
    }

    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [unowned self] in
            delegate?.gameDataReceived(manager: self, gameData: data)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {}
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {}
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}

// MARK: - MCNearbyServiceAdvertiserDelegate and MCNearbyServiceBrowserDelegate

extension ArkNetworkManager: MCNearbyServiceAdvertiserDelegate, MCNearbyServiceBrowserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // Automatically accepts all requests to join
        invitationHandler(true, self.session)
    }

    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {}
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {}
}

// MARK: - ArkNetworkDelegate

protocol ArkNetworkDelegate {
    func connectedDevicesChanged(manager: ArkNetworkManager, connectedDevices: [String])
    func gameDataReceived(manager: ArkNetworkManager, gameData: Data)
}
