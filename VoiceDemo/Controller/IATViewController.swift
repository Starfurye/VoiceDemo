//
//  IATViewController.swift
//  VoiceDemo
//
//  Created by Yura on 2019/3/18.
//  Copyright © 2019 St4rg4z3r. All rights reserved.
//

import UIKit

class IATViewController: UIViewController, IFlySpeechRecognizerDelegate {
    
    // 创建识别对象
    var iflySpeechRecognizer = IFlySpeechRecognizer.sharedInstance()!
    @IBOutlet weak var resultTextView: UITextView!
    var uploader = IFlyDataUploader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // 创建语音配置
        let initString = "appid=" + APPID_VALUE + ",timeout=" + TIMEOUT_VALUE
        
        // 所有服务启动前，需要确保执行createUtility
        IFlySpeechUtility.createUtility(initString)
        self.iflySpeechRecognizer.delegate = self
        
        let domain = "iat"
        self.iflySpeechRecognizer.setParameter(domain, forKey: IFlySpeechConstant.ifly_DOMAIN())
        self.iflySpeechRecognizer.setParameter("16000", forKey: IFlySpeechConstant.sample_RATE())
        // 保存音频时，请在必要的地方加上这行。不需要保存时，第一个参数设为nil
        self.iflySpeechRecognizer.setParameter("asr.pcm", forKey: IFlySpeechConstant.asr_AUDIO_PATH())
        
        // | result_type   | 返回结果的数据格式，可设置为json，xml，plain，默认为json。
        self.iflySpeechRecognizer.setParameter("json", forKey: IFlySpeechConstant.result_TYPE())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.iflySpeechRecognizer.stopListening();
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Button Event
    @IBAction func startListening() {
        self.resultTextView.text = ""
        iflySpeechRecognizer.startListening()
    }
    
    @IBAction func stopListening() {
        iflySpeechRecognizer.stopListening()
    }
    
    @IBAction func cancelListening() {
        iflySpeechRecognizer.cancel()
    }
    /*
    // MARK:- TODO
    @IBAction func uploadContact() {
        self.iflySpeechRecognizer.stopListening()
        // 获取联系人
        let iflyContact = IFlyContact()
        let contact = iflyContact.contact()
        resultTextView.text = contact
        
        self.uploader.setParameter("uup", forKey: "subject")
        self.uploader.setParameter("contact", forKey: "dtt")
        
        typealias CompletionBlock = @convention(block)(_ result:String?, _ error:IFlySpeechError?)-> Void
        
        let aBlock:CompletionBlock = {
            (result:String?, error:IFlySpeechError?)-> Void in
            if result != nil {
                self.onUploadFinished(grammerID: result!,error:error!)
            }
        }
        
        self.uploader.uploadData(completionHandler: aBlock, name:"contact", data:resultTextView.text)
    }
    
    
    @IBAction func uploadDict() {
        self.iflySpeechRecognizer.stopListening()
        
        let iflyUserWords:IFlyUserWords = IFlyUserWords(json: IAT_SAMPLE_USERWORDS)
        
        self.uploader.setParameter("iat", forKey: "subject")
        self.uploader.setParameter("userword", forKey: "dtt")
        
        typealias CompletionBlock = @convention(block)(_ result:String?, _ error:IFlySpeechError?)-> Void
        
        let aBlock:CompletionBlock = {
            (result:String?, error:IFlySpeechError?)-> Void in
            self.onUploadFinished(grammerID: result!,error:error!)
        }
        
        self.uploader.uploadData(completionHandler:aBlock, name:"userwords", data:iflyUserWords.toString())
        resultTextView.text = "德国盐猪手\n1912酒吧街\n清蒸鲈鱼\n挪威三文鱼\n黄埔军校\n横沙牌坊\n科大讯飞\n"
    }
    */
    // MARK: - IFlySpeechRecognizerDelegate
    
    /**
    * @fn      onVolumeChanged
    * @brief   音量变化回调
    *
    * @param   volume      -[in] 录音的音量，音量范围1~100
    * @see
    */
    private func onVolumeChanged(volume: Int32) {
        NSLog("音量：\(volume)")
    }
    
    /**
    * @fn      onBeginOfSpeech
    * @brief   开始识别回调
    *
    * @see
    */
    func onBeginOfSpeech(){
        NSLog("onEndOfSpeech")
    }
    
    /**
    * @fn      onEndOfSpeech
    * @brief   停止录音回调
    *
    * @see
    */
    func onEndOfSpeech(){
        NSLog("onEndOfSpeech")
    }
    
    /**
    * @fn      onCompleted
    * @brief   识别结果回调
    *
    * 在进行语音识别过程中的任何时刻都有可能回调此函数，你可以根据errorCode进行相应的处理，当errorCode没有错误时，表示此次会话正常结束；否则，表示此次会话有错误发生。特别的当调用`cancel`函数时，引擎不会自动结束，需要等到回调此函数，才表示此次会话结束。在没有回调此函数之前如果重新调用了`startListenging`函数则会报错误。
    *
    *  @param   errorCode   -[out] 错误类，具体用法见IFlySpeechError
    */
    func onCompleted(_ errorCode: IFlySpeechError!) {
        if let code = errorCode {
            NSLog("onCompleted: \(code)")
        }
        else {
            NSLog("No error on completion")
        }
    }
    
    // MARK:- TODO
    /**
    * @fn      onResults
    * @brief   识别结果回调
    *
    * @param   result      -[out] 识别结果，NSArray的第一个元素为NSDictionary，NSDictionary的key为识别结果，value为置信度
    * @see
    */
    func onResults(_ results: [Any], isLast: Bool) {
        var result = ""
        if results.count > 0 {
            let dic = results[0] as! NSDictionary
            for (key,value) in dic {
                result = "\(key) (置信度:\(value))\n"
            }
            NSLog(result)
            self.resultTextView.text = self.resultTextView!.text + result
        }
    }
    
    /**
    * @fn      onCancal
    * @brief   取消识别回调
    *
    * @see
    */
    
    func onCancel(){
        NSLog("onCancel")
    }
    /*
    //MARK: - IFlyDataUploaderDelegate
    /**
     * @fn      onUploadFinished
     * @brief   上传完成回调
     * @param grammerID 上传用户词、联系人为空
     * @param error 上传错误
     */
    func onUploadFinished(grammerID:String,error:IFlySpeechError){
        NSLog("error:\(error.errorCode)");
        
        if (error.errorCode==0) {
            NSLog("上传成功");
        }
        else {
            NSLog("上传失败");
        }
    }*/
}
