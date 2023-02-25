//
//  PomodoroSettingsVC.swift
//  Pomodoro
//
//  Created by Nurali Rakhay on 08.02.2023.
//

import UIKit

enum Constants {
    static let settingsCell = "SettingsCell"
    static let tomatoRed = "TomatoRed"
    static let limeGreen = "LimeGreen"
    static let darkGreen = "DarkGreen"
    static let backgroundColor = "BackgroundColor"
    static let poppinsBold = "Poppins-Bold"
    static let poppinsMedium = "Poppins-Medium"
}

enum SettingTypes {
    static let focus = "Focus"
    static let shortBreak = "Short Break"
    static let longBreak = "Long Break"
}

final class PomodoroSettingsVC: UIViewController {
    private let settingsData = [
        CellSettings(text: SettingTypes.focus, minutes: 25, minimumValueForSlider: 10, maximumValueForSlider: 50, accentColor: UIColor(named: Constants.tomatoRed)),
        CellSettings(text: SettingTypes.shortBreak, minutes: 5, minimumValueForSlider: 2, maximumValueForSlider: 10, accentColor: UIColor(named: Constants.limeGreen)),
        CellSettings(text: SettingTypes.longBreak, minutes: 15, minimumValueForSlider: 10, maximumValueForSlider: 35, accentColor: UIColor(named: Constants.darkGreen))
        ]
    
    private var safeArea: UILayoutGuide!
    private var headerLabel = UILabel()
    private var sliderTableView = UITableView()
    private var startButton = UIButton()
    private var settingsCell = SettingsCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        safeArea = view.layoutMarginsGuide
        view.backgroundColor = #colorLiteral(red: 1, green: 0.9921568627, blue: 0.8941176471, alpha: 1)
                
        view.addSubview(headerLabel)
        view.addSubview(sliderTableView)
        view.addSubview(startButton)
        
        configureHeaderLabel()
        configureStartButton()
        configureSliderTableView()
    }
    
    private func configureHeaderLabel() {
        headerLabel.text = "Get ready to full-focus mode!"
        headerLabel.textColor = UIColor(named: Constants.tomatoRed)
        headerLabel.numberOfLines = 0
        headerLabel.font = UIFont(name: Constants.poppinsBold, size: 36)
        
        setHeaderLabelConstraints()
    }
    
    private func setHeaderLabelConstraints() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: 8).isActive = true
    }
    
    private func configureSliderTableView() {
        sliderTableView.delegate = self
        sliderTableView.dataSource = self
        setSliderTableViewConstraints()
        
        
        sliderTableView.rowHeight = 100
        sliderTableView.backgroundColor = UIColor(named: Constants.backgroundColor)
        sliderTableView.isScrollEnabled = false
        sliderTableView.separatorStyle = .none
        
        sliderTableView.register(SettingsCell.self, forCellReuseIdentifier: Constants.settingsCell)
    }
    
    private func setSliderTableViewConstraints() {
        sliderTableView.translatesAutoresizingMaskIntoConstraints = false
        sliderTableView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
        sliderTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 8).isActive = true
        sliderTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -8).isActive = true
        sliderTableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    private func configureStartButton() {
        startButton.setTitle("Start!", for: .normal)
        
        startButton.layer.cornerRadius = 10
        startButton.layer.backgroundColor = UIColor(named: Constants.tomatoRed)?.cgColor
        startButton.setTitleColor(UIColor(named: Constants.backgroundColor), for: .normal)
        startButton.titleLabel?.font = UIFont(name: Constants.poppinsMedium, size: 18)
        setStartButtonConstraints()
        
        startButton.addTarget(self, action: #selector(startTapped), for: .touchUpInside)
    }
    
    private var focusTime = 25
    private var shortBreak = 5
    private var longBreak = 15
    
    @objc private func startTapped() {
        let vc = TimerVC(focus: focusTime,
                         shortBreak: shortBreak,
                         longBreak: longBreak)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func setStartButtonConstraints() {
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        startButton.widthAnchor.constraint(equalTo: safeArea.widthAnchor).isActive = true
        startButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor).isActive = true
        startButton.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor).isActive = true
    }
}

//MARK: - TableView
extension PomodoroSettingsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.settingsCell) as! SettingsCell
        
        let setting = self.settingsData[indexPath.row]
        cell.configureCell(setting)
        cell.selectionStyle = .none
        cell.delegate = self
        
        return cell
    }
}

extension PomodoroSettingsVC: SettingsCellDelegate {
    func sliderValueChanged(_ settingsCell: SettingsCell, _ val: Int) {
        let settingTitle = settingsCell.getSettingText()
        
        switch settingTitle {
        case SettingTypes.focus:
            focusTime = val
        case SettingTypes.shortBreak:
            shortBreak = val
        case SettingTypes.longBreak:
            longBreak = val
        default:
            return
        }
    }
    
}
