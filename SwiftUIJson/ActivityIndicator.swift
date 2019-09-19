//
//  ActivityIndicator.swift
//  SwiftUIJson
//
//  Created by Joseph Missamore on 9/19/19.
//  Copyright © 2019 Joseph Missamore. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    
    let style: UIActivityIndicatorView.Style
    
    func makeUIView(context: Context) -> UIActivityIndicatorView {
        return .init(style: style)
    }
    
    func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}


struct ActivityIndicatorView: View {
    var body: some View {
        ActivityIndicator(isAnimating: .constant(true), style: .large)
    }
}

struct ActivityIndicator_Previews: PreviewProvider {
    static var previews: some View {
        ActivityIndicatorView()
    }
}
