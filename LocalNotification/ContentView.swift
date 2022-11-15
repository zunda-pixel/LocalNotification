//
//  ContentView.swift
//

import SwiftUI

class ContentViewModel: ObservableObject {
  @Published var error: Error?
  
  func authorization() async {
    do {
      let isAuthorized = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge])
      
      if !isAuthorized {
        error = NSError(domain: "Notification Settings Error", code: 0)
      }
    } catch let newError {
      self.error = newError
    }
  }
  
  func sendLocalNotification(seconds: TimeInterval) async {
    let notification = UNUserNotificationCenter.current()
    let settings = await notification.notificationSettings()
    
    guard settings.authorizationStatus == .authorized else { return }
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
    
    let content = UNMutableNotificationContent()
    content.title = "ローカル通知(title)"
    content.subtitle = "ローカル通知(subTitle)"
    content.body = "ローカル通知(body)"
    content.sound = .default
    
    let request = UNNotificationRequest(
      identifier: "notification",
      content: content,
      trigger: trigger
    )
    
    do {
      try await notification.add(request)
    } catch let newError {
      self.error = newError
    }
  }
}

struct ContentView: View {
  @StateObject var viewModel = ContentViewModel()
  
  var body: some View {
    VStack {
      Button("Authorization") {
        Task {
          await viewModel.authorization()
        }
      }
      
      Button("Local Notification") {
        Task {
          await viewModel.sendLocalNotification(seconds: 2)
        }
      }
    }
    .alert("Error", presenting: $viewModel.error) { error in
      Button(error.localizedDescription) {}
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
