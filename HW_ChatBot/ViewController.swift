//
//  ViewController.swift
//  HW_ChatBot
//
//  Created by 曹家瑋 on 2023/5/13.
//

/*
1. if else 過濾比較文字 （if else 文字比對相關文字，顯示在promptLabel 問學業、感情、事業、愛情等）
2. for in 陣列
3. random 給籤
4. 如果輸入的問題，沒有被匹配到，有可以設置幾個回答用亂數去給予回覆，或用餘數字數來給予回答
 */

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var promptLabel: UILabel!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var controlResultButton: UIButton!
    @IBOutlet weak var stillDrawLotsImageView: UIImageView!
    
    // fortuneImages: 籤Arrays
    var fortuneImages: [String] = []
    var fortuneIndex = 0
    
    // 建立 AVPlayer()
    let soundPlayer = AVPlayer()
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 預設promptLabel
        promptLabel.text = "誠心參拜，確認城隍爺是否在手機前，或現在的狀態是否方便求籤。"
        
        // fortuneImages 陣列儲存
        for i in 1...60 {
            fortuneImages.append("no\(i)")
        }
        
    }
    
    @IBAction func createResultButton(_ sender: Any) {
        
        let questionText = questionTextField.text!
        
//        fortuneIndex = Int.random(in: 0...fortuneImages.count - 1)
        fortuneIndex = fortuneImages.indices.randomElement()!
        
        /*使用者沒輸入文字時,text 會是空字串,不會是 nil 所以可以放心加 !
          hasSuffix 檢查後面： 如果只有單純打請問、會不會，沒有打明確內容的話則會跳出提示"要輸入明確內容"*/
        if questionText == "" {
             promptLabel.text = "請輸入文字，並默念心中想法。"
            
         } else if questionText.hasSuffix("請問") {
             promptLabel.text = "請寫下明確內容。"
        
         } else if questionText.contains("學業") || questionText.contains("考試") {
             promptLabel.text = "您詢問的是學業考試相關："
             controlResultButton.isEnabled = false
             stillDrawLotsImageView.isHidden = true
             playSound()
             drawLotsGif()
             showResultImageWithDelay()
             
         } else if questionText.contains("感情") {
        
             if questionText.contains("與") {
                 promptLabel.text = "您與對方目前的感情狀況發展："
                 controlResultButton.isEnabled = false
                 stillDrawLotsImageView.isHidden = true
                 playSound()
                 drawLotsGif()
                 showResultImageWithDelay()
             } else {
                 promptLabel.text = "您目前的感情狀況："
                 controlResultButton.isEnabled = false
                 stillDrawLotsImageView.isHidden = true
                 playSound()
                 drawLotsGif()
                 showResultImageWithDelay()
             }
        
         } else if questionText.contains("事業") {
        
             if questionText.contains("未來") {
                 promptLabel.text = "您未來的事業大致方向："
                 controlResultButton.isEnabled = false
                 stillDrawLotsImageView.isHidden = true
                 playSound()
                 drawLotsGif()
                 showResultImageWithDelay()
             } else {
                 promptLabel.text = "您目前事業的發展方向："
                 controlResultButton.isEnabled = false
                 stillDrawLotsImageView.isHidden = true
                 playSound()
                 drawLotsGif()
                 showResultImageWithDelay()
         }
        
         } else if questionText.contains("財富") {
             promptLabel.text = "您這陣子財運："
             controlResultButton.isEnabled = false
             stillDrawLotsImageView.isHidden = true
             playSound()
             drawLotsGif()
             showResultImageWithDelay()
        
         } else if questionText.contains("健康") {
             promptLabel.text = "您這陣子身體狀況："
             controlResultButton.isEnabled = false
             stillDrawLotsImageView.isHidden = true
             playSound()
             drawLotsGif()
             showResultImageWithDelay()

         } else {
             // 如沒有輸入到上述的關鍵字，則會判斷字數的餘數，跳出以下內容
             let questionLength = questionText.count
             let defaultNumber = questionLength % 3
        
             if defaultNumber == 0 {
                 promptLabel.text = "請重點講述(學業、事業等），以便幫您指點迷津！"
        
             } else if defaultNumber == 1 {
                 promptLabel.text = "請換個方式詢問，以便城隍爺賜籤！"
        
             } else if defaultNumber == 2 {
                 promptLabel.text = "請給出明確方向，讓城隍爺指引方向！"
             }
         }

        // 點擊Button收起鍵盤
        view.endEditing(true)
        
    }
    
    // 重置button
    @IBAction func resetButtonPressed(_ sender: Any) {
        
        questionTextField.text = ""
        promptLabel.text = "誠心參拜，確認城隍爺是否在手機前，或現在的狀態是否方便求籤。"
        resultImageView.image = nil
        controlResultButton.isEnabled = true
        stillDrawLotsImageView.isHidden = false

    }
    
    // 音樂設定
    func playSound() {
        let fileUrl = Bundle.main.url(forResource: "籤筒音效", withExtension: "mp3")!
        let soundItem = AVPlayerItem(url: fileUrl)
        soundPlayer.replaceCurrentItem(with: soundItem)
        soundPlayer.rate = 1.7
        soundPlayer.play()
    }
    
    // 籤Gif
    func drawLotsGif() {
        let drawLotsImageView = UIImageView(frame: CGRect(x: 90, y: 500, width: 210, height: 264))
        drawLotsImageView.transform = CGAffineTransform(scaleX: 1, y: 1)

        view.addSubview(drawLotsImageView)
        let drawLotsAnimatedImage = UIImage.animatedImageNamed("籤-", duration: 1)
        drawLotsImageView.image = drawLotsAnimatedImage
        
        // 詢問ChatGPT：控制 drawLotsImageView 的顯示（2秒後結束）
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            drawLotsImageView.removeFromSuperview()
        }
    }
    
    // 詢問ChatGPT：設置點擊2秒後再顯示 resultImageView
    func showResultImageWithDelay() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.resultImageView.image = UIImage(named: self.fortuneImages[self.fortuneIndex])
        }
    }

    
}


