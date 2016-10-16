//
//  ViewController.swift
//  GithubDemo
//
//  Created by Nhan Nguyen on 5/12/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

import UIKit
import MBProgressHUD

// Main ViewController
class RepoResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var repoTableView: UITableView!
    
    var searchBar: UISearchBar!
    var searchSettings = GithubRepoSearchSettings()

    var repos: [GithubRepo]!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize the UISearchBar
        searchBar = UISearchBar()
        searchBar.delegate = self

        // Add SearchBar to the NavigationBar
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar

        // Perform the first search when the view controller first loads
        doSearch()
        
        // Resize rows
        self.repoTableView.estimatedRowHeight = 100
        self.repoTableView.rowHeight = UITableViewAutomaticDimension
    }

    // Perform the search.
    fileprivate func doSearch() {

        MBProgressHUD.showAdded(to: self.view, animated: true)

        // Perform request to GitHub API to get the list of repositories
        GithubRepo.fetchRepos(searchSettings, successCallback: { (newRepos) -> Void in
            self.repos = newRepos
            
            // Print the returned repositories to the output window
            for repo in newRepos {
                print(repo)
            }
            
            self.repoTableView.reloadData()

            MBProgressHUD.hide(for: self.view, animated: true)
            }, error: { (error) -> Void in
                print(error)
        })
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let repos = self.repos {
            return repos.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repo = self.repos[indexPath.row]
        let cell = self.repoTableView.dequeueReusableCell(withIdentifier: "repoCell") as! RepoTableViewCell
        
        let url = NSURL(string: repo.ownerAvatarURL!)
        cell.avatarImageView.setImageWith(url as! URL)
        
        cell.nameLabel.text = repo.name! as String
        cell.ownerLabel.text = repo.ownerHandle! as String
        cell.starsLabel.text = String(describing: repo.stars!)
        cell.forksLabel.text = String(describing: repo.forks!)
        cell.descriptionLabel.text = repo.repoDescription
        cell.languageLabel.text = repo.language
        
        return cell
    }

    // MARK: - Settings
    
    @IBAction func settingsButtonPressed(_ sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let settingsViewController = storyboard.instantiateViewController(withIdentifier: "settingsViewController") as! SettingsViewController
        settingsViewController.doneHandler = { (stars: Int?) -> Void in
            self.minStarsFilter(stars: stars)
        }
        present(settingsViewController, animated: true, completion: nil)
    }
        
    func minStarsFilter(stars: Int?) {
        print("Minimum number of stars: \(stars)")
        dismiss(animated: true, completion: nil)
        if let minStars = stars {
            searchSettings.minStars = minStars
        }
        doSearch()
    }
}

// SearchBar methods
extension RepoResultsViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchSettings.searchString = searchBar.text
        searchBar.resignFirstResponder()
        doSearch()
    }
}

