//
//  ViewController.swift
//  VoiceRecorder
//

import UIKit

class VoiceMemoListViewController: UIViewController, FinishRecord {
    
    @IBOutlet weak var recordFileListTableView: UITableView!
    
    var voiceMemoList: [RecordModel] = [RecordModel]()
    var localFileHandlder = LocalFileHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFirebaseStorageFileList()
        recordFileListTableView.delegate = self
        recordFileListTableView.dataSource = self
    }
    
    func finsihRecord(fileName: String, totalTime: String) {
        let fileName = subStringFileName(fileName:fileName)
        let recordModel = RecordModel(recordFileName: fileName, recordTime: totalTime)
        
        DispatchQueue.main.async {
            self.voiceMemoList.insert(recordModel, at: 0)
            self.recordFileListTableView.reloadData()
        }
    }
    
    func getFirebaseStorageFileList() {
        FirebaseStorage.shared.getFileList { result in
            switch result {
            case .success(let fileList) :
                var count = 0
                if fileList.count == 0 { return }
                for fileName in fileList {
                    FirebaseStorage.shared.getFileMetaData(fileName: fileName) { result in
                        switch result {
                        case .success(let totalTime) :
                            count += 1
                            let subFileName = self.subStringFileName(fileName: fileName, true)
                            
                            self.voiceMemoList.append(RecordModel(recordFileName: subFileName, recordTime: totalTime))
                            let sortedVoiceMemoList = self.voiceMemoList.sorted { $0.recordFileName > $1.recordFileName }
                            self.voiceMemoList = sortedVoiceMemoList
                            if count == fileList.count {
                                DispatchQueue.main.async {
                                    self.recordFileListTableView.reloadData()
                                }
                            }
                        case .failure(let error) :
                            print(error.localizedDescription)
                        }
                    }
                }
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    
    func subStringFileName(fileName: String,_ isFirabse : Bool = false) -> String {
        if isFirabse{
            return subString(subString(fileName, "/"),"_")
        } else {
            return subString(fileName, "_")
        }
    }
    
    func subString(_ fileName: String, _ character: Character) -> String{
        let index = fileName.firstIndex(of: character) ?? fileName.startIndex
        let range = fileName.index(after: index)..<fileName.endIndex
        return String(fileName[range])
    }
    
    @IBAction func addRecordMemo(_ sender: Any) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "RecordingViewController") as? RecordingViewController else { return }
        vc.delegate = self
        present(vc, animated: true)
    }
}

extension VoiceMemoListViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.voiceMemoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecordFileCell", for: indexPath) as? RecordFileCell else { return UITableViewCell() }
        cell.fileNameLable.text = voiceMemoList[indexPath.row].recordFileName
        cell.recordPlayTimeLabel.text = voiceMemoList[indexPath.row].recordTime
        return cell
    }
}

extension VoiceMemoListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let playingVC = storyboard?.instantiateViewController(withIdentifier: "PlayingViewController") as? PlayingViewController else { return }
        let name = voiceMemoList[indexPath.row].recordFileName
        let time = voiceMemoList[indexPath.row].recordTime
        let selectedFileInfo = RecordModel(recordFileName: name, recordTime: time)
        playingVC.selectedFileInfo = selectedFileInfo
        let isFileExist = localFileHandlder.checkFileExists(fileName: name)
        if isFileExist {
            present(playingVC, animated: true)
        } else {
            FirebaseStorage.shared.downloadFile(fileName: "voiceRecords_\(name)") { result in
                switch result {
                case .success(let fileName) :
                    let subFileName = self.subStringFileName(fileName: fileName)
                    let isDownloadFileExist = self.localFileHandlder.checkFileExists(fileName: subFileName)
                    if isDownloadFileExist {
                        print("DOWNLOAD FILE AVAILABLE")
                        self.present(playingVC, animated: true)
                    } else {
                        print("DOWNLOAD FILE NOT AVAILABLE")
                    }
                case .failure(let error) :
                    print(error.localizedDescription)
                }
            }
        }
        
    }
}
