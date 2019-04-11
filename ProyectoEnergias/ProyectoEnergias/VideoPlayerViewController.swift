//
//  VideoPlayerViewController.swift
//  EcoBook
//
//  Created by Ali Bryan Villegas Zavala on 4/7/19.
//  Copyright © 2019 Tec de Monterrey. All rights reserved.
//

import UIKit
import AVKit
class VideoPlayerViewController: UIViewController {
    var resourceUrl = ""
    override var shouldAutorotate: Bool {
        return true
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeLeft
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let value = UIInterfaceOrientation.landscapeLeft.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        print("VIDEO")
        print(resourceUrl)
        if resourceUrl != "" {
            showSpinner(onView: self.view)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.removeSpinner()
            let videoURL = URL(string: self.resourceUrl)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = ExtendedAVPlayerViewController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
            NotificationCenter.default.addObserver(self, selector: #selector(self.videoDidEnd), name:
                NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            }
            
        }
        else{
            
        }
        // Do any additional setup after loading the view.
    }
    @objc func videoDidEnd(notification: NSNotification) {
        print("VIDEOENDED")
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        let value = UIInterfaceOrientation.portrait.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
