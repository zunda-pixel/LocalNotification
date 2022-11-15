//
//  Extension.swift
//

import SwiftUI

extension View {
  func alert<A: View, M: View, T>(
    title: (T) -> Text,
    presenting data: Binding<T?>,
    @ViewBuilder actions: @escaping (T) -> A,
    @ViewBuilder message: @escaping (T) -> M
  ) -> some View {
    self.alert(
      data.wrappedValue.map(title) ?? Text(""),
      isPresented: data.isPresented(),
      presenting: data.wrappedValue,
      actions: actions,
      message: message
    )
  }
  
  func alert<A: View, T>(
    _ titleKey: LocalizedStringKey,
    presenting data: Binding<T?>,
    @ViewBuilder actions: @escaping (T) -> A
  ) -> some View {
    self.alert(
      titleKey,
      isPresented: data.isPresented(),
      presenting: data.wrappedValue,
      actions: actions
    )
  }
}

extension Binding {
  func isPresented<Wrapped>() -> Binding<Bool> where Value == Wrapped? {
    .init(
      get: { self.wrappedValue != nil },
      set: { isPresented in
        if isPresented {
          self.wrappedValue = nil
        }
      }
    )
  }
}
