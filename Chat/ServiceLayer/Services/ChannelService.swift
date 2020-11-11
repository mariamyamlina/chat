//
//  ChannelService.swift
//  Chat
//
//  Created by Maria Myamlina on 10.11.2020.
//  Copyright © 2020 Maria Myamlina. All rights reserved.
//

import Foundation
import Firebase
import CoreData

protocol ChannelServiceProtocol {
//    func getFRC<T: NSManagedObject>() -> NSFetchedResultsController<T>
    func getChannels(errorHandler: @escaping (String?, String?) -> Void)
    func addListener(errorHandler: @escaping (String?, String?) -> Void)
    func removeListener()
    func create(channel name: String)
    func delete(channel id: String)
}

class ChannelService {
    let coreDataStack: CoreDataStackProtocol
    let firebaseManager: FirebaseManagerProtocol
    
    // MARK: - Init / deinit
    init(coreDataStack: CoreDataStackProtocol, firebaseManager: FirebaseManagerProtocol) {
        self.coreDataStack = coreDataStack
        self.firebaseManager = firebaseManager
    }
    
    // MARK: - Save
    private func save(channels: [Channel],
                      errorHandler: @escaping (String?, String?) -> Void) {
        coreDataStack.performSave { [weak self] context in
            for channel in channels {
                let channelFromDB = coreDataStack.load(channel: channel.identifier, from: context, errorHandler: errorHandler)
                if channelFromDB == nil {
                    let channelDB = ChannelDB(identifier: channel.identifier,
                                  name: channel.name,
                                  lastMessage: channel.lastMessage,
                                  lastActivity: channel.lastActivity,
                                  profileImage: channel.profileImage?.jpegData(compressionQuality: 1.0),
                                  in: context)
                    do {
                        try context.obtainPermanentIDs(for: [channelDB])
                    } catch {
                        errorHandler("CoreData", error.localizedDescription)
                    }
                } else {
                    if channelFromDB?.lastActivity != channel.lastActivity || channelFromDB?.lastMessage != channel.lastMessage {
                        channelFromDB?.lastActivity = channel.lastActivity
                        channelFromDB?.lastMessage = channel.lastMessage
                    }

                    continue
                }
            }

            self?.delete(compareWithChannels: channels, errorHandler: errorHandler)
        }
    }
    
    private func save(channel: Channel,
                      errorHandler: @escaping (String?, String?) -> Void) {
        coreDataStack.performSave { context in
            guard coreDataStack.load(channel: channel.identifier, from: context, errorHandler: errorHandler) == nil else { return }
            let channelDB = ChannelDB(identifier: channel.identifier,
                          name: channel.name,
                          lastMessage: channel.lastMessage,
                          lastActivity: channel.lastActivity,
                          profileImage: channel.profileImage?.jpegData(compressionQuality: 1.0),
                          in: context)
            do {
                try context.obtainPermanentIDs(for: [channelDB])
            } catch {
                errorHandler("CoreData", error.localizedDescription)
            }
        }
    }
    
    // MARK: - Update
    private func update(channel: Channel,
                        errorHandler: @escaping (String?, String?) -> Void) {
        coreDataStack.performSave { context in
            guard let channelFromDB = coreDataStack.load(channel: channel.identifier, from: context, errorHandler: errorHandler) else { return }
            if channelFromDB.lastActivity != channel.lastActivity && channelFromDB.lastMessage != channel.lastMessage {
                channelFromDB.lastActivity = channel.lastActivity
                channelFromDB.lastMessage = channel.lastMessage
            }
        }
    }
    
    // MARK: - Delete
    private func delete(compareWithChannels channels: [Channel],
                        errorHandler: @escaping (String?, String?) -> Void) {
        coreDataStack.performSave { context in
            coreDataStack.arrayDifference(entityType: .channel, predicate: nil, arrayOfEntities: channels, in: context, errorHandler: errorHandler).forEach {
                let fetchRequest = coreDataStack.fetchRequest(for: .channel, with: $0)
                do {
                    let channelDB = try context.fetch(fetchRequest).first as? ChannelDB
                    guard let channel = channelDB else { return }
                    let object = context.object(with: channel.objectID)
                    context.delete(object)
                } catch {
                    errorHandler("CoreData", error.localizedDescription)
                }
            }
        }
    }
    
    private func delete(channel: Channel,
                        errorHandler: @escaping (String?, String?) -> Void) {
        coreDataStack.performSave { context in
            guard let channelFromDB = coreDataStack.load(channel: channel.identifier, from: context, errorHandler: errorHandler) else { return }
            let object = context.object(with: channelFromDB.objectID)
            context.delete(object)
        }
    }
}

// MARK: - ChannelServiceProtocol
extension ChannelService: ChannelServiceProtocol {
    func getChannels(errorHandler: @escaping (String?, String?) -> Void) {
        firebaseManager.getChannels(completion: { [weak self] channels in
            self?.save(channels: channels, errorHandler: errorHandler)
            self?.addListener(errorHandler: errorHandler)},
                                    errorHandler: errorHandler)
    }
    
    func addListener(errorHandler: @escaping (String?, String?) -> Void) {
        firebaseManager.addChannelsListener(completion: { [weak self] (type, channel) in
            self?.handleChanges(ofType: type, channel: channel, errorHandler: errorHandler)},
                                            errorHandler: errorHandler)
    }
    
    func removeListener() {
        firebaseManager.removeChannelsListener()
    }
    
    func create(channel name: String) {
        firebaseManager.create(channel: name)
    }
    
    func delete(channel id: String) {
        firebaseManager.delete(channel: id)
    }
    
    private func handleChanges(ofType type: DocumentChangeType, channel: Channel, errorHandler: @escaping (String?, String?) -> Void) {
        if type == .added {
            self.save(channel: channel, errorHandler: errorHandler)
        }
        if type == .modified {
            self.update(channel: channel, errorHandler: errorHandler)
        }
        if type == .removed {
            self.delete(channel: channel, errorHandler: errorHandler)
        }
    }
}
