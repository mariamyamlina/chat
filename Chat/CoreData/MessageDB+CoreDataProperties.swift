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
    
    @objc var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: self.created)
    }

}
