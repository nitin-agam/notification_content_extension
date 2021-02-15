//
//  NotificationViewController.swift
//  NewsPlayerNotificationContentExtension
//
//  Created by Nitin A on 15/02/21.
//

import UIKit
import UserNotifications
import UserNotificationsUI
import AVKit

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    // MARK: - Properties
    @IBOutlet weak var playerBackgroundView: UIView!
    
    var playerController: AVPlayerViewController!
    
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
    }
    
    func didReceive(_ notification: UNNotification) {
        let content = notification.request.content
        playerController = AVPlayerViewController()
        preferredContentSize.height = 400 // // here, you can give exact height to your UI.
        
        // fetch video url to setup player
        if let aps = content.userInfo["aps"] as? [String: AnyHashable],
           let videoUrlString = aps["video_url"] as? String {
            if let url = URL(string: videoUrlString) {
                setupVideoPlayer(url: url)
            }
        }
    }
    
    private func setupVideoPlayer(url: URL) {
        guard let playerController = self.playerController else { return }
        let player = AVPlayer(url: url)
        playerController.player = player
        playerController.view.frame = self.playerBackgroundView.bounds
        playerBackgroundView.addSubview(playerController.view)
        addChild(playerController)
        playerController.didMove(toParent: self)
        player.play()
    }
}
