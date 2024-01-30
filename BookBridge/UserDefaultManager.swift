//
//  UserDefaultsManager.swift
//  bitirmedeneme
//
//  Created by Beste Kocaoglu on 22.12.2023.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let userDefaults = UserDefaults.standard
    private let avatarKeyPrefix = "SelectedAvatar_"

    func saveSelectedAvatar(forUserID userID: String, avatar: String?) {
        userDefaults.set(avatar, forKey: avatarKey(forUserID: userID))
    }

    func getSelectedAvatar(forUserID userID: String) -> String? {
        return userDefaults.string(forKey: avatarKey(forUserID: userID))
    }

    func removeSelectedAvatar(forUserID userID: String) {
        userDefaults.removeObject(forKey: avatarKey(forUserID: userID))
    }

    private func avatarKey(forUserID userID: String) -> String {
        return avatarKeyPrefix + userID
    }
}




