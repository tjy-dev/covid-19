//
//  Server.swift
//  Tokyo COVID19
//
//  Created by YUKITO on 2020/03/06.
//  Copyright © 2020 TJ-Tech. All rights reserved.
//

import Foundation
import Alamofire

struct Server {
    var delegate:serverDelegate?
    
    func getPositiveData() {
        AF.request("https://stopcovid19.metro.tokyo.lg.jp/data/130001_tokyo_covid19_patients.csv", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON {response in
            if let data = response.data, let str = String(data: data, encoding: .utf8) {
                self.delegate?.onSuccessGet(data: str)
            }
        }
    }
    
    func getJsonData() {
        AF.request("https://raw.githubusercontent.com/tokyo-metropolitan-gov/covid19/development/data/data.json", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON {response in
            if let value = response.value{
                self.delegate?.onSuccessGetJson(data: value)
            }
        }
    }
    
    func getNews() {
        AF.request("https://raw.githubusercontent.com/tokyo-metropolitan-gov/covid19/development/data/news.json", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON {response in
            if let value = response.value{
                self.delegate?.onSuccessGetNews(data: value)
            }
        }
    }
}

protocol serverDelegate {
    func onSuccessGet(data:String)
    func onSuccessGetJson(data:Any)
    func onSuccessGetNews(data:Any)
}

extension serverDelegate {
    func onSuccessGet(data:String) {
        return
    }
    func onSuccessGetJson(data:Any) {
        return
    }
    func onSuccessGetNews(data:Any) {
        return
    }
}



//MARK: -NOT USING THIS BECAUSE IM USING JSON
// ONLY NEED THIS WHILE USEING CSV DATA
struct DataConvert {
    static func csvToDateArray(str:String) -> ([String],[String],[String],[String]){
        var presentDate:[String] = []
        var residence:[String] = []
        var age:[String] = []
        var sex:[String] = []
        
        let rows = str.components(separatedBy: "\n")
        
        for row in rows {
            let components = row.components(separatedBy: ",")
            presentDate.append(components[4])
            residence.append(components[7])
            age.append(components[8])
            sex.append(components[9])
        }
        
        presentDate.removeFirst()
        residence.removeFirst()
        age.removeFirst()
        sex.removeFirst()

        return (presentDate,residence,age,sex)
    }
    
    static func dateArray(from:[String]) -> [[Date]]{
        var returnData:[[Date]] = []
        var grounp:[Date] = []
        
        for day in from {
            let format = "yyyy-MM-dd"
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = format
            let date = dateFormatter.date(from: day)
            if date == grounp.last {
                grounp.append(date!)
            }else{
                if grounp != []{
                    returnData.append(grounp)
                }
                grounp = []
                grounp.append(date!)
            }
        }
        
        returnData.append(grounp)
        
        return returnData
    }

}
