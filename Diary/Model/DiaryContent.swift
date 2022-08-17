//
//  DiaryContent.swift
//  Diary
//
//  Created by Hugh, Derrick on 2022/08/16.
//

import Foundation

struct DiaryContent: Decodable, Hashable {
    let id = UUID()
    var title: String
    var body: String
    let createdAt: Double
}
