//
//  File.swift
//  AppleMealsic
//
//  Created by 이진 on 7/3/24.
//

import Foundation

class Network: ObservableObject {
    
    @Published var todaysMenus: [Menu] = []
    @Published var tomorrowsMenus: [Menu] = []
    @Published var dayAfterTomorrowMenus: [Menu] = []
    
    @Published var threeDaysMenus: [[Menu]] = []
    
    func getMenus(of date: Date) -> Void {
        
        let date2StringArray = date2StringArray(date: date)
        let date2StringArray2Text = "\(date2StringArray[0])/\(date2StringArray[1])/\(date2StringArray[2])"
        
        //URLRequest
        guard let url = URL(string: "https://food.podac.poapper.com/v1/menus/\(date2StringArray2Text)") else { fatalError("Missing URL") }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        //URLSession
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil {
//                print("Request error: ", error)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        //Decode
                        let decodedMenus = try JSONDecoder().decode([Menu].self, from: data)
                        
                        let today = Calendar.current.date(byAdding: .second, value: 32400, to: Date())!
                        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!
                        let dayAfterTomorrow = Calendar.current.date(byAdding: .day, value: 2, to: today)!

                        if date.description.prefix(10) == today.description.prefix(10) {
                            self.todaysMenus = decodedMenus
                        } else if date.description.prefix(10) == tomorrow.description.prefix(10) {
                            self.tomorrowsMenus = decodedMenus
                        } else if date.description.prefix(10) == dayAfterTomorrow.description.prefix(10) {
                            self.dayAfterTomorrowMenus = decodedMenus
                        }
                        
                    } catch let error {
                        print("Error decoding: ", error)
                    }
                }
            }
        }
        dataTask.resume()
    }
}


func date2StringArray(date: Date) -> [String] {
    
    return date.description.prefix(10).split(separator: "-").map { String($0) }
}

func formatDateString(_ dateString: String) -> String {
    let year = dateString.prefix(4)
    let month = dateString.dropFirst(4).prefix(2)
    let day = dateString.dropFirst(6).prefix(2)
    return "\(year)-\(month)-\(day)"
}
