//
//  SoundEffects 1.0
//  Created by Caleb Hess on 2/22/16.
//

import AVFoundation

open class SoundEffects {
    var soundName = [String]()
    var soundPlayer = [AVAudioPlayer]()
    
    public init() {
        let fileNameList = Bundle().fileString("audio_files.txt", values: [:])
        let fileNames = fileNameList.components(separatedBy: "\n")
        
        for fileName in fileNames {
            let pieces = fileName.components(separatedBy: ".")
            
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
    
    open func playSound(_ name: String) {
        for index in 0..<soundName.count {
            if name == soundName[index] {
                soundPlayer[index].stop()
                soundPlayer[index].currentTime = 0
                soundPlayer[index].play()
            } else {
                print("could not play sound " + name)
            }
        }
    }
}
