//
//  ChannelDB+CoreDataProperties.swift
//  
//
//  Created by Maria Myamlina on 25.10.2020.
//
//

import Foundation
import CoreData

extension ChannelDB {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChannelDB> {
        return NSFetchRequest<ChannelDB>(entityName: "Channel")
    }

    @NSManaged public var identifier: String
    @NSManaged public var lastActivity: Date?
    @NSManaged public var lastMessage: String?
    @NSManaged public var name: String
    @NSManaged public var messages: NSSet?
    @NSManaged public var profileImage: Data?
}

// MARK: Generated accessors for messages
extension ChannelDB {
    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageDB)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageDB)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)
}

extension ChannelDB {
    convenience init(identifier: String,
                     name: String,
                     lastMessage: String?,
                     lastActivity: Date?,
                     profileImage: Data?,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.name = name
        self.lastMessage = lastMessage
        self.lastActivity = lastActivity
        self.profileImage = profileImage
    }
    
    var about: String {
        let description = "Channel's '\(name)' info. \n"
        let count = self.messages?.allObjects.count ?? 0
        var messageCount: String = ""
        switch count {
        case 0:
            messageCount = "This channel is still empty. \n"
        case 1:
            messageCount = "This channel has \(count) message. \n"
        default:
            messageCount = "This channel has \(count) messages. \n"
        }
        let messages = self.messages?.allObjects
            .compactMap { $0 as? MessageDB }
            .map { "\t\t\t\($0.about)" }
            .joined(separator: "\n") ?? ""

        return description + messageCount + messages
    }
}
