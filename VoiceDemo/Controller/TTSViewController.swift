//
//  TTSViewController.swift
//  VoiceDemo
//
//  Created by Yura on 2019/3/12.
//  Copyright © 2019 St4rg4z3r. All rights reserved.
//

import UIKit

class TTSViewController: UIViewController, IFlySpeechSynthesizerDelegate {
    
    // 创建合成对象
    var iflySpeechSynthesizer = IFlySpeechSynthesizer.sharedInstance()!
    @IBOutlet weak var ttsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // init app
        super.init(coder: aDecoder)
        
        // 创建语音配置
        let initString = "appid=" + APPID_VALUE + ",timeout=" + TIMEOUT_VALUE
        
        // 所有服务启动前，需要确保执行createUtility
        IFlySpeechUtility.createUtility(initString)
        self.iflySpeechSynthesizer.delegate = self
        
        // 合成的语速,取值范围 0~100
        self.iflySpeechSynthesizer.setParameter("50", forKey: IFlySpeechConstant.speed())
        // 合成的音量,取值范围 0~100
        self.iflySpeechSynthesizer.setParameter("50", forKey: IFlySpeechConstant.volume())
        // 发音人,默认为”xiaoyan”;可以设置的参数列表可参考个性化发音人列表
        self.iflySpeechSynthesizer.setParameter("xiaoyan", forKey: IFlySpeechConstant.voice_NAME())
        //音频采样率,目前支持的采样率有 16000 和 8000
        self.iflySpeechSynthesizer.setParameter("8000", forKey: IFlySpeechConstant.sample_RATE())
        
        //当你再不需要保存音频时，请在必要的地方加上这行。
        self.iflySpeechSynthesizer.setParameter(nil, forKey: IFlySpeechConstant.tts_AUDIO_PATH())
        //保存音频时，请在必要的地方加上这行。
        //self.iflySpeechSynthesizer.setParameter("tts.pcm", forKey: IFlySpeechConstant.tts_AUDIO_PATH())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        iflySpeechSynthesizer.stopSpeaking()
        iflySpeechSynthesizer.delegate = nil
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    // MARK:- Buttons Action
    @IBAction func startSpeaking() {
        iflySpeechSynthesizer.startSpeaking(ttsTextView.text)
    }
    
    @IBAction func stopSpeaking() {
        iflySpeechSynthesizer.stopSpeaking()
    }
    
    @IBAction func pauseSpeaking() {
        iflySpeechSynthesizer.pauseSpeaking()
    }
    
    @IBAction func resumeSpeaking() {
        iflySpeechSynthesizer.resumeSpeaking()
    }
    
    // MARK:- iflySpeechSynthesizerDelegate
    
    /** 结束回调
     
     当整个合成结束之后会回调此函数
     
     @param error 错误码
     */
    func onCompleted(_ error: IFlySpeechError!) {
        NSLog("onCompleted")
    }

    /** 开始合成回调 */
    func onSpeakBegin(){
        NSLog("onSpeakBegin")
    }
    
    /** 缓冲进度回调
     
     @param progress 缓冲进度，0-100
     @param msg 附件信息，此版本为nil
     */
    func onBufferProgress(progress:Int, msg message:String){
        NSLog("bufferProgress:\(progress)");
    }
    
    /** 播放进度回调
     
     @param progress 播放进度，0-100
     */
    func onSpeakProgress(progress:Int32){
        NSLog("play progress:\(progress)");
    }
    
    /** 暂停播放回调 */
    func onSpeakPaused(){
        NSLog("onSpeakPaused")
    }
    
    /** 恢复播放回调 */
    func onSpeakResumed(){
        NSLog("onSpeakResumed")
    }
    
    /** 正在取消回调
     
     当调用`cancel`之后会回调此函数
     */
    func onSpeakCancel(){
        NSLog("onSpeakCancel")
    }
}
