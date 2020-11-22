//
//  Contentful.swift
//  Albedo
//
//  Created by Simon Müller on 22.11.20.
//

import SwiftUI
import Contentful
import Combine

struct ContentfulView: View {
    var body: some View {
        Text("Test Contentful").onAppear {
            self.getArray(typeId: "person") {items in
                print(items)
            }
        }
    }
    func getArray(typeId: String, completion: @escaping([Entry]) -> ()) {
        let client = Client(spaceId: "m9bx0k4x0bj8",
                            accessToken: "hQImfhppVvqnxuVVxJCcY0mPWYLnUsnqm8RYQoieZRg")
        let query = Query.where(contentTypeId: typeId)
        
        client.fetchArray(of: Entry.self, matching: query) { result in
            switch result {
            case .success(let array):
                print(array)
                print(array.items.first?.fields ?? "blabla")
                DispatchQueue.main.async {
                    completion(array.items)
                }
            case .failure(let error):
                print(error)
            }
        }.resume()
    }
}

struct ContentfulView_Previews: PreviewProvider {
    static var previews: some View {
        ContentfulView()
    }
}




