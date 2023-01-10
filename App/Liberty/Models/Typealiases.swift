//
//  Typealiases.swift
//  Liberty
//
//  Created by Yury Soloshenko on 14.08.2022.
//

import Foundation
import CryptoKit
import TunnelKit

typealias PrivateKey = Curve25519.KeyAgreement.PrivateKey

// MARK: - Handlers

typealias UpdateStateHandler = (VPNStatus) -> Void
