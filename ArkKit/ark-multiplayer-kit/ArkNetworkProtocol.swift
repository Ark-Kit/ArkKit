//
//  ArkNetworkProtocol.swift
//  ArkKit
//
//  Created by Ryan Peh on 2/4/24.
//
import Foundation

protocol ArkNetworkProtocol {
    var delegate: ArkNetworkDelegate? { get set }

    init(serviceName: String)
    func sendData(data: Data)
}
