//
//  SoundEffects 1.0
//  Created by Caleb Hess on 2/22/16.
//

import AVFoundation

public class SoundEffects {
    var soundName = [String]()
    var soundPlayer = [AVAudioPlayer]()
    
    public init() {
        let fileNameList = File.string("audio_files.txt", values: [:])
        let fileNames = fileNameList.componentsSeparatedByString("\n")
        
        for fileName in fileNames {
            let pieces = fileName.componentsSeparatedByString(".")
            
            if let path = NSBundle.mainBundle().pathForResource(pieces[0], ofType: pieces[1]) {
                let soundLocation = NSURL(fileURLWithPath: path)
                
                do {
                    let newPlayer = try AVAudioPlayer(contentsOfURL: soundLocation)
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
    
    public func playSound(name: String) {
        for index in 0..<soundName.count {
            if name == soundName[index] {
                soundPlayer[index].stop()
                soundPlayer[index].currentTime = 0
                soundPlayer[index].play()
            }
        }
    }
}
