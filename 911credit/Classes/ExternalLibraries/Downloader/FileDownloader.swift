import Foundation

class FileDownloader {
    static func loadFileAsync(url: URL,name:String?=nil, completion: @escaping (String?, Error?) -> Void){
        if let fileUrl = FileDownloader.fetchFile(with: (name == nil ? url.lastPathComponent : name) ?? ""){
            print("File already exists [\(fileUrl.path)]")
            completion(fileUrl.path, nil)
        }
        else
        {
            print(url)
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
            {
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let destUrl = FileDownloader.saveFile(with: (name == nil ? url.lastPathComponent : name) ?? "", fileData: data){
                                    completion(destUrl.path, error)
                                } else {
                                    completion(nil, error)
                                }
                            }
                            else
                            {
                                completion(nil, error)
                            }
                        }
                    }
                }
                else
                {
                    completion(nil, error)
                }
            })
            task.resume()
        }
    }
    
    static func fetchFile(with name: String) -> URL? {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        if let path = paths.first {
            let imageURL = URL(fileURLWithPath: path).appendingPathComponent(name)
            do {
                let data = try Data(contentsOf: imageURL)
                print(data)
                return imageURL
            } catch let error{
                print("error fetchFile --->\(error.localizedDescription)")
                return nil
            }
        }
        return nil
    }
    
    static func saveFile(with imageName: String,fileData:Data)->URL? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return nil}
        let url = documentsDirectory.appendingPathComponent(imageName)
        do {
            try fileData.write(to: url, options: Data.WritingOptions.atomic)
            return url
        } catch let error{
            print("Error saving image-->\(error.localizedDescription)")
            return nil
        }
        
    }
    
   static func deleteFile(_ filePath: URL) {
        guard FileManager.default.fileExists(atPath: filePath.path) else {
            return
        }
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
        } catch{
            fatalError("Unable to delete file.")
        }
    }

}
