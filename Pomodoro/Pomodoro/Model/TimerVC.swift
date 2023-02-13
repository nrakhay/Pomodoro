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
    
    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(popCurrentVC))
        navigationItem.leftBarButtonItem?.tintColor = UIColor(named: Constants.backgroundColor)
    }
    
    @objc func popCurrentVC() {
        navigationController?.popViewController(animated: true)
    }
    
    func configureTimeLeftLabel() {
        timeLeftLabel.text = "\(focusTime):00"
        timeLeftLabel.textColor = UIColor(named: Constants.backgroundColor)
        timeLeftLabel.font = UIFont(name: Constants.poppinsBold, size: 86)
        
        setTimeLeftLabelConstraints()
    }
    
    func setTimeLeftLabelConstraints() {
        timeLeftLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLeftLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 30).isActive = true
        timeLeftLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    }
    
    func configureCurrentModeLabel() {
        currentModeLabel.text = "Focus on work"
        currentModeLabel.font = UIFont(name: Constants.poppinsMedium, size: 28)
        currentModeLabel.textColor = UIColor(named: Constants.backgroundColor)
        setCurrentModeLabelConstraints()
    }
    
    func setCurrentModeLabelConstraints() {
        currentModeLabel.translatesAutoresizingMaskIntoConstraints = false
        currentModeLabel.topAnchor.constraint(equalTo: timeLeftLabel.bottomAnchor).isActive = true
        currentModeLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    }
    
    func configureStartButton() {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 70, weight: .bold, scale: .large)
        startButton.setImage(UIImage(systemName: "play.circle.fill", withConfiguration: largeConfig), for: .normal)
        startButton.imageView?.tintColor = UIColor(named: Constants.backgroundColor)
        
        setStartButtonConstraints()
        startButton.addTarget(self, action: #selector(startButtonPressed), for: .touchUpInside)
    }
    
    func setStartButtonConstraints() {
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20).isActive = true
        startButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    }
    
    var currentMode = SettingTypes.focus
    
    @objc func startButtonPressed() {
        startButton.removeFromSuperview()
        
        view.addSubview(pauseButton)
        view.addSubview(stopButton)
        configurePauseButton()
        configureStopButton()
    }
    
    func configurePauseButton() {
        let mediumConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .medium)
        pauseButton.setImage(UIImage(systemName: "pause.circle.fill", withConfiguration: mediumConfig), for: .normal)
        pauseButton.imageView?.tintColor = UIColor(named: Constants.backgroundColor)
        
        setPauseButtonConstraints()
    }
    
    func setPauseButtonConstraints() {
        pauseButton.translatesAutoresizingMaskIntoConstraints = false
        pauseButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20).isActive = true
        pauseButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: -40).isActive = true
    }
    
    func configureStopButton() {
        let mediumConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .bold, scale: .medium)
        stopButton.setImage(UIImage(systemName: "stop.circle.fill", withConfiguration: mediumConfig), for: .normal)
        stopButton.imageView?.tintColor = UIColor(named: Constants.backgroundColor)
        
        setStopButtonConstraints()
    }
    
    func setStopButtonConstraints() {
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -20).isActive = true
        stopButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor, constant: 40).isActive = true
    }
    

    

}
