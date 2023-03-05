//
//  TimerVC.swift
//  Pomodoro
//
//  Created by Nurali Rakhay on 09.02.2023.
//

import UIKit
import AVFoundation

final class TimerVC: UIViewController {
    private var safeArea: UILayoutGuide!
    
    private enum ButtonConfigs {
        static let largeButtonConfig = UIImage.SymbolConfiguration(pointSize: 70, weight: .bold, scale: .large)
        static let mediumButtonConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .medium)
    }

    private let timeLeftLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: Constants.backgroundColor)
        label.font = UIFont(name: Constants.poppinsBold, size: 86)
        label.textAlignment = .center
        return label
    }()
    
    private var currentModeLabel: UILabel = {
        let label = UILabel()
        label.text = "It's time to focus!"
        label.font = UIFont(name: Constants.poppinsMedium, size: 28)
        label.textColor = UIColor(named: Constants.backgroundColor)
        return label
    }()
    
    private var startButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: ButtonConfigs.largeButtonConfig), for: .normal)
        button.imageView?.tintColor = UIColor(named: Constants.backgroundColor)
        return button
    }()
    
    private var pauseButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: ButtonConfigs.mediumButtonConfig), for: .normal)
        button.imageView?.tintColor = UIColor(named: Constants.backgroundColor)
        return button
    }()
    private var stopButton: UIButton = {
        let mediumConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .medium)
        let button = UIButton()
        button.setImage(UIImage(systemName: "stop.circle.fill", withConfiguration: mediumConfig), for: .normal)
        button.imageView?.tintColor = UIColor(named: Constants.backgroundColor)
        return button
    }()
    
    private var focusTime: Int
    private var shortBreakTime: Int
    private var longBreakTime: Int
    
    private var player: AVAudioPlayer?
    
    init(focus: Int, shortBreak: Int, longBreak: Int) {
        self.focusTime = focus
        self.shortBreakTime = shortBreak
        self.longBreakTime = longBreak
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: Constants.tomatoRed)
        safeArea = view.layoutMarginsGuide
        
        
        view.addSubview(timeLeftLabel)
        view.addSubview(currentModeLabel)
        view.addSubview(startButton)

        configureNavigationBar()
        configureTimeLeftLabel()
        configureCurrentModeLabel()
        configureStartButton()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(popCurrentVC))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: Constants.backgroundColor)
    }
    
    @objc private func popCurrentVC() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureTimeLeftLabel() {
        timeLeftLabel.text = "\(focusTime):00"
        
        timeLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLeftLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30).isActive = true
        timeLeftLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        timeLeftLabel.widthAnchor.constraint(equalTo: safeArea.widthAnchor).isActive = true
    }
    
    private func configureCurrentModeLabel() {
        currentModeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentModeLabel.topAnchor.constraint(equalTo: timeLeftLabel.bottomAnchor).isActive = true
        currentModeLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    }
    
    
    private func configureStartButton() {
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20).isActive = true
        startButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
    }
    
    @objc func startButtonPressed() {
        startButton.removeFromSuperview()
        
        view.addSubview(pauseButton)
        view.addSubview(stopButton)
        configurePauseButton()
        configureStopButton()
        
        startCycle()
    }
    
    private var cycleCounter = 0
    
    private func timeLength() -> Int{
        switch (cycleCounter % 7 == 0, cycleCounter % 2 == 0) {
        case (true, false):
            cycleCounter = 0
            currentModeLabel.text = "Enjoy your long break!"
            return longBreakTime * 60 - 1
//            return 5
        case ( _, true):
            cycleCounter += 1
            currentModeLabel.text = "It's time to focus!"
            return focusTime * 60 - 1
//            return 7
        default:
            cycleCounter += 1
            currentModeLabel.text = "Take a short break!"
            return shortBreakTime * 60 - 1
//            return 3
        }
    }
    
    private var timer = Timer()
    
    private var secondsLeftWhenPaused = 0
    private func startTimer(for time: Int) {
        var timeSet = time
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            if (timeSet <= 0) {
                DispatchQueue.main.async {
                    timer.invalidate()
                    
                    let url = Bundle.main.url(forResource: "bellSound", withExtension: "mp3")
                    self?.player = try! AVAudioPlayer(contentsOf: url!)
                    self?.player!.play()
                    
                    self?.startCycle()
                }
            }
            
            let min = timeSet / 60
            let sec = timeSet % 60

            self?.setTimeLeftLabelText(minutes: min, seconds: sec)

            timeSet -= 1
            self?.secondsLeftWhenPaused = timeSet
        }
    }
    
    private func startCycle() {
        startTimer(for: timeLength())
    }

    private func setTimeLeftLabelText(minutes: Int, seconds: Int) {
        DispatchQueue.main.async {
            var time = "\(minutes):\(seconds)"
            
//            if seconds < 10 && minutes < 10 {
//                time = "0\(minutes):0\(seconds)"
//            } else if (seconds < 10) {
//                time = "\(minutes):0\(seconds)"
//            } else if (minutes < 10) {
//                time = "0\(minutes):\(seconds)"
//            }
            
            if seconds < 10 {
                time = "\(minutes):0\(seconds)"
            }
            
            self.timeLeftLabel.text = time
        }
    }
    
    
    private func configurePauseButton() {
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20).isActive = true
        pauseButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: -40).isActive = true
        pauseButton.addTarget(self, action: #selector(pauseButtonPressed), for: .touchUpInside)
    }
    
    private var pauseIsOn = false
    @objc private func pauseButtonPressed() {
        pauseIsOn = !pauseIsOn
        if pauseIsOn {
            pauseButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: ButtonConfigs.mediumButtonConfig), for: .normal)
            timer.invalidate()
        } else {
            pauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: ButtonConfigs.mediumButtonConfig), for: .normal)
            startTimer(for: secondsLeftWhenPaused)
        }
        
    }
    
    private func configureStopButton() {
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20).isActive = true
        stopButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 40).isActive = true
        stopButton.addTarget(self, action: #selector(stopButtonPressed), for: .touchUpInside)
    }
                             
     @objc private func stopButtonPressed() {
         timer.invalidate()
         cycleCounter = 0
         
         view.addSubview(startButton)
         
         configureStartButton()
         pauseButton.removeFromSuperview()
         stopButton.removeFromSuperview()
         
         timeLeftLabel.text = "\(focusTime):00"
         currentModeLabel.text = "It's time to focus!"
     }
}
