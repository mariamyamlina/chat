//
//  MessageDB+CoreDataProperties.swift
//  
//
//  Created by Maria Myamlina on 25.10.2020.
//
//

import Foundation
import CoreData

extension MessageDB {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageDB> {
        return NSFetchRequest<MessageDB>(entityName: "Message")
    }

    @NSManaged public var identifier: String
    @NSManaged public var content: String
    @NSManaged public var created: Date
    @NSManaged public var senderId: String
    @NSManaged public var senderName: String
    @NSManaged public var channel: ChannelDB?
}

extension MessageDB {
    @objc var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self.created)
    }

    convenience init(identifier: String,
                     content: String,
                     created: Date,
                     senderId: String,
                     senderName: String,
                     in context: NSManagedObjectContext) {
        self.init(context: context)
        self.identifier = identifier
        self.content = content
        self.created = created
        self.senderId = senderId
        self.senderName = senderName
    }
    
    var about: String {
        let text = content.replacingOccurrences(of: "\n", with: "\n\t\t\t\t\t" + " ")
        return "message: '\(text)'"
    }
}
