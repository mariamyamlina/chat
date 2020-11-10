//
//  FirebaseService.swift
//  Chat
//
//  Created by Maria Myamlina on 10.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation

protocol FirebaseServiceProtocol {
    var universallyUniqueIdentifier: String { get }
    
    func getChannels(errorHandler: @escaping (String?, String?) -> Void)
    func addChannelsListener(errorHandler: @escaping (String?, String?) -> Void)
    func removeChannelsListener()
    func create(channel name: String)
    func delete(channel id: String)
    
    func getMessages(in channel: Channel, errorHandler: @escaping (String?, String?) -> Void)
    func addMessagesListener(in channel: Channel, errorHandler: @escaping (String?, String?) -> Void)
    func removeMessagesListener()
    func create(message text: String, in channel: Channel)
}

class FirebaseService: FirebaseServiceProtocol {
    let firebaseManager: FirebaseManagerProtocol
    let serviceAssembly: ServicesAssembly
    var universallyUniqueIdentifier: String
    
    // MARK: - Init / deinit

    init(firebaseManager: FirebaseManagerProtocol, serviceAssembly: ServicesAssembly) {
        self.firebaseManager = firebaseManager
        self.serviceAssembly = serviceAssembly
        self.universallyUniqueIdentifier = firebaseManager.universallyUniqueIdentifier
    }
    
    func getChannels(errorHandler: @escaping (String?, String?) -> Void) {
        firebaseManager.getChannels(completion: { [weak self] channels in
                self?.serviceAssembly.coreDataService.save(channels: channels, errorHandler: errorHandler)
                self?.addChannelsListener(errorHandler: errorHandler)},
                                    errorHandler: errorHandler)
    }
    
    func addChannelsListener(errorHandler: @escaping (String?, String?) -> Void) {
        firebaseManager.addChannelsListener(completion: { [weak self] (type, channel) in
                if type == .added { self?.serviceAssembly.coreDataService.save(channel: channel, errorHandler: errorHandler) }
                if type == .modified { self?.serviceAssembly.coreDataService.update(channel: channel, errorHandler: errorHandler) }
                if type == .removed { self?.serviceAssembly.coreDataService.delete(channel: channel, errorHandler: errorHandler) }},
                                            errorHandler: errorHandler)
    }
    
    func removeChannelsListener() {
        firebaseManager.removeChannelsListener()
    }
    
    func create(channel name: String) {
        firebaseManager.create(channel: name)
    }
    
    func delete(channel id: String) {
        firebaseManager.delete(channel: id)
    }
    
    func getMessages(in channel: Channel, errorHandler: @escaping (String?, String?) -> Void) {
        firebaseManager.getMessages(in: channel, completion: { [weak self] messages in
                self?.serviceAssembly.coreDataService.save(messages: messages, inChannel: channel, errorHandler: errorHandler)
                self?.addMessagesListener(in: channel, errorHandler: errorHandler)},
                                    errorHandler: errorHandler)
    }
    
    func addMessagesListener(in channel: Channel, errorHandler: @escaping (String?, String?) -> Void) {
        firebaseManager.addMessagesListener(in: channel, completion: { [weak self] (type, message) in
                if type == .added { self?.serviceAssembly.coreDataService.save(message: message, inChannel: channel, errorHandler: errorHandler) }
                if type == .modified { }
                if type == .removed { }},
                                            errorHandler: errorHandler)
    }
    
    func removeMessagesListener() {
        firebaseManager.removeMessagesListener()
    }
    
    func create(message text: String, in channel: Channel) {
        firebaseManager.create(message: text, in: channel)
    }
}
