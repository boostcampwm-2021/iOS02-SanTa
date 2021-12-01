//
//  main.swift
//  MountainGenerator
//
//  Created by Jiwon Yoon on 2021/11/25.
//
//  Mac Command Line Tool

import Foundation

var processedMountains = Set<MountainWithLocation>()

func readJSON() -> [MountainInfo] {
    let data = try? Data(contentsOf: URL(fileURLWithPath: "/Users/jiwonyoon/Desktop/Mountains.json"))
    let decoded = try? JSONDecoder().decode([MountainInfo].self, from: data!)
    
    return decoded ?? []
}

// 국내에 없거나, 자연 지형(natural feature)이 아니면 산 데이터로 인정 하지 않음
func isValidMountain(response: GeoCodeDTO?) -> Bool {
    guard let response = response,
          let addressComponents = response.results.first?.addressComponents,
          let types = response.results.first?.types else {
              return false
          }
    var isInKorea = false
    let isNaturalFeature = types.contains("natural_feature")
    
    for addressComponent in addressComponents {
        if addressComponent.longName == "대한민국" || addressComponent.shortName == "KR" {
            isInKorea = true
            break
        }
    }
    return isInKorea && isNaturalFeature
}

func sendRequest(for mountain: MountainInfo) {
    let sessionConfig = URLSessionConfiguration.default
    let session = URLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
    
    guard var URL = URL(string: "https://maps.googleapis.com/maps/api/geocode/json") else { return }
    let URLParams = [
        "address": "\(mountain.mountainRegion) \(mountain.mountainName)",
        "key": "비밀임",
        "language": "ko",
    ]
    URL = URL.appendingQueryParameters(URLParams)
    var request = URLRequest(url: URL)
    request.httpMethod = "GET"
    
    let task = session.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) -> Void in
        if let data = data, (error == nil) {
            let dto = try? JSONDecoder().decode(GeoCodeDTO.self, from: data)
            // 검색해도 위치정보가 나오지 않을 경우.
            guard let latitude = dto?.results.first?.geometry.location.lat,
                  let longitude = dto?.results.first?.geometry.location.lng,
                  isValidMountain(response: dto) else {
                      print("not a valid Mountain!")
                      return
                  }
            
            let mountainWithLocation = MountainWithLocation(mountain: mountain, latitude: latitude, longitude: longitude)
            processedMountains.insert(mountainWithLocation)
            print("\(mountainWithLocation.mountain.mountainName), \(mountainWithLocation.latitude), \(mountainWithLocation.longitude)")
            
        }
        else {
            // Failure
            print("URL Session Task Failed: %@", error!.localizedDescription);
        }
    })
    task.resume()
    session.finishTasksAndInvalidate()
}


let mountains = readJSON()
print(mountains.count)

for mountain in mountains {
    print("requesting: \(mountain.mountainName)")
    sendRequest(for: mountain)
    // 너무 리퀘스트를 동시에 보내면 구글 API가 응답하지 않음!
    sleep(1)
}
let mountainsWithLocation = Array(processedMountains)
//이후 json 파일로 저장

let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted
if let jsonData = try? encoder.encode(mountainsWithLocation),
   let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) {
    
    let pathWithFileName = URL(string: "/Users/jiwonyoon/Desktop/")?.appendingPathComponent("MountainsWithLocation.json")
    try jsonString.write(to: pathWithFileName!, atomically: true, encoding: .utf8)
}
