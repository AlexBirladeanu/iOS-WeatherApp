//
//  KeyChainService.swift
//  Clima
//
//  Created by Alex Bîrlădeanu on 11.12.2023.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import Security

class KeyChainService {
    
    static let shared = KeyChainService()
    private let service = "alexbir-clima-weather-apiId-service"
    private let account = "alexbir-clima-weather-apiId"
    
    private init() {}
    
    ///call this function only once
    func saveApiKeyToKeychain(apiKey: String) {
        if let keyData = apiKey.data(using: .utf8) {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: account,
                kSecValueData as String: keyData
            ]

            let status = SecItemAdd(query as CFDictionary, nil)

            if status != errSecSuccess {
                print("Error saving API key to Keychain: \(status)")
            }
        }
    }
    
    func loadApiKeyFromKeychain() -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        if status == errSecSuccess, let data = result as? Data {
            return String(data: data, encoding: .utf8) ?? ""
        } else {
            print("Error loading API key from Keychain: \(status)")
            return ""
        }
    }
}
