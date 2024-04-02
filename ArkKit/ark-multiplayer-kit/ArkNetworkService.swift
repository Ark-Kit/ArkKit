//
//  ArkNetworkService.swift
//  ArkKit
//
//  Created by Ryan Peh on 31/3/24.
//

import UIKit
import P2PShare

class ArkNetworkService: ArkNetworkProtocol {
    private let myPeerInfo = PeerInfo(["name": UIDevice.current.name])
    private var peers: [PeerInfo] = []
    private var session: MultipeerSession!
    var delegate: ArkNetworkDelegate?

    required init(serviceName: String = "Ark") {
        let config = MultipeerSessionConfig(myPeerInfo: myPeerInfo,
                                            bonjourService: "_ArkMultiplayer._tcp",
                                            presharedKey: "12345",
                                            identity: serviceName)
        self.session = MultipeerSession(config: config, queue: .main)
        setUpHandlers()

        session.startSharing()
    }

    deinit {
        session.stopSharing()
    }

    private func setUpHandlers() {
        self.session.peersChangeHandler = { [weak self] peers in
            self?.peers = peers
            self?.delegate?.connectedDevicesChanged(manager: self!, connectedDevices: peers.map { $0.peerID })
            print("Peers changed: \(peers.map { $0.peerID })")
        }

        self.session.newPeerHandler = { peer in
            print("New peer joined: \(peer.peerID)")
        }

        self.session.messageReceivedHandler = { [weak self] _, data in
            self?.delegate?.gameDataReceived(manager: self!, gameData: data)
        }
    }

    func sendData(data: Data) {
        if !self.peers.isEmpty {
            session.sendToAllPeers(data: data)
        }
    }
}

// MARK: - ArkNetworkDelegate

protocol ArkNetworkDelegate: AnyObject {
    func connectedDevicesChanged(manager: ArkNetworkService, connectedDevices: [String])
    func gameDataReceived(manager: ArkNetworkService, gameData: Data)
}
