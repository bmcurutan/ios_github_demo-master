//
//  SettingsViewController.swift
//  GithubDemo
//
//  Created by Bianca Curutan on 10/16/16.
//  Copyright © 2016 codepath. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var starsSlider: UISlider!
    
    var stars: Int?
    var doneHandler: ((Int?) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
