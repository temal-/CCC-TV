//
//  ConferencesExport.swift
//  CCCtv
//
//  Created by Kris Simon on 14/12/15.
//  Copyright © 2015 aus der Technik. All rights reserved.
//

import UIKit
import TVMLKit

@objc protocol ConferencesExportProtocol : JSExport {
    func getConferences(fn: JSValue) -> Array<Dictionary<String, String>>
    func eventsOfConference(url: NSString, fn: JSValue)
    func isCensored(guid: String) -> Bool
}


class ConferencesExport: NSObject, ConferencesExportProtocol {
    
    let downloader = Downloader()

    private func conferenceStructToObject() -> Array<Dictionary<String, String>> {
        var result: Array<Dictionary<String, String>>  = []
        for conference in allConferences {
            // Create variables beforehand to speed up type-check of compiler
            let title = conference.title
            let acronym = conference.acronym
            let logo_url = conference.logo_url.absoluteString
            let updated_at = DateFormatter.localizedString(from: conference.updated_at as Date, dateStyle: .medium, timeStyle: .medium)
            let aspect_ratio = conference.aspect_ratio
            let schedule_url = conference.schedule_url.absoluteString
            let images_url = conference.images_url.absoluteString
            let recordings_url = (conference.recordings_url?.absoluteString) ?? ""
            let webgen_location = conference.webgen_location
            let slug = conference.slug
            let url = conference.url.absoluteString

            result.append(
                Dictionary(dictionaryLiteral:
                    ("title", title),
                    ("acronym", acronym),
                    ("logo_url", logo_url),
                    ("updated_at", updated_at),
                    ("aspect_ratio", aspect_ratio),
                    ("schedule_url", schedule_url),
                    ("images_url", images_url),
                    ("recordings_url", recordings_url),
                    ("webgen_location", webgen_location),
                    ("slug", slug),
                    ("url", url)
                ) as! [String : String]
            )
        }

        return result
    }
    
    private func eventStructToObject(withEventId eventId: Int) -> Array<Dictionary<String, String>> {
        var result: Array<Dictionary<String, String>> = []
        let eventList = allEvents[eventId]
        if let eventList = eventList {
        for event in eventList {
            // Create variables beforehand to speed up type-check of compiler
            let title = event.title
            let subtitle =  event.subtitle
            let description =  event.description
            let length =  "\(event.length)"
            let tags =  event.tags.joined(separator: ",")
            let persons =  event.tags.joined(separator: ",")
            let slug =  event.slug
            let guid =  event.guid
            let url =  event.url.absoluteString
            let link =  (event.link?.absoluteString) ?? ""
            let frontend_link =  (event.frontend_link?.absoluteString) ?? ""
            let date =  DateFormatter.localizedString(from: (event.date ) as Date, dateStyle: .medium, timeStyle: .medium)
            let release_date =  DateFormatter.localizedString(from: (event.release_date ?? NSDate()) as Date, dateStyle: .medium, timeStyle: .medium)
            let updated_at =  DateFormatter.localizedString(from: event.updated_at! as Date, dateStyle: .medium, timeStyle: .medium)
            let poster_url =  (event.poster_url?.absoluteString) ?? ""
            let thumb_url =  (event.thumb_url?.absoluteString) ?? ""
            let conference_url =  (event.conference_url?.absoluteString) ?? ""

            result.append(
                Dictionary(dictionaryLiteral:
                    ("title", title),
                    ("subtitle", subtitle),
                    ("description", description),
                    ("length", length),
                    ("tags", tags),
                    ("persons", persons),
                    ("slug", slug),
                    ("guid", guid),
                    ("url", url ?? ""),
                    ("link", link),
                    ("frontend_link", frontend_link),
                    ("date", date),
                    ("release_date", release_date),
                    ("updated_at", updated_at),
                    ("poster_url", poster_url),
                    ("thumb_url", thumb_url),
                    ("conference_url", conference_url)
                )
            )
        }
        }
        return result
    }
    
    func getConferences(fn: JSValue) -> Array<Dictionary<String, String>> {
        if(allConferences.count > 0){
            let conferences = conferenceStructToObject()
            //fn.callWithArguments(conferences)
            return conferences
        } else {
            downloader.performDownload(){
                globalJsContext?.evaluateScript("updateUI();")
                let conferences = self.conferenceStructToObject()
                fn.call(withArguments: conferences)
            }
            return Array(arrayLiteral: Dictionary())
        }
    }
    
    func eventsOfConference(url id: NSString, fn: JSValue){
        if(allEvents.count > 0){
            print("# events from the cahce")
            let events = self.eventStructToObject(withEventId: Int(id as String)!)
            
            NSLog("events length \(events.count)");
            fn.call(withArguments: events)

        } else {
            let eventsDownloader = DownloadEventsOperation(eventId: Int(id as String)!)
            
            eventsDownloader.completionBlock = {
                print("# eventsDownloader finish")
                let events = self.eventStructToObject(withEventId: Int(id as String)!)
                
                NSLog("events length \(events.count)");
                fn.call(withArguments: events)
                //globalJsContext?.evaluateScript("Presenter.addVideoItem("+(id as String)+");")
            }
            downloadQueue.addOperation(eventsDownloader)
        }
    }
    
    func isCensored(guid: String) -> Bool {
        return censoredEventList.filter({$0.guid == guid}).count > 0
    }
}

 
