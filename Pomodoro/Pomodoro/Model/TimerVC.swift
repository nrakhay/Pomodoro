//
//  TimerVC.swift
//  Pomodoro
//
//  Created by Nurali Rakhay on 09.02.2023.
//

import UIKit

final class TimerVC: UIViewController {
    private var safeArea: UILayoutGuide!

    private var timeLeftLabel = UILabel()
    private var currentModeLabel = UILabel()
    private var startButton = UIButton()
    
    private var pauseButton = UIButton()
    private var stopButton = UIButton()
    
    private var focusTime: Int
    private var shortBreakTime: Int
    private var longBreakTime: Int
    
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
        timeLeftLabel.textColor = UIColor(named: Constants.backgroundColor)
        timeLeftLabel.font = UIFont(name: Constants.poppinsBold, size: 86)
        timeLeftLabel.textAlignment = .center
        
        setTimeLeftLabelConstraints()
    }
    
    private func setTimeLeftLabelConstraints() {
        timeLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLeftLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30).isActive = true
        timeLeftLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
        timeLeftLabel.widthAnchor.constraint(equalTo: safeArea.widthAnchor).isActive = true
    }
    
    private func configureCurrentModeLabel() {
        currentModeLabel.text = "It's time to focus!"
        currentModeLabel.font = UIFont(name: Constants.poppinsMedium, size: 28)
        currentModeLabel.textColor = UIColor(named: Constants.backgroundColor)
        setCurrentModeLabelConstraints()
    }
    
    private func setCurrentModeLabelConstraints() {
        currentModeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentModeLabel.topAnchor.constraint(equalTo: timeLeftLabel.bottomAnchor).isActive = true
        currentModeLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    }
    
    private let largeButtonConfig = UIImage.SymbolConfiguration(pointSize: 70, weight: .bold, scale: .large)
    private func configureStartButton() {
        startButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: largeButtonConfig), for: .normal)
        startButton.imageView?.tintColor = UIColor(named: Constants.backgroundColor)
        
        setStartButtonConstraints()
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
    }
    
    private func setStartButtonConstraints() {
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20).isActive = true
        startButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
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
            return 3
        case ( _, true):
            cycleCounter += 1
            currentModeLabel.text = "It's time to focus!"
            return 5
        default:
            cycleCounter += 1
            currentModeLabel.text = "Take a short break!"
            return 2
        }
    }
    
    private var timer = Timer()
    
    private var timeForPausePressed = 0
    private func startTimer(for time: Int) {
        var timeInSeconds = time
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            if (timeInSeconds <= 0) {
                DispatchQueue.main.async {
                    self?.startCycle()
                }
                
            }

            let min = timeInSeconds / 60
            let sec = timeInSeconds % 60

            self?.setTimeLeftLabelText(minutes: min, seconds: sec)

            timeInSeconds -= 1
            self?.timeForPausePressed = timeInSeconds
        }
    }
    
    //consider renaming this var
    private var isStartedAlready = false
    
    private func startCycle() {
        timer.invalidate()
        startTimer(for: timeLength())
    }
    
    private func resumeCycle() {
        startTimer(for: timeForPausePressed)
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
    
    private let mediumButtonConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .medium)
    private func configurePauseButton() {
        pauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: mediumButtonConfig), for: .normal)
        pauseButton.imageView?.tintColor = UIColor(named: Constants.backgroundColor)
        
        setPauseButtonConstraints()
        pauseButton.addTarget(self, action: #selector(pauseButtonPressed), for: .touchUpInside)
    }
    
    private func setPauseButtonConstraints() {
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20).isActive = true
        pauseButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: -40).isActive = true
    }
    
    private var pauseIsOn = false
    @objc private func pauseButtonPressed() {
        pauseIsOn = !pauseIsOn
        if pauseIsOn {
            pauseButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: mediumButtonConfig), for: .normal)
            timer.invalidate()
        } else {
            pauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: mediumButtonConfig), for: .normal)
            resumeCycle()
        }
        
    }
    
    private func configureStopButton() {
        let mediumConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .medium)
        stopButton.setImage(UIImage(systemName: "stop.circle.fill", withConfiguration: mediumConfig), for: .normal)
        stopButton.imageView?.tintColor = UIColor(named: Constants.backgroundColor)
        
        setStopButtonConstraints()
        stopButton.addTarget(self, action: #selector(stopButtonPressed), for: .touchUpInside)
    }
                             
     @objc private func stopButtonPressed() {
         timer.invalidate()
         cycleCounter = 0
         isStartedAlready = false
         
         view.addSubview(startButton)
         
         configureStartButton()
         pauseButton.removeFromSuperview()
         stopButton.removeFromSuperview()
         
         
         timeLeftLabel.text = "\(focusTime):00"
         currentModeLabel.text = "It's time to focus!"
     }
    
    private func setStopButtonConstraints() {
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20).isActive = true
        stopButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 40).isActive = true
    }
    

    

}
