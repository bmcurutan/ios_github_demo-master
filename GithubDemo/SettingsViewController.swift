//
//  SettingsViewController.swift
//  GithubDemo
//
//  Created by Bianca Curutan on 10/16/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var starsSlider: UISlider!
    @IBOutlet weak var languagesTableView: UITableView!
    
    var stars: Int?
    var doneHandler: ((Int?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.languagesTableView.isHidden = true
    }
    
    func numberOfStars() -> Int? {
        self.stars = Int(self.starsSlider.value * 200000)
        return Int(self.starsSlider.value * 200000)
    }
    
    @IBAction func doneButtonPressed(_ sender: AnyObject) {
        doneHandler?(numberOfStars())
    }

    @IBAction func cancelButtonPressed(_ sender: AnyObject) {
        doneHandler?(self.stars)
    }
    
    @IBAction func languageToggled(_ sender: AnyObject) {
        if let toggle = sender as? UISwitch {
            self.languagesTableView.isHidden = !toggle.isOn
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.languagesTableView.dequeueReusableCell(withIdentifier: "languageCell")
        cell?.textLabel?.text = languages.allKeys[indexPath.row] as? String
        return cell!
    }
}
