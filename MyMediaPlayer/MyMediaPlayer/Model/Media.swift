//
//  Media.swift
//  MyMediaPlayer
//
//  Created by Ameer Shaikh on 04/07/2020.
//  Copyright © 2020 SAED. All rights reserved.
//

//   let media = try? newJSONDecoder().decode(Media.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseMedia { response in
//     if let Media = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - Media
class Media: Codable {
    let logoMin: String
    let id, topic: String
    let chapter: String
    let chapterurdu: String
    let content: String
    let slno, bookID, status, audioname: String
    let audionameurdu: String
    let url: String
    let bookname: String
    let chapterID, audioTag: String
    let booknameurdu: String
    let booksynopsysenglish, booksynopsysurdu: String
    let color: String

    enum CodingKeys: String, CodingKey {
        case logoMin = "logo_min"
        case id, topic, chapter, chapterurdu, content, slno
        case bookID = "book_id"
        case status, audioname, audionameurdu, url, bookname
        case chapterID = "chapter_id"
        case audioTag = "audio_tag"
        case booknameurdu, booksynopsysenglish, booksynopsysurdu, color
    }

    init(logoMin: String, id: String, topic: String, chapter: String, chapterurdu: String, content: String, slno: String, bookID: String, status: String, audioname: String, audionameurdu: String, url: String, bookname: String, chapterID: String, audioTag: String, booknameurdu: String, booksynopsysenglish: String, booksynopsysurdu: String, color: String) {
        self.logoMin = logoMin
        self.id = id
        self.topic = topic
        self.chapter = chapter
        self.chapterurdu = chapterurdu
        self.content = content
        self.slno = slno
        self.bookID = bookID
        self.status = status
        self.audioname = audioname
        self.audionameurdu = audionameurdu
        self.url = url
        self.bookname = bookname
        self.chapterID = chapterID
        self.audioTag = audioTag
        self.booknameurdu = booknameurdu
        self.booksynopsysenglish = booksynopsysenglish
        self.booksynopsysurdu = booksynopsysurdu
        self.color = color
    }
}


typealias MediaList = [Media]


