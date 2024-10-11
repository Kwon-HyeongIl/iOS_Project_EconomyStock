//
//  Price1View.swift
//  EconomyStock
//
//  Created by 권형일 on 10/11/24.
//

import SwiftUI

struct Price1View: View {
    @Environment(NavigationRouter.self) var navigationRouter
    @Bindable var viewModel: CourseViewModel
    
    var body: some View {
        Text("Price")
    }
}

#Preview {
    Price1View(viewModel: CourseViewModel(course: .DUMMY_COURSE))
}
