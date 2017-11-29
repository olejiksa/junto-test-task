//
//  Api.swift
//  ProductHunt
//
//  Created by Олег Самойлов on 28.11.2017.
//  Copyright © 2017 Олег Самойлов. All rights reserved.
//

import Foundation

class Api {
    private let domain = "https://api.producthunt.com/v1/"
    private let accessToken = "591f99547f569b05ba7d8777e2e0824eea16c440292cce1f8dfb3952cc9937ff"
    
    /// Gets an array of Topics.
    func getTopics() -> [Topic]? {
        var topics: [Topic]?
        
        guard let url = URL(string: "\(domain)topics?access_token=\(accessToken)") else {
            return nil
        }
        
        // To wait (see below)
        let group = DispatchGroup()
        group.enter()
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                topics = try JSONDecoder().decode(TopicResponse.self, from: data).topics
            } catch let jsonError {
                print(jsonError)
            }
            
            group.leave()
        }.resume()
        
        // Waits when elements will be retrieved before UI appears
        group.wait()
        
        return topics
    }
    
    /// Gets an array of Post elements by topic slug (URL).
    func getPosts(by topicSlug: String) -> [Post]? {
        var posts: [Post]?
        
        guard let url = URL(string: "\(domain)categories/\(topicSlug)/posts?access_token=\(accessToken)") else {
            return nil
        }
        
        // To wait (see below)
        let group = DispatchGroup()
        group.enter()
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            do {
                posts = try JSONDecoder().decode(Response.self, from: data).posts
            } catch let jsonError {
                print(jsonError)
            }
            group.leave()
        }.resume()
        
        // Waits when elements will be retrieved before UI appears
        group.wait()
        
        return posts
    }
}