//import UIKit
//
//class ViewController: UIViewController {
//
//    @IBOutlet weak var promptLabel: UILabel!
//    @IBOutlet weak var questionTextField: UITextField!
//    @IBOutlet weak var resultImageView: UIImageView!
//    @IBOutlet weak var controlResultButton: UIButton!
//
//    // fortuneImages: 籤Arrays
//    var fortuneImages: [String] = []
//    var fortuneIndex = 0
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        promptLabel.text = "誠心參拜，確認城隍爺是否在手機前，或現在的狀態是否方便求籤。"
//
//        // fortuneImages 陣列儲存
//        for i in 1...60 {
//            fortuneImages.append("no\(i)")
//        }
//    }
//
//
//    @IBAction func createResultButton(_ sender: Any) {
//
//        let questionText = questionTextField.text!
//
////        fortuneIndex = Int.random(in: 0...fortuneImages.count - 1)
//        fortuneIndex = fortuneImages.indices.randomElement()!
//
////        // 使用者沒輸入文字時,text 會是空字串,不會是 nil 所以可以放心加 !
////        // hasSuffix 檢查後面： 如果只有單純打請問、會不會，沒有打明確內容的話則會跳出提示"要輸入明確內容"
//
//        /*使用者沒輸入文字時,text 會是空字串,不會是 nil 所以可以放心加 !
//          hasSuffix 檢查後面： 如果只有單純打請問、會不會，沒有打明確內容的話則會跳出提示"要輸入明確內容"*/
//        if questionText == "" {
//             promptLabel.text = "請輸入文字，並默念心中想法。"
//
//         } else if questionText.hasSuffix("請問") {
//             promptLabel.text = "請寫下明確內容。"
//
//         } else if questionText.contains("學業") || questionText.contains("考試") {
//             promptLabel.text = "您詢問的是學業考試相關："
//             resultImageView.image = UIImage(named: fortuneImages[fortuneIndex])
//             controlResultButton.isEnabled = false
//
//         } else if questionText.contains("感情") {
//
//             if questionText.contains("與") {
//                 promptLabel.text = "您與對方目前的感情狀況發展："
//                 resultImageView.image = UIImage(named: fortuneImages[fortuneIndex])
//                 controlResultButton.isEnabled = false
//             } else {
//                 promptLabel.text = "您目前的感情狀況："
//                 resultImageView.image = UIImage(named: fortuneImages[fortuneIndex])
//                 controlResultButton.isEnabled = false
//             }
//
//         } else if questionText.contains("事業") {
//
//             if questionText.contains("未來") {
//                 promptLabel.text = "您未來的事業大致方向："
//                 resultImageView.image = UIImage(named: fortuneImages[fortuneIndex])
//                 controlResultButton.isEnabled = false
//             } else {
//                 promptLabel.text = "您目前事業的發展方向："
//                 resultImageView.image = UIImage(named: fortuneImages[fortuneIndex])
//                 controlResultButton.isEnabled = false
//         }
//
//         } else if questionText.contains("財富") {
//             promptLabel.text = "您這陣子財運："
//             resultImageView.image = UIImage(named: fortuneImages[fortuneIndex])
//             controlResultButton.isEnabled = false
//
//         } else if questionText.contains("健康") {
//             promptLabel.text = "您這陣子身體狀況："
//             resultImageView.image = UIImage(named: fortuneImages[fortuneIndex])
//             controlResultButton.isEnabled = false
//
//         } else {
//
//             // 如沒有輸入到上述的關鍵字，則會判斷字數的餘數，跳出以下內容
//             let questionLength = questionText.count
//             let defaultNumber = questionLength % 3
//
//             if defaultNumber == 0 {
//                 promptLabel.text = "請重點講述，以便幫您指點迷津！"
//
//             } else if defaultNumber == 1 {
//                 promptLabel.text = "請換個方式詢問，以便神明賜籤！"
//
//             } else if defaultNumber == 2 {
//                 promptLabel.text = "請給出明確方向，讓神明指引方向！"
//             }
//         }
//
//        // 點擊Button收起鍵盤
//        view.endEditing(true)
//
//    }
//
//    // 重置button
//    @IBAction func resetButtonPressed(_ sender: Any) {
//
//        questionTextField.text = ""
//        resultImageView.image = nil
//        controlResultButton.isEnabled = true
//    }
//
//}

/*
 else 最後可以試試看給亂數。
 */

/*func responseTo(question: String) -> String {
 
 if question.hasPrefix("hello") {
     return "Why, hello there"
 } else if question.hasPrefix("where") {
     return "To the North!"
 } else {
     return "That really depends"
 }
}*/



