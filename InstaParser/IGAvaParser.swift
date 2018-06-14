//
//  IGAvaParser.swift
//  InstaParser
//
//  Created by Timur Mukhtasibov on 14.06.2018.
//  Copyright © 2018 EventrLLC. All rights reserved.
//

import Foundation

class IGAvaParser {
    
    public static func parseInstaAvatarFor(accountName name: String, completion: @escaping ((String?, String?) -> Void)) {
        
        var errorString: String?
        let baseUrl = "https://instagram.com/\(name)/"
        let errorAccountNotFound = "Error: \(name) seems to be invalid account name. Check and try."
        
        func getUserId() -> (String?, String?) {
            guard let url = URL(string: baseUrl) else {
                print("Error: Invalid URL")
                return (nil, "Invalid URL")
            }
            
            var htmlStr: String = ""
            do {
                htmlStr = try String(contentsOf: url, encoding: .ascii)
            } catch let error {
                print("Error: \(error)")
                return (nil, error.localizedDescription)
            }
            
            let start = "<script type=\"text/javascript\">window._sharedData = "
            let startIndex = htmlStr.range(of: start)?.upperBound
            htmlStr = String(htmlStr[startIndex!...])
            let end = "</script>"
            let endIndex = htmlStr.range(of: end)?.lowerBound
            htmlStr = String(htmlStr[..<endIndex!])
            let extEnd = "}"
            let extEndIndex = htmlStr.range(of: extEnd, options: .backwards)?.upperBound
            htmlStr = String(htmlStr[..<extEndIndex!])
            
            var rawJson: [String: Any]?
            if let data = htmlStr.data(using: .utf8) {
                do {
                    rawJson = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            guard let json = rawJson, let entryData = json["entry_data"] as? [String: Any],
                let profilePage = entryData["ProfilePage"] as? [[String: Any]] else {
                    print("Profile page not found")
                    return (nil, "Profile page not found")
            }
            
            var id: String?
            profilePage.forEach {
                if let dict = $0["graphql"] as? [String: Any], let user = dict["user"] as? [String: Any], let userId = user["id"] as? String {
                    id = userId
                    return
                } else {
                    return
                }
            }
            
            return (id, errorString)
        }
        
        let idWithSomeError = getUserId()
        let errorAnswer = getUserId().1
        guard let id = idWithSomeError.0, let url = URL(string: "https://i.instagram.com/api/v1/users/\(id)/info/") else {
            DispatchQueue.main.async { completion(nil, errorAnswer) }
            return
        }
        print("ID = \(id)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data, let rawJSON = try? JSONSerialization.jsonObject(with: data), let json = rawJSON as? [String: Any] {
                
                guard let userDict = json["user"] as? [String: Any],
                    let hdProfile = userDict["hd_profile_pic_url_info"] as? [String: Any],
                    let avatarUrlStr = hdProfile["url"] as? String else {
                        print("Avatar not found")
                        DispatchQueue.main.async { completion(nil, "Avatar not found") }
                        return
                }
                DispatchQueue.main.async { completion(avatarUrlStr, nil) }
            } else {
                DispatchQueue.main.async { completion(nil, error?.localizedDescription) }
            }
        }
        task.resume()
    }
    
}
