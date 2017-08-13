//
//  SoundEffects.swift
//  March 20, 2017
//  Caleb Hess
//
//  toolkit-swift
//

import AVFoundation

public class SoundEffects {
    public var soundName = [String]()
    public var soundPlayer = [AVAudioPlayer]()
    
    public func add(_ fileName: String) {
        let pieces = fileName.components(separatedBy: ".")
        
        if pieces.count > 1 {
            if let path = Bundle.main.path(forResource: pieces[0], ofType: pieces[1]) {
                let soundLocation = URL(fileURLWithPath: path)
                
                do {
                    let newPlayer = try AVAudioPlayer(contentsOf: soundLocation)
                    newPlayer.prepareToPlay()
                    soundPlayer.append(newPlayer)
                    soundName.append(pieces[0])
                } catch {
                    print("could set up audio file: '" + fileName + "'")
                }
            } else {
                print("could not find audio file: '" + fileName + "'")
            }
        }
    }
    
    public func play(_ name: String) {
        for index in 0..<soundName.count {
            if name == soundName[index] {
                soundPlayer[index].stop()
                soundPlayer[index].currentTime = 0
                soundPlayer[index].play()
            }
        }
    }
    
    public func stop(_ name: String) {
        for index in 0..<soundName.count {
            if name == soundName[index] {
                soundPlayer[index].stop()
            }
        }
    }
}
