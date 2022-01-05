//
//  ViewController2.swift
//  joewgeorger-Lab4
//
//  Created by Joe Georger on 10/28/21.
//  Favorites page

import UIKit

class ViewController2: UIViewController,UITableViewDataSource, UITableViewDelegate ,UITabBarControllerDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    var data: [String] = []
    var ids:[Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("VC 2")
        dataFromPropertyList()
        table.dataSource = self
        table.delegate = self
        self.title = "Movie App"
        table.register(UITableViewCell.self, forCellReuseIdentifier: "favCell")
    }
    
//    updates the view on appear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.delegate = self
        dataFromPropertyList()
        table.reloadData()
    }
    
//    set up for tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let c = UITableViewCell(style: .default, reuseIdentifier: "favCell")
        c.textLabel!.text = data[indexPath.row]
        return c
    }
    
//  Pushes data from table cell to next View
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "Detail2") as! Detail2ViewController
        let index = table.indexPathForSelectedRow
        print(ids[index!.row])
        nextVC.mid = ids[index!.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
//    sets up swipe action for tabel cell: delete action
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Delete") { [weak self] (action, view, completionHandler) in self?.handleDelete(i: indexPath.row); completionHandler(true)
        }
        action.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [action])
    }
    
//    handles deleting movie from favorites
    private func handleDelete(i: Int) {
        print("deleted \(data[i])")
        let defaults = UserDefaults.standard
        var d = (defaults.array(forKey: "favData") ?? []) as! Array<String>
        var j = (defaults.array(forKey: "idData") ?? []) as! Array<Int>
        d.remove(at: i)
        j.remove(at: i)
        defaults.setValue(d, forKey: "favData")
        defaults.setValue(j, forKey: "idData")
        data = d
        table.reloadData()
    }
    
//    populates global arrays
    func dataFromPropertyList() {
        let defaults = UserDefaults.standard
        data = (defaults.array(forKey: "favData") ?? []) as! Array<String>
        ids = (defaults.array(forKey: "idData") ?? []) as! Array<Int>
    }
    
//
//     MARK: - Navigation
//
//     In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        print("yes")
//        if let destination = segue.destination as?
//            Detail2ViewController, let index =
//                table.indexPathForSelectedRow {
//            destination.name = data[(index.first)!]
//        }
//
//    }

}
