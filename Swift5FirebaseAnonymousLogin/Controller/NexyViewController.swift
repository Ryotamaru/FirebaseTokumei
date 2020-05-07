//
//  NexyViewController.swift
//  Swift5FirebaseAnonymousLogin
//
//  Created by ryota on 2020/05/06.
//  Copyright © 2020 Honda Ryota. All rights reserved.
//

import UIKit
import SDWebImage

class NexyViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    
    
    @IBOutlet weak var timeLineTableView: UITableView!
    
    @IBOutlet weak var cameraButton: UIButton!
    
    
    //　ユーザーコンテンツ
    var selectedImage = UIImage()
    
    var userName = String()
    
    var userImageData = Data()
    
    var userImage = UIImage()
    
    var createData = String()
    
    var contentImageString = String()
    
    var userProfileImageString = String()
    
    var contentsArray = [Contents]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLineTableView.delegate = self
        
        timeLineTableView.dataSource = self
        
        // 前ページで取得したデータ(デフォルトデータ)を代入
        if UserDefaults.standard.object(forKey: "userName") != nil {
            
            userName =  UserDefaults.standard.object(forKey: "userName") as! String
        }
        
        
        if UserDefaults.standard.object(forKey: "userImage") != nil {
            
            userImageData =  UserDefaults.standard.object(forKey: "userImage") as! Data
            
            // データ型をUIImage型に変換
            userImage = UIImage(data: userImageData)!
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        contentsArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = timeLineTableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        // 　セルの中にあるコンテンツを変数に代入
        
        // アイコン
        let profileImageView = cell.viewWithTag(1) as! UIImageView
        
        // indexPath.rowはセルの行のこと
        profileImageView.sd_setImage(with: URL(string: contentsArray[indexPath.row].profileImageString), completed: nil)
        profileImageView.layer.cornerRadius = 30.0
        
        // ユーザー名
        let userNameLabel = cell.viewWithTag(2) as! UILabel
        userNameLabel.text = contentsArray[indexPath.row].userNameString
        
        // 投稿日時
        let deteLabel = cell.viewWithTag(3) as! UILabel
        deteLabel.text = contentsArray[indexPath.row].postDateString
        
        // 投稿画像
        let contentsImageView = cell.viewWithTag(4) as! UIImageView
        contentsImageView.sd_setImage(with: URL(string: contentsArray[indexPath.row].contentImageString), completed: nil)
        
        // コメントラベル
        let commentLabel = cell.viewWithTag(2) as! UILabel
        commentLabel.text = contentsArray[indexPath.row].commentString
        
        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 515
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    
    
    @IBAction func cameraAction(_ sender: Any) {
       
        // アラート　or アクションシート
        showAlert()
        
        
    }
    
    // カメラ立ち上げ
    func doCamera() {
        
        // ソースタイプの選択
        let sourceType : UIImagePickerController.SourceType = .camera
        
        // カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    
    
    // カメラ立ち上げ
    func doAlbum() {
        
        // ソースタイプの選択
        let sourceType : UIImagePickerController.SourceType = .photoLibrary
        
        // カメラ利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            
            let cameraPicker = UIImagePickerController()
            cameraPicker.allowsEditing = true
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
        }
    }
    
    
    
    // アラート
    func showAlert(){
           
        let alertController = UIAlertController(title: "選択", message: "どちらを選択しますか？", preferredStyle: .actionSheet)
           
        let acion1 = UIAlertAction(title: "カメラ", style: .default) { (alert) in
               
            self.doCamera()
        }
           
        let acion2 = UIAlertAction(title: "アルバム", style: .default) { (alert) in
               
            self.doAlbum()
        }
           
        let acion3 = UIAlertAction(title: "キャンセル", style: .default)
               
        alertController.addAction(acion1)
        alertController.addAction(acion2)
        alertController.addAction(acion3)
        self.present(alertController, animated: true, completion: nil)
       }
    
    
    
    // キャンセル
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    // 画像が選択　or 撮影後に呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //  選択した画像が入る
        selectedImage = info[.originalImage] as! UIImage
        
        // ナビゲーションによる画面遷移
        let editPostVC = self.storyboard?.instantiateViewController(identifier: "editPost")  as! EditAndPostViewController
        
        editPostVC.passedImage = selectedImage
        
        self.navigationController?.pushViewController(editPostVC, animated: true)
        
        // ピッカーを閉じる
        picker.dismiss(animated: true, completion: nil)
        
    }
    

}
