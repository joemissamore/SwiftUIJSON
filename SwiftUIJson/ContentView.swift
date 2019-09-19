//
//  ContentView.swift
//  SwiftUIJson
//
//  Created by Joseph Missamore on 9/18/19.
//  Copyright © 2019 Joseph Missamore. All rights reserved.
//

import SwiftUI
import Combine

struct ContentView: View {

    @EnvironmentObject var networkManager: NetworkManager

    var body: some View {
        NavigationView {
            List {
                ForEach(networkManager.courses) {
                    CourseRowView(course: $0)

                }
            }.navigationBarTitle(Text("Courses"))
        }
    }
}

struct CourseRowView: View {
    let course: Course
    
    var body: some View {
        
        VStack(alignment: .leading) {
            ImageViewContainer(imageUrl: course.imageUrl)
                .frame(height: 180)

            Text(course.name)
        }
    }
}

struct ImageViewContainer: View {

    @ObservedObject var imageLoader: ImageLoader

    init(imageUrl: String) {
        self.imageLoader = ImageLoader(imageUrl: imageUrl)
    }
    
    func createView(geometry: GeometryProxy) -> some View {
        
        if !self.imageLoader.imageData.isEmpty {
            return AnyView (
                Image(uiImage: UIImage(data: self.imageLoader.imageData)!)
                    .resizable()
                    
            )
        }
        
            
        return AnyView (
            ActivityIndicatorView()
                .frame(
                    width: geometry.size.width,
                    height: geometry.size.height,
                    alignment: .center)
        )
        
        
    }

    var body: some View {
        GeometryReader { geometry in
            self.createView(geometry: geometry)
        }
    }
}

final class ImageLoader: ObservableObject {
    @Published var imageData = Data()

    init(imageUrl: String) {
        loadImage(imageUrl: imageUrl)
    }

    func loadImage(imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in

            guard let data = data else { return }
            
            /**
             
            DispatchQueue.main.async {
                self.imageData = data
            }
             
             */
            
            
            /// Simulating a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.imageData = data
            }

        }.resume()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView().environmentObject(NetworkManager.example)
    }
}
