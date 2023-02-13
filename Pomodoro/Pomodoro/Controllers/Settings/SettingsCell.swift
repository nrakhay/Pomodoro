//
//  SettingsCell.swift
//  Pomodoro
//
//  Created by Nurali Rakhay on 08.02.2023.
//

import UIKit

protocol SettingsCellDelegate {
    func sliderValueChanged(_ settingsCell: SettingsCell , _ val: Int)
}

final class SettingsCell: UITableViewCell {
    var delegate: SettingsCellDelegate?
    
    private var settingLabel = UILabel()
    private var slider = UISlider()
    private var accentColor = UIColor(named: "Default")
    
    private var settingText = ""
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(named: Constants.backgroundColor)
        
        contentView.addSubview(settingLabel)
        contentView.addSubview(slider)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func configureCell(_ settings: CellSettings) {
        settingText = settings.text
        settingLabel.text = "\(settingText): \(settings.minutes) minutes"
        
        
        slider.minimumValue = Float(settings.minimumValueForSlider)
        slider.maximumValue = Float(settings.maximumValueForSlider)
        slider.value = Float(settings.minutes)
        
        accentColor = settings.accentColor
        
        configureSettingLabel()
        configureSlider()
        
    }
    
    func getSettingText() -> String {
        return settingText
    }
    
    private func configureSettingLabel() {
        settingLabel.font = UIFont(name: Constants.poppinsMedium, size: 20)
        settingLabel.textColor = accentColor
        
        setSettingLabelConstraints()
    }

    private func setSettingLabelConstraints() {
        settingLabel.translatesAutoresizingMaskIntoConstraints = false
        settingLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        settingLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    }
    
    private func configureSlider() {
        slider.addTarget(self, action: #selector(sliderChanged(sender:)), for: .valueChanged)
        
        slider.tintColor = accentColor
        slider.thumbTintColor = accentColor
        setSliderConstraints()
    }
    
    private func setSliderConstraints() {
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        slider.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    }
    
    @objc private func sliderChanged(sender: UISlider) {
        let sliderValue = Int(sender.value)
        settingLabel.text = "\(settingText): \(sliderValue) minutes"
    
        self.delegate?.sliderValueChanged(self, sliderValue)
    }
    

}
