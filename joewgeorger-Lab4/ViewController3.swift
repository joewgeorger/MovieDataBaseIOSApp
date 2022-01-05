//
//  ViewController3.swift
//  joewgeorger-Lab4
//
//  Created by Joe Georger on 10/28/21.
//  Detail movie veiw from collection view

import UIKit

class ViewController3: UIViewController,UIContextMenuInteractionDelegate {
    
    @IBOutlet weak var t: UILabel!
    @IBOutlet weak var r: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var favButton: UIButton!
    
    var movie: Int?
    var b = true
    var date: String?
    var name: String?
    var rating: Double?
    var sum: String?
    var ppath: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(movie!)
        print("VC 3")
//        fetchData()
        setFav()
        catchImages()
        setLabels()
        setButton()
        let interaction = UIContextMenuInteraction(delegate: self)
        desc.addInteraction(interaction)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("1")
        let defaults = UserDefaults.standard
        let d = (defaults.array(forKey: "favData") ?? []) as! Array<String>
        if d.contains(name!) {
            print("2")
            b = false
            favButton.backgroundColor = .systemBlue
            favButton.layer.borderColor = UIColor.systemBlue.cgColor
            favButton.setTitleColor(.white, for: .normal)
            favButton.setTitle("Favorited", for: .normal)
        }
        else{
            b = true
            favButton.backgroundColor = .clear
            favButton.layer.borderColor = UIColor.systemBlue.cgColor
            favButton.setTitleColor(.systemBlue, for: .normal)
            favButton.setTitle("Favorite", for: .normal)
        }
    }
    
//    3d touch code. Adapted from: https://www.fivestars.blog/articles/uicontextmenuinteraction/
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        print("configurationForMenuAtLocation")
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider: { [weak self] _ in return self?.makeContextMenu()})
            }

        private func makeContextMenu() -> UIMenu {
            let link = UIAction(title: "Go to Movie") { _ in if let url = URL(string: "https://www.themoviedb.org/movie/\(self.movie ?? 0)-\(self.name ?? " ")") {
                UIApplication.shared.open(url)
            }}

            return UIMenu(title: "Overview", image: nil, identifier: nil, children: [link])
    }
    
   
    
    //fetch new res image
    func catchImages() {
        if ppath == nil {
            img.image = (UIImage(named: "error")!)
        }
        else{
            let url = String("https://image.tmdb.org/t/p/w342" + ppath!)
            let iurl = URL(string: url)
            let data = try? Data(contentsOf: iurl!)
            if data != nil {
                let res = UIImage(data: data!)
                img.image = res
            }
            else{
                img.image = (UIImage(named: "error")!)
            }
        }
        
        
    }
    
    //set labels of vc
    func setLabels() {
        self.title = name
        t.text = "Date: \(date ?? "No Release Date")"
        r.text = "Rating \(rating ?? 0.0)"
        desc.text = "Movie Overview: \n" + (sum ?? "No Overview")
    }
    
    //code for button
    func setButton() {
        favButton.layer.cornerRadius = 5
        favButton.layer.borderWidth = 1
        if b {
            favButton.backgroundColor = .clear
            favButton.layer.borderColor = UIColor.systemBlue.cgColor
            favButton.setTitleColor(.systemBlue, for: .normal)
            favButton.setTitle("Favorite", for: .normal)
        }
        else{
            favButton.backgroundColor = .systemBlue
            favButton.layer.borderColor = UIColor.systemBlue.cgColor
            favButton.setTitleColor(.white, for: .normal)
            favButton.setTitle("Favorited", for: .normal)
        }
        
    }
    
//    handles the favorite button and saves movie data to userDefualts
    @IBAction func handleFav(_ sender: Any) {
        if b {
            b = false
            setButton()
            let defaults = UserDefaults.standard
            var d = (defaults.array(forKey: "favData") ?? []) as! Array<String>
            var j = (defaults.array(forKey: "idData") ?? []) as! Array<Int>
            if d.contains(name!) == false {
                d.append(name!)
                j.append(movie!)
                print(d)
                defaults.set(d, forKey: "favData")
                defaults.set(j, forKey: "idData")
            }
        }
        else{
            let defaults = UserDefaults.standard
            var d = (defaults.array(forKey: "favData") ?? []) as! Array<String>
            var j = (defaults.array(forKey: "idData") ?? []) as! Array<Int>
            let i = d.firstIndex(of: name!)!
            d.remove(at: i)
            j.remove(at: i)
            defaults.setValue(d, forKey: "favData")
            defaults.setValue(j, forKey: "idData")
            b = true
            setButton()
        }
    }
    
//    checks to see what state button should on load
    func setFav() {
        let defaults = UserDefaults.standard
        let d = (defaults.array(forKey: "favData") ?? []) as! Array<String>
        if d.contains(name!) {
            b = false
        }
        else{
            b = true
        }
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



