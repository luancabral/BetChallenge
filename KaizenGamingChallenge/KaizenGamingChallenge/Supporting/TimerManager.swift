//
//  TimerManager.swift
//  KaizenGamingChallenge
//
//  Created by Luan Cabral on 18/05/24.
//

import Foundation

final class TimerManager {
    private var timer: Timer
    private var targetDate: Int
    private var remaningTime: String = "00:00:00"
    
    init(timer: Timer = Timer(), targetDate: Int) {
        self.timer = timer
        self.targetDate = targetDate
    }
    
    func startCountDown(completion: @escaping (String?) -> Void) {
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: {[weak self] timer in
            guard let self = self else { return }
            updateTime(sender: self.targetDate)
            completion(remaningTime)
        })
    }
    
    func timerInvlidate() {
        timer.invalidate()
    }
    
    @objc
    func updateTime(sender: Int) {
        let userCalendar = Calendar.current
        let eventDate = Date(timeIntervalSince1970: TimeInterval(sender))
        
        guard let currentDate = getDateComponents(from: Date(), with: userCalendar),
                let targetDate = getDateComponents(from: eventDate, with: userCalendar) else { return }
        
        let timeLeft = userCalendar.dateComponents([.hour, .minute, .second], from: currentDate, to: targetDate)
        
    
        remaningTime = getRemainingTime(with: timeLeft)
        endEvent(currentDate: currentDate, eventdate: eventDate)
    }
    
    private func getDateComponents(from date: Date, with userCalendar: Calendar) -> Date? {
        let components = userCalendar.dateComponents([.hour, .minute, .month, .year, .day, .second], from: date)
        return userCalendar.date(from: components)
    }
    
    private func getRemainingTime(with date: DateComponents) -> String {
        guard let hours = date.hour, let minutes = date.minute, let seconds = date.second else { return "Live" }
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds) 
    }
    
    func endEvent(currentDate: Date, eventdate: Date) {
        if currentDate >= eventdate {
            remaningTime = "Live"
            timer.invalidate()
        }
    }
}
