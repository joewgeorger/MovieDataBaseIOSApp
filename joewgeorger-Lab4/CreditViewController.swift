//
//  CreditViewController.swift
//  joewgeorger-Lab4
//
//  Created by Joe Georger on 10/31/21.
// credit page

import UIKit

class CreditViewController: UIViewController {

    @IBOutlet weak var linkButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
//    takes user to tmdb home page
    @IBAction func goAway(_ sender: Any) {
        if let url = URL(string: "https://www.themoviedb.org/") {
            UIApplication.shared.open(url)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
