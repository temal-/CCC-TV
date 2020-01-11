//
//  ContentView.swift
//  CCCtv
//
//  Created by Malte Krupa on 11.01.20.
//  Copyright © 2020 aus der Technik. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @Environment(\.managedObjectContext) var managedObjectContext

    @FetchRequest(
        entity: Conference.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Conference.title, ascending: true)
        ]
    ) var languages: FetchedResults<Conference>

    var body: some View {

        VStack {
            List(languages, id: \.self) { language in
                Text(language.title)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
