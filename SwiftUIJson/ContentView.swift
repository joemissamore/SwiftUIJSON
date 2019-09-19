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
    
    var activityIndicator: some View {
        ActivityIndicator(isAnimating: .constant(true), style: .large)
    }
    
    var errorView: some View {
        /// Error Image
        Image(systemName: "exclamationmark")
            .resizable()
            .scaledToFit()
            .foregroundColor(.blue)
            .animation(.easeInOut)

    }
    
    var loadedImage: some View {
        Image(uiImage: UIImage(data: imageLoader.imageData!)!)
            .resizable()
            .animation(.easeInOut)
    }

    var body: some View {
        /**
         This VStack isn't necessary for the layout, but **is** necessary
         for the animation to take place. Without it you will get the following error:
         
            ```
            Function declares an opaque return type,
            but has no return statements in its body
            from which to infer an underlying type
            ```
         
         You can return `AnyView`, but it **wont** render the animation:
                
            ```
            if imageLoader.imageData.isEmpty {
                return AnyView(activityIndicator)
            }
             
            return AnyView(loadedImage)
            ```
         
         You can *try* to return `AnyView` with the animation:
         
            ```
            AnyView(loadedImage).animate(.someAnimation) // gets same error as above
            ```
         
         */
        VStack {
            if imageLoader.errorOccurred {
                errorView
            }
            else if imageLoader.imageData == nil {
                activityIndicator
            }
            else {
                loadedImage
            }
        }
        /** Guarantees the parent container will be filled */
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        )
    }
}

final class ImageLoader: ObservableObject {
    @Published var errorOccurred = false
    @Published var imageData: Data?
    
    init(imageUrl: String) {
        loadImage(imageUrl: imageUrl)
    }

    func loadImage(imageUrl: String) {
        guard let url = URL(string: imageUrl) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    self.errorOccurred = true
                }
                
                return
            }
            
            if let data = data {
                /**

                DispatchQueue.main.async {
                    self.imageData = data
                }

                 */

                /// Simulating a delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    self.imageData = data
                }
            }

        }.resume()
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        return ContentView().environmentObject(NetworkManager.example)
    }
}
