//
//  ViewController.swift
//  Reconocimiento de voz
//
//  Created by Alejandro Sklar on 2/5/17.
//  Copyright © 2017 Alejandro Sklar. All rights reserved.
//

import UIKit
import Speech

class ViewController: UIViewController, AVAudioRecorderDelegate {

    @IBAction func grabar(_ sender: Any) {
        recordingAudioSetup()
    }
    @IBOutlet var textView: UITextView!
    var audioRecordingSession = AVAudioSession()
    var audioRecorder : AVAudioRecorder!
    let audioFileName : String = "audio-recordered.m4a"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //recordingAudioSetup()
        
        //recognizeSpeech()  esto se coloca para escoger un adio que se le coloca a la app en este caso seria la vos de juan gabriel
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    func recognizeSpeech(){
       
        SFSpeechRecognizer.requestAuthorization { (authStatus) in
            if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                //   esto tambien se saca junto con la ultima llave    if let urlPath = Bundle.main.url(forResource: "audio-recordered", withExtension: "m4a") {
                 let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: self.directoryURL()! as URL)
                    recognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
                        if let error = error {
                            print("algo ha ido mal: \(error.localizedDescription)")
                        } else {
                            self.textView.text = String(describing: result?.bestTranscription.formattedString)
                            
                        }
                    })
                    
                    
               
            } else {
                print("No tengo autorizacion para acceder al Spessch")
            }
        }
        
    }
    func recordingAudioSetup() {
        audioRecordingSession = AVAudioSession.sharedInstance()
        do{
            try audioRecordingSession.setCategory(AVAudioSessionCategoryRecord)
            try audioRecordingSession.setActive(true)
            audioRecordingSession.requestRecordPermission({ [unowned self](allowed:Bool) in
                if allowed {
                    
                    //Hay que empezar a grabar  despues del permiso
                    self.startRecording()
                } else {
                    print("Necesito permisos para usar el microfono")
                }
            })
            
        } catch {
            print("Ha habido un error al configurar al audio recorder")
        }
    }
    func directoryURL() -> NSURL? {
    let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = urls[0] as URL
        do {
        return try documentsDirectory.appendingPathComponent(audioFileName) as NSURL
        } catch {
            print("No hemos podido crear una estructura de carpeta de auio")
        }
        return nil
    
    }
    
    func startRecording() {
        let settings = [AVFormatIDKey : Int(kAudioFormatMPEG4AAC),
                       AVSampleRateKey: 12000.0,
                       AVNumberOfChannelsKey: 1 as NSNumber,
                       AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue] as [String : Any]
        do {
            audioRecorder = try AVAudioRecorder(url: directoryURL()! as URL, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.stopRecording), userInfo: nil, repeats: false)
        } catch {
            print("No se ha podido grabar el Audio Correctamente")
        }
        
        
    }
    func stopRecording() {
        audioRecorder.stop()
        audioRecorder = nil
      
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.recognizeSpeech), userInfo: nil, repeats: false)
    }
}



//clase 226







