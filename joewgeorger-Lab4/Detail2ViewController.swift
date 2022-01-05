//
//  Detail2ViewController.swift
//  joewgeorger-Lab4
//
//  Created by Joe Georger on 10/31/21.
//  detailed view for favs tab

import UIKit

class Detail2ViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var overview: UILabel!
    
    var movie: Movie?
    var mid: Int?
    var poster: UIImage?
    
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
        print(mid!)
        fetchData()
        catchImage()
        setup()
        // Do any additional setup after loading the view.
    }
   
//  fetch data for page
    func fetchData(){
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(mid!)?api_key=baba6aef81dde8468940ee67eaee7cbb&language=en-US")
//        print(url)
        let data = try! Data(contentsOf: url!)
        let response = try! JSONDecoder().decode(Movie.self, from: data)
        movie = response
        print(movie?.title as Any)
    }
    
//  fetch image for page
    func catchImage() {
        if movie?.poster_path == nil {
            poster = UIImage(named: "error")
        }
        else{
            let url = String("https://image.tmdb.org/t/p/w342" + (movie?.poster_path)!)
            let iurl = URL(string: url)
            let data = try? Data(contentsOf: iurl!)
            poster = UIImage(data: data!)
        }
    }
    
//    set image and labels
    func setup() {
        self.title = movie?.title
        image.image = poster
        date.text = "Release Data: \(movie?.release_date ?? "No Date")"
        rating.text = "Rating: \(movie?.vote_average ?? 0.0)"
        overview.text = "Movie Overview: \n" + (movie?.overview ?? "No Overview")
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
