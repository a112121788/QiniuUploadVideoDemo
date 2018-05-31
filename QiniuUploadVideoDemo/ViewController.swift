//
//  ViewController.swift
//  QiniuUploadVideoDemo
//

import UIKit
import VGPlayer
import SnapKit
import Material

import MobileCoreServices
import AssetsLibrary
import AVKit
import AVFoundation

import Toast_Swift

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    let player = VGPlayer()
    let selectt_video_btn = Button()
    let upload_btn = Button()
    
    var videoURL = URL(string: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "上传视频"
        self.view.backgroundColor = UIColor.white
        
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white
        ]
        self.navigationController?.navigationBar.setBackgroundImage(createImageWithColor(UIColor(red: 0.98, green: 0.42, blue: 0.61, alpha: 1.00)), for: .default)
        
        initViews()
    }
    
    func initViews(){
        self.view.makeToast("This is a piece of toast")
        // 视频 上传
        self.view.addSubview(player.displayView)
        self.view.addSubview(selectt_video_btn)
        self.view.addSubview(upload_btn)
        
        
        
        self.player.replaceVideo(URL(string: "http://imgcdn.nowapp.cn/o_1celbtksdoh614km1oou1rvac8h7.mp4")!)
        self.player.displayView.titleLabel.text = ""
        self.player.displayView.closeButton.isHidden = true
        self.player.displayView.topView.isHidden = true
        
        player.displayView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(self.view.snp.width).multipliedBy(9.0/16.0)
        }
        
        
        selectt_video_btn.setTitle("选择视频", for: UIControlState())
        selectt_video_btn.backgroundColor = UIColor(red: 0.98, green: 0.42, blue: 0.61, alpha: 1.00)
        selectt_video_btn.addTarget(self, action:#selector(selectVideo), for:.touchUpInside)
        
        
        
        selectt_video_btn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.player.displayView.snp.bottom).offset(20)
        }
        
        upload_btn.setTitle("开始上传", for: UIControlState())
        upload_btn.backgroundColor = UIColor(red: 0.98, green: 0.42, blue: 0.61, alpha: 1.00)
        upload_btn.addTarget(self, action:#selector(uploadVideo), for:.touchUpInside)
        
        upload_btn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(selectt_video_btn.snp.bottom).offset(20)
        }
        
    }
    
    //选择视频
    @objc func selectVideo() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //初始化图片控制器
            let imagePicker = UIImagePickerController()
            //设置代理
            imagePicker.delegate = self
            //指定图片控制器类型
            imagePicker.sourceType = .photoLibrary
            //只显示视频类型的文件
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            //不需要编辑
            imagePicker.allowsEditing = false
            //弹出控制器，显示界面
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            print("读取相册错误")
        }
    }
    
    //选择视频成功后代理
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        //获取视频路径（选择后视频会自动复制到app临时文件夹下）
        videoURL = info[UIImagePickerControllerMediaURL] as! URL?
        //图片控制器退出
        self.dismiss(animated: true, completion: {})
        self.player.replaceVideo(videoURL!)
    }
    
    @objc func uploadVideo() {
        let token = "TOKEN" //填写您自己的

        let configuration = QNConfiguration.build { builder in
            let dns = QNDnsManager([QNResolver.system()], networkInfo: QNNetworkInfo.normal())
            builder?.useHttps = false
            builder?.setZone(QNAutoZone(dns: dns))
        }
        
        let upManager = QNUploadManager(configuration: configuration)
        
        let opt = QNUploadOption.init(progressHandler: {
            (key, percent) in
            print("上传进度\(percent)  \(NSDate())")
        })
        
        upManager?.putFile(videoURL?.relativePath, key: nil, token: token, complete: { (info, key,resp) in
            print(info)
            print(key)
            print(resp)
            if(info?.statusCode == 200 && resp != nil){
                print("success")
            }else{
                print("error")
            }
            
        }, option: opt)
        
    }
    
    
    
    func createImageWithColor(_ color:UIColor) -> UIImage{
        return createImageWithColor(color, size: CGSize(width: 1, height: 1))
    }
    
    
    func createImageWithColor(_ color:UIColor,size:CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size);
        let context = UIGraphicsGetCurrentContext();
        context?.setFillColor(color.cgColor);
        context?.fill(rect);
        
        let theImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return theImage!;
    }
    
}

