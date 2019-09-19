//
//  NetworkManager.swift
//  SwiftUIJson
//
//  Created by Joseph Missamore on 9/18/19.
//  Copyright © 2019 Joseph Missamore. All rights reserved.
//

import SwiftUI

final class NetworkManager: ObservableObject {
    
    @Published var courses = [Course]()
    
    func loadData() {
        guard let url = URL(string: "https://api.letsbuildthatapp.com/jsondecodable/courses") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else {return}

            let courses = try! JSONDecoder().decode([Course].self, from: data)
            DispatchQueue.main.async {
                self.courses = courses
            }

        }.resume()
    }
    
    static var example: NetworkManager {
        
        let appStoreCourse = Course(
            id: 1,
            name: "App Store",
            imageUrl: "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/bc5a4091-d2ea-44ab-b749-5f2ee5354c35_medium"
        )
        
        
        
        let tinderFireStoreCourse = Course (
            id: 2,
            name: "Tinder Firestore Swipe and Match",
            imageUrl: "https://letsbuildthatapp-videos.s3-us-west-2.amazonaws.com/04782e30-d72a-4917-9d7a-c862226e0a93"
        )

        let networkManager = NetworkManager()
        networkManager.courses = [appStoreCourse, tinderFireStoreCourse]
        return networkManager
    }
}
