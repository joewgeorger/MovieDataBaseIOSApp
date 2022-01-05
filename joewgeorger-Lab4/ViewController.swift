//
//  ViewController.swift
//  joewgeorger-Lab4
//
//  Created by Joe Georger on 10/28/21.
// collection view page / homw view

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var cv: UICollectionView!
    @IBOutlet weak var search: UISearchBar!
        
    var theData: [Movie] = []
    var movieImageCache: [UIImage] = []
    
    struct APIResults:Decodable {
            let page: Int
            let total_results: Int
            let total_pages: Int
            let results: [Movie]
        }
    struct Movie: Decodable {
            let id: Int!
            let poster_path: String?
            let title: String
            let release_date: String?
            let vote_average: Double
            let overview: String
            let vote_count:Int!
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VC 1")
        // Do any additional setup after loading the view.
//        cv.delegate = self
        search.delegate = self
        cv.delegate = self
        cv.backgroundColor = .darkGray
        self.title = "Movie App"
        fetchData(query: "popular")
        catchImages()
        collectionSetup()
        
    }
    
//    fetchs movie data for whole page
    func fetchData(query: String){
        if query == "popular"{
            let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=baba6aef81dde8468940ee67eaee7cbb&language=en-US&page=1")
            let data = try! Data(contentsOf: url!)
            let response = try! JSONDecoder().decode(APIResults.self, from: data)
            theData = response.results
            for i in theData{
                print(i.title)
            }
        }
        else{
            let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=baba6aef81dde8468940ee67eaee7cbb&language=en-US&query=\(query)&page=1&include_adult=false")
            let data = try! Data(contentsOf: url!)
            let response = try! JSONDecoder().decode(APIResults.self, from: data)
            theData = response.results
            for i in theData{
                print(i.title)
            }
        }
    }
    
//    fetches images and stores them, also puts up image if data isn't avalible
    func catchImages() {
        print("yesssss")
        for i in theData{
            if i.poster_path == nil {
                movieImageCache.append(UIImage(named: "error")!)
            }
            else{
                let url = String("https://image.tmdb.org/t/p/w92" + i.poster_path!)
                let iurl = URL(string: url)
                let data = try? Data(contentsOf: iurl!)
                if data != nil {
                    let res = UIImage(data: data!)
                    movieImageCache.append(res!)
                }
                else {
                    movieImageCache.append(UIImage(named: "error")!)
                }
            }
        }
    }
    
//    setting up collectinoview
    func collectionSetup() {
        cv.dataSource = self
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "movieView")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return theData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cv.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as! MovieCollectionViewCell
        cell.movieLabel.text = theData[indexPath.item].title
        cell.movieImageView.image = movieImageCache[indexPath.item]
        return cell
        
    }
    
//  segue to next veiw controller with info
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as?
                ViewController3, let index =
                cv.indexPathsForSelectedItems?.first {
            destination.movie = theData[index.item].id; destination.name = theData[index.item].title; destination.rating = theData[index.item].vote_average; destination.sum = theData[index.item].overview; destination.ppath = theData[index.item].poster_path; destination.date = theData[index.item].release_date
            }
        
    }
    

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.showSpinner()
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false){ (t) in self.removeSpin()}
        let searchText = searchBar.text
        if searchText?.isEmpty == false{
            theData = []
            movieImageCache = []
            fetchData(query: searchText!)
            catchImages()
            cv.reloadData()
        }
        else{
            theData = []
            movieImageCache = []
            fetchData(query: "popular")
            catchImages()
            cv.reloadData()
        }

    }
    
//  3d touch menu that allows users to go to webpage if it exists and favorite movie
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { actions -> UIMenu? in
            let link = UIAction(title: "Go to Movie") { _ in if let url = URL(string: "https://www.themoviedb.org/movie/\(self.theData[indexPath.item].id ?? 0)-\(self.theData[indexPath.item].title )") {
                UIApplication.shared.open(url)
            }}
            let fav = UIAction(title: "Favorite") { _ in
                let defaults = UserDefaults.standard
                var d = (defaults.array(forKey: "favData") ?? []) as! Array<String>
                var j = (defaults.array(forKey: "idData") ?? []) as! Array<Int>
                if d.contains(self.theData[indexPath.item].title) == false {
                    d.append(self.theData[indexPath.item].title)
                    j.append(self.theData[indexPath.item].id)
                    print(d)
                    defaults.set(d, forKey: "favData")
                    defaults.set(j, forKey: "idData")
                }}
            return UIMenu(title: "Menu", children: [link, fav])
            }
            return configuration
        }
    
}

