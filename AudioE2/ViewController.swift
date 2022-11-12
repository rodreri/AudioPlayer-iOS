//
//  ViewController.swift
//  AudioE2
//
//  Created by Erick Rodrigo Minero Pineda on 05/11/22.
//

import AVFoundation
import UIKit
import AVKit

class ViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnPlay: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var sldrDuration: UISlider!
    @IBOutlet weak var sldrVol: UISlider!
    
    var audioPlayer = AVAudioPlayer()
    
    // Para medir el tiempo, ejecutar de acuerdo al tiempo
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Controlar elementos
        self.view.addSubview(sldrDuration)
        sldrDuration.addTarget(self, action: #selector(durationChanged), for: .valueChanged)
        self.view.addSubview(btnStop)
        btnStop.addTarget(self, action: #selector(btnStopTouch), for: .touchUpInside)
        self.view.addSubview(btnPlay)
        btnPlay.addTarget(self, action: #selector(btnPlayTouch), for: .touchUpInside)
        self.view.addSubview(sldrVol)
        sldrVol.addTarget(self, action: #selector(volumeChanged), for: .valueChanged)
        
        // Seteamos el audio
        setAudio()
    }
    
    @IBAction func btnPlayTouch(_ sender: Any) {
        audioPlayer.play()
        btnStop.isEnabled = true
        btnPlay.isEnabled = false
    }
    
    @IBAction func btnStopTouch(_ sender: Any) {
        audioPlayer.stop()
        btnStop.isEnabled = false
        btnPlay.isEnabled = true
    }
    
    @IBAction func durationChanged(_ sender: Any) {
        audioPlayer.currentTime = Double(sldrDuration.value)
    }
    
    @IBAction func volumeChanged(_ sender: Any) {
        audioPlayer.volume = sldrVol.value
    }
    
    func setAudio() {
        guard let URL = Bundle.main.url(forResource: "MUSIC3", withExtension: "mp3") else {
            print("ERROR: No se encontro el archivo")
            return
        }
        
        do {
            // Intentamos cargar el archivo de audio
            audioPlayer = try AVAudioPlayer(contentsOf: URL)
            startInterface()
        } catch {
            print("ERROR: Al reproducir el audio, \(error.localizedDescription)")
        }
    }
    
    func startInterface() {
        // Almacena tiempo actual
        timer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(updateSliderDuration),
            userInfo: nil,
            repeats: true
        )
        
        sldrDuration.value = 0
        sldrDuration.maximumValue = Float(audioPlayer.duration)
        btnStop.isEnabled = false
        btnPlay.isEnabled = true
        audioPlayer.delegate = self
        audioPlayer.volume = 0.5
        sldrVol.value = 0.5
    }
    
    // Para mover el slider de acuerdo al tiempo actual
    @objc func updateSliderDuration() {
        sldrDuration.value = Float(audioPlayer.currentTime)
    }
    
    // Cerrar el timer
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer?.invalidate()
    }
}
