//
//  ContentView.swift
//  API
//
//  Created by Federico Ruiz on 4/3/24.
//

import SwiftUI
import Foundation

struct ContentView: View {
    
    @State var series:[Post] = []
    var body: some View {
        NavigationStack{
            List(series){post in
                HStack{
                    VStack(alignment:.leading) {
                        Text(post.name).bold().lineLimit(1).font(.title3)
                        Text(post.genre).lineLimit(1).font(.footnote)
                    }
                    Spacer()
                    Text("Año: \(post.year)")
                }
            }
            .navigationTitle("Posts from API")
            .onAppear{
                fetchData()
            }
        }
    }
    
    private func fetchData() {
        //Parse URL
        guard let url = URL(string: "https://springbootapi-production-61be.up.railway.app/api/v1/series") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                do {
                    //Parse JSON
                    let decodedData = try JSONDecoder().decode([Post].self, from: data)
                    self.series = decodedData
                } catch {
                    //Print JSON decoding error
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            } else if let error = error {
                //Print API call error
                print("Error fetching data: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    
    struct Post: Codable, Identifiable {
        
        let idSerie: Int
        let name: String
        let genre: String
        let year: Int
        let ranking: Int
        let actores: [String]
        let productor: String?
        
        var id: Int { idSerie } // Si o si necesito la var id con un identificador unico (Identifiable)
    }

}
