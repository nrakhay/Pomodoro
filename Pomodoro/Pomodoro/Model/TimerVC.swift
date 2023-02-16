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
        
//        timeLeftInSeconds = focusTime * 60
        
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
        
        setTimeLeftLabelConstraints()
    }
    
    private func setTimeLeftLabelConstraints() {
        timeLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLeftLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30).isActive = true
        timeLeftLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    }
    
    private func configureCurrentModeLabel() {
        currentModeLabel.text = "Focus on work"
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
    
    private var currentMode = SettingTypes.focus
    
    @objc func startButtonPressed() {
        startButton.removeFromSuperview()
        
        view.addSubview(pauseButton)
        view.addSubview(stopButton)
        configurePauseButton()
        configureStopButton()
        startOrContinueCycle()
    }
    
    var counter = 0
    
    private func timeLength() -> Int{
        switch (counter % 7 == 0, counter % 2 == 0) {
        case (true, false):
            counter = 0
            return 5
        case ( _, true):
            counter += 1
            return 10
        default:
            counter += 1
            return 2
        }
    }
    
    var timer = Timer()
    
    var timeForPausePressed = 0
    private func startTimer(for time: Int) {
        var timeInSeconds = time
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            if (timeInSeconds == 0) {
                DispatchQueue.main.async {
                    self?.startOrContinueCycle()
                }
                timer.invalidate()
            }

            let min = timeInSeconds / 60
            let sec = timeInSeconds % 60

            self?.setTimeLeftLabelText(minutes: min, seconds: sec)

            print(timeInSeconds)

            timeInSeconds -= 1
            self?.timeForPausePressed = timeInSeconds
        }
    }
    
    //consider renaming this var
    private var isStartedAlready = false
    private func startOrContinueCycle() {
        if isStartedAlready && pausePressed {
            startTimer(for: timeForPausePressed)
            isStartedAlready = false
        } else {
            isStartedAlready = true
            startTimer(for: timeLength())
        }
    }
    
    private func setTimeLeftLabelText(minutes: Int, seconds: Int) {
        DispatchQueue.main.async {
            var time = "\(minutes):\(seconds)"
            
            if (seconds < 10) {
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
    
    private var pausePressed = false
    @objc private func pauseButtonPressed() {
        pausePressed = !pausePressed
        if pausePressed {
            pauseButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: mediumButtonConfig), for: .normal)
            timer.invalidate()
        } else {
            pauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: mediumButtonConfig), for: .normal)
            startOrContinueCycle()
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
         isStartedAlready = false
         
         view.addSubview(startButton)
         
         configureStartButton()
         pauseButton.removeFromSuperview()
         stopButton.removeFromSuperview()
         
         timeLeftLabel.text = "\(focusTime):00"
     }
    
    private func setStopButtonConstraints() {
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20).isActive = true
        stopButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 40).isActive = true
    }
    

    

}
