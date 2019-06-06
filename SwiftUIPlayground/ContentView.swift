//
//  ContentView.swift
//  SwiftUIPlayground
//
//  Created by Jonathan Willis on 6/6/19.
//  Copyright © 2019 Almost Free. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView : View {

    class ViewStore: BindableObject {
        var didChange = PassthroughSubject<ViewStore, Never>()

        let service: ViewService

        public init(service: ViewService) {
            self.service = service
        }

        var header = "Hello From:" {
            didSet {
                didChange.send(self)
            }
        }

        var subHeader = "The World" {
            didSet {
                didChange.send(self)
            }
        }

        var buttonText = "Press Me" {
            didSet {
                didChange.send(self)
            }
        }

        func doTheThing() {
            subHeader = "???"
            buttonText = "Pressing…"

            service.doTheThing { result in
                switch result {
                case .success(let subHeader):
                    self.subHeader = subHeader
                    self.buttonText = "You pressed me!"
                case .failure(let error):
                    self.subHeader = error.localizedDescription
                }
            }
        }
    }

    class ViewService {
        func doTheThing(_ handler: @escaping ((Result<String, Error>) -> Void)) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                handler(.success("The Other Side"))
            }
        }
    }

    @EnvironmentObject var store: ViewStore

    var body: some View {
        VStack {
            HStack {
                Text(store.header)
                Text(store.subHeader)
            }
            Button(action: store.doTheThing) {
                Text(store.buttonText)
            }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
