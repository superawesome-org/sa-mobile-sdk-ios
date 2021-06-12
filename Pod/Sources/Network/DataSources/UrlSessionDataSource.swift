//
//  UrlSessionDataSource.swift
//  SuperAwesome
//
//  Created by Mark on 11/06/2021.
//

import Foundation

class UrlSessionDataSource: NetworkDataSourceType {

    private let userAgent: String

    init(userAgentProvider: UserAgentProviderType) {
        self.userAgent = userAgentProvider.name
    }

    enum DownloadError: Error {
        case unknown
        case malformedUrl(url: String)
    }

    private let session = URLSession(configuration: .default)

    func getData(url: String, completion: OnResult<Data>?) {
        if let passedUrl = URL(string: url) {
            var request = URLRequest(url: passedUrl)
            request.setValue(userAgent, forHTTPHeaderField: "User-Agent")
            let dataTask = session.dataTask(with: request) { data, _, error in
                if let data = data {
                    DispatchQueue.main.async {
                        completion?(Result.success(data))
                    }
                } else if let error = error {
                    DispatchQueue.main.async {
                        completion?(Result.failure(error))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion?(Result.failure(DownloadError.unknown))
                    }
                }
            }
            dataTask.resume()
        } else {
            DispatchQueue.main.async {
                completion?(Result.failure(DownloadError.malformedUrl(url: url)))
            }
        }
    }

    func downloadFile(url: String, completion: @escaping OnResult<String>) {
    guard let fileExtension = url.fileExtension else {
            completion(Result.failure(AwesomeAdsError.fileInvalid))
            return
        }

        let fileName =  "\(url.toMD5).\(fileExtension)"
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent(fileName)

        if FileManager.default.fileExists(atPath: fileURL.absoluteString) {
            try? FileManager.default.removeItem(atPath: fileURL.absoluteString)
        }

        getData(url: url) { result in
            switch result {
            case .success(let data):
                do {
                    try data.write(to: fileURL, options: .atomic)
                    DispatchQueue.main.async {
                        completion(Result.success(fileURL.path))
                    }
                } catch let error {
                    DispatchQueue.main.async {
                        completion(Result.failure(error))
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(Result.failure(error))
                }
            }
        }
    }

    func clearFiles() {
        do {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            try fileManager.removeItem(at: documentsURL)
        } catch let error {
            print(error.localizedDescription)
        }
    }

}
