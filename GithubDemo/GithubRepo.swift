//
//  GithubRepo.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import Foundation
import AFNetworking

private let reposUrl = "https://api.github.com/search/repositories"
private let clientId: String? = nil
private let clientSecret: String? = nil
var languages: NSDictionary = NSMutableDictionary()

// Model class that represents a GitHub repository
class GithubRepo: CustomStringConvertible {

    var name: String?
    var ownerHandle: String?
    var ownerAvatarURL: String?
    var stars: Int?
    var forks: Int?
    var repoDescription: String?
    var language: String?
    
    // Initializes a GitHubRepo from a JSON dictionary
    init(jsonResult: NSDictionary) {
        if let name = jsonResult["name"] as? String {
            self.name = name
        }
        
        if let stars = jsonResult["stargazers_count"] as? Int? {
            self.stars = stars
        }
        
        if let forks = jsonResult["forks_count"] as? Int? {
            self.forks = forks
        }
        
        if let owner = jsonResult["owner"] as? NSDictionary {
            if let ownerHandle = owner["login"] as? String {
                self.ownerHandle = ownerHandle
            }
            if let ownerAvatarURL = owner["avatar_url"] as? String {
                self.ownerAvatarURL = ownerAvatarURL
            }
        }
        
        if let description = jsonResult["description"] as? String {
            self.repoDescription = description
        }
        
        if let language = jsonResult["language"] as? String {
            self.language = language
        }
    }
    
    // Actually fetch the list of repositories from the GitHub API.
    // Calls successCallback(...) if the request is successful
    class func fetchRepos(_ settings: GithubRepoSearchSettings, successCallback: @escaping ([GithubRepo]) -> Void, error: ((NSError?) -> Void)?) {
        let manager = AFHTTPRequestOperationManager()
        let params = queryParamsWithSettings(settings);
        
        manager.get(reposUrl, parameters: params, success: { (operation ,response) -> Void in
            if let responseObject = response as? NSDictionary {
                if let results = responseObject["items"] as? NSArray {
                    var repos: [GithubRepo] = []
                    for result in results as! [NSDictionary] {
                        let repo = GithubRepo(jsonResult: result)
                        repos.append(repo)
                        if let language = repo.language {
                            languages.setValue(false, forKey: language)
                        }
                    }
                    successCallback(repos)
                }
            }
        }, failure: { (operation, requestError) -> Void in
            if let errorCallback = error {
                errorCallback(requestError as NSError?)
            }
        })
    }
    
    // Helper method that constructs a dictionary of the query parameters used in the request to the
    // GitHub API
    fileprivate class func queryParamsWithSettings(_ settings: GithubRepoSearchSettings) -> [String: String] {
        var params: [String:String] = [:];
        if let clientId = clientId {
            params["client_id"] = clientId;
        }
        
        if let clientSecret = clientSecret {
            params["client_secret"] = clientSecret;
        }
        
        var q = "";
        var langs = String()
        for key in languages.allKeys {
            if true == languages.value(forKey: key as! String) as! Bool {
                langs += "+language:\(key)"
            }
        }
        if 0 < langs.characters.count {
            langs.remove(at: langs.startIndex)
        }
        q += langs
        
        if let searchString = settings.searchString {
            q = q + searchString;
        }
        q = q + " stars:>\(settings.minStars)";
        
        params["q"] = q
        
        params["sort"] = "stars";
        params["order"] = "desc";
        
        return params;
    }

    // Creates a text representation of a GitHub repo
    var description: String {
        let language = nil != self.language ? self.language : ""
        return "[Name: \(self.name!)]" +
            "\n\t[Stars: \(self.stars!)]" +
            "\n\t[Forks: \(self.forks!)]" +
            "\n\t[Owner: \(self.ownerHandle!)]" +
            "\n\t[Avatar: \(self.ownerAvatarURL!)]" +
            "\n\t[Description: \(self.repoDescription!)]" +
            "\n\t[Language: \(language)]"
    }
}
