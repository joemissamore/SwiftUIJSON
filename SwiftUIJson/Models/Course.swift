//
//  Course.swift
//  SwiftUIJson
//
//  Created by Joseph Missamore on 9/19/19.
//  Copyright © 2019 Joseph Missamore. All rights reserved.
//

struct Course: Decodable, Identifiable {
    let id: Int
    let name, imageUrl: String
}
