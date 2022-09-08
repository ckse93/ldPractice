//
//  LDService.swift
//  launchdarklyPractice
//
//  Created by Chan Jung on 9/2/22.
//

import Foundation
import LaunchDarkly

fileprivate enum LDKeys: String, CaseIterable {
    case testFlag = "testFlag"
    case LDMessage = "ldMessageNotMistake"  // fucl
    case luckyNumber = "luckyNumber"
}

final class LDService: ObservableObject {
    private init(){}
    
    static let shared = LDService()
    
    // might want to put this in a file and add it to gitignore 
    private var config: LDConfig {
        #if DEBUG
        LDConfig(mobileKey: "mob-36cbf8e9-02da-4f93-921c-7cb3d32e2c8b")
        #else
        LDConfig(mobileKey: "mob-0c978f2b-0a25-4c11-9918-a3cb2d1c8e6e")
        #endif
    }
    private let user = LDUser(key: "test-user-chan")
    
    @Published var testFlag: Bool = false
    @Published var ldMessage: String = ""
    @Published var luckyNumber: Double = 0.0
    
    @MainActor
    func startLDClient() {
        LDClient.start(config: self.config, user: self.user)
        print("started LDClient")
        
        fetchFlags()
        
        observe()
    }
    
    /// inital call to fetch flags from LD server
    private func fetchFlags() {
        guard let client = LDClient.get() else {
            return
        }
        
        for ldKey in LDKeys.allCases {
            switch ldKey {
            case .testFlag:
                self.testFlag = client.boolVariation(forKey: ldKey.rawValue, defaultValue: self.testFlag)
            
            case .LDMessage:
                self.ldMessage = client.stringVariation(forKey: ldKey.rawValue, defaultValue: self.ldMessage)
                
            case .luckyNumber:
                self.luckyNumber = client.doubleVariation(forKey: ldKey.rawValue, defaultValue: self.luckyNumber)
            }
        }
    }
    
    /// observe flags in `LDKeys` enum, if you dont want to observe the changes, simply do not add the case 
    private func observe() {
        guard let client = LDClient.get() else { return }
        
        for ldKey in LDKeys.allCases {
            client.observe(key: ldKey.rawValue, owner: self) { [weak self] flag in
                guard let self = self else { return }
                
                print("changed: \(flag.key) to \(flag.newValue)")
                print("for \(ldKey)")
                switch flag.key {
                case LDKeys.testFlag.rawValue:
                    self.testFlag = client.boolVariation(forKey: flag.key, defaultValue: self.testFlag)
                    
                case LDKeys.LDMessage.rawValue:
                    self.ldMessage = client.stringVariation(forKey: flag.key, defaultValue: self.ldMessage)
                    
                case LDKeys.luckyNumber.rawValue:
                    self.luckyNumber = client.doubleVariation(forKey: flag.key, defaultValue: self.luckyNumber)

                default:
                    print("ignoring case: \(ldKey.rawValue)")
                }
            }
        }
    }
}
