//
//  Conference.swift
//  CCCtv
//
//  Created by Kris Simon on 10/12/15.
//  Copyright © 2015 aus der Technik. All rights reserved.
//

import Foundation
import CoreData
import Just
import SwiftyJSON

//  https://api.media.ccc.de/public/conferences

var allConferences: [Conference] = []

struct ConferenceResponse : Codable {
    var title: String
    var acronym: String
    var logo_url: URL
    var updated_at: Date
    var aspect_ratio: String
    var schedule_url: URL
    var images_url: URL
    var recordings_url: URL
    var webgen_location: String
    var slug: String
    var url: URL
}

public class Conference : NSManagedObject, Identifiable  {
    @NSManaged public var title: String
    @NSManaged public var acronym: String
    @NSManaged public var logo_url: URL
    @NSManaged public var updated_at: Date
    @NSManaged public var aspect_ratio: String
    @NSManaged public var schedule_url: URL
    @NSManaged public var images_url: URL
    @NSManaged public var recordings_url: URL
    @NSManaged public var webgen_location: String
    @NSManaged public var slug: String
    @NSManaged public var url: URL
}

//extension Conference {
//    static func getAllConferences() -> NSFetchRequest<Conference> {
//        let request : NSFetchRequest<Conference> = Conference.fetchRequest() as! NSFetchRequest<Conference>
//        let sortDiscriptor = NSSortDescriptor(key: "updated_at", ascending: true)
//        request.sortDescriptors = [sortDiscriptor]
//        return request
//    }
//
//    static func updateConferences() -> Void {
//        let conferences = JSON(Just.get("https://api.media.ccc.de/public/conferences").json)
//
//        for (_, v) in conferences["conferences"] {
//            allConferences.append(Conference()
//        }
//    }
//}
