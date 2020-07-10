//
//  ServerCommunication.swift
//  MyMediaPlayer
//
//  Created by Ameer Shaikh on 04/07/2020.
//  Copyright © 2020 SAED. All rights reserved.
//

import Foundation
import Alamofire

class ServerCommunication : NSObject {
    
    static func chapterContents(chapterID :String, completion: @escaping (_ mediaArray:MediaList?) -> Void ) {
       // https://islamicaudiobooks.info/audioapp/index.php/api/audio?chapter_id=125
        let url = "https://islamicaudiobooks.info/audioapp/index.php/api/audio"
        let parameters: [String: String] = ["chapter_id": chapterID]
        AF.request(url, parameters: parameters)
          .validate()
          .responseDecodable(of: MediaList.self) { response in
            guard let mediaData = response.value else {
                print("Exception Occured")
                completion([])
                return }
            print("**** My Media data ****")
            for media in mediaData {
                print(media.audioname)
            }
            completion(mediaData)
        }
        
    }
}
