//
//  AFNetworkDataSource.swift
//  SuperAwesome
//
//  Created by Gunhan Sancar on 08/07/2020.
//

import Alamofire

class AFNetworkDataSource: NetworkDataSourceType {
    func getData(url: String, completion: OnResult<Data>?) {
        AF.request(url).responseData { response in
            if let data = response.data {
                completion?(Result.success(data))
            } else {
                completion?(Result.failure(AwesomeAdsError.network))
            }
        }
    }

    func downloadFile(url: String, completion: @escaping OnResult<String>) {
        // The url should contain the file extension at the end
        guard let fileExtension = url.fileExtension else {
            completion(Result.failure(AwesomeAdsError.fileInvalid))
            return
        }

        let fileName =  "\(url.toMD5).\(fileExtension)"

        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(fileName)

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download(url, to: destination).response { response in
            debugPrint(response)

            if response.error == nil, let path = response.fileURL?.path {
                completion(Result.success(path))
            } else {
                completion(Result.failure(AwesomeAdsError.network))
            }
        }
    }

    func clearFiles() {
        do {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            try fileManager.removeItem(at: documentsURL)
        } catch {
            return
        }
    }
}
