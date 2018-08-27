//
//  MoviedbAPI.swift
//  Primeiro app
//
//  Created by igor gomes arantes on 23/08/18.
//  Copyright © 2018 igor gomes arantes. All rights reserved.
//

import Foundation
import UIKit

enum Quality : String{
    case low = "w200"
    case medium = "w500"
    case high = "original"
}

class MoviedbAPI{
    private let apiKey: String = "423a7efcc5851107f96bc25a3b0c3f28"
    private let language: String = "pt-BR"
    private let baseURL: String = "https://api.themoviedb.org/3"
    private let imageBaseURL: String = "https://image.tmdb.org/t/p"
    
    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    public func getPoster(path: String, quality: Quality, completion: @escaping (Data?, URLResponse?, Error?) -> ()){
        let url = URL(string: imageBaseURL + "/" + quality.rawValue + "/" + path)
        //let url = URL(string: "https://image.tmdb.org/t/p/original/kqjL17yufvn9OVLyXYpvtyrFfak.jpg")
        getDataFromUrl(url: url!, completion: completion)
    }
    
    public func getMovie(id: Int, completion: @escaping (Data?, URLResponse?, Error?) -> ()){
        let url = URL(string: baseURL + "/movie/" + String(id) + "?api_key=" +
        apiKey + "&language=" + language)
        getDataFromUrl(url: url!, completion: completion)
    }
    
    func getMovie() -> Movie{
        var movie = Movie()
        
        movie.id = 100
        movie.title = "Batman vs Superman"
        movie.overview = "Jack (Edward Norton) é um executivo jovem, trabalha como investigador de seguros, mora confortavelmente, mas ele está ficando cada vez mais insatisfeito com sua vida medíocre. Para piorar ele está enfrentando uma terrível crise de insônia, até que encontra uma cura inusitada para o sua falta de sono ao frequentar grupos de auto-ajuda. Nesses encontros ele passa a conviver com pessoas problemáticas como a viciada Marla Singer (Helena Bonham Carter) e a conhecer estranhos como Tyler Durden (Brad Pitt). Misterioso e cheio de ideias, Tyler apresenta para Jack um grupo secreto que se encontra para extravasar suas angústias e tensões através de violentos combates corporais."
        movie.release_date = "2016"
        movie.runtime = 216
        movie.genres?.append(Genre(id: 1, name: "Acao"))
        movie.genres?.append(Genre(id: 2, name: "Comedia"))
        movie.genres?.append(Genre(id: 3, name: "Drama"))
        movie.vote_count = 205400
        movie.vote_average = 9.8
        
        return movie
    }
    
    func getPoster() -> UIImage {

        let image = UIImage(named: "madmax")

        return image!
    }
}
