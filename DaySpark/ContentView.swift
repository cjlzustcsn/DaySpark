//
//  ContentView.swift
//  DaySpark
//
//  Created by 89 on 2025/7/19.
//

import SwiftUI

// AnniversaryItem 数据结构
struct AnniversaryItem: Identifiable {
    let id: UUID
    let event: String
    let date: Date
    let color: Color
    let icon: String
    let createdAt: Date // 添加创建时间
    var isPinned: Bool = false // 添加置顶状态
}

// HeaderView 组件
struct HeaderView: View {
    let mainGradient: LinearGradient
    let buttonGradient: LinearGradient
    let onAddButtonTapped: () -> Void
    
    var body: some View {
        HStack {
            Text("DaySpark")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.8, green: 0.5, blue: 0.2))
                .shadow(color: Color(red: 1.0, green: 0.898, blue: 0.705, opacity: 0.3), radius: 2, x: 0, y: 2)
            Spacer()
            Button(action: onAddButtonTapped) {
                ZStack {
                    buttonGradient
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                    Image(systemName: "plus")
                        .font(.title2)
                        .foregroundColor(Color(red: 0.8, green: 0.5, blue: 0.2))
                }
            }
            .buttonStyle(PlainButtonStyle())
            .modifier(AppleBreathingButtonModifier())
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(height: 56)
        .background(
            ZStack {
                // 主渐变背景
                mainGradient
                
                // 顶部柔和阴影
                VStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 1.0, green: 0.898, blue: 0.705, opacity: 0.15),
                                    Color.clear
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 8)
                    Spacer()
                }
                
                // 底部柔和阴影
                VStack {
                    Spacer()
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.clear,
                                    Color(red: 1.0, green: 0.898, blue: 0.705, opacity: 0.08)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 6)
                }
            }
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 0, style: .continuous)
        )
        .shadow(
            color: Color(red: 1.0, green: 0.898, blue: 0.705, opacity: 0.12),
            radius: 12,
            x: 0,
            y: 4
        )
    }
}

// MainContentView 组件
struct MainContentView: View {
    let anniversaryItems: [AnniversaryItem]
    let cardSpacing: CGFloat
    let cardAreaCornerRadius: CGFloat
    let floatingButtonSize: CGFloat
    let floatingButtonPadding: CGFloat
    let onEdit: (AnniversaryItem) -> Void
    let onDelete: (AnniversaryItem) -> Void
    let onPin: (AnniversaryItem) -> Void
    let onTap: (AnniversaryItem) -> Void
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .cornerRadius(cardAreaCornerRadius, corners: [.topLeft, .topRight])
                .shadow(color: Color(red: 1.0, green: 0.898, blue: 0.705, opacity: 0.10), radius: 8, x: 0, y: -4)
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: cardSpacing) {
                    ForEach(anniversaryItems) { item in
                        AnniversaryCardView(
                            item: item,
                            onEdit: { onEdit(item) },
                            onDelete: { onDelete(item) },
                            onPin: { onPin(item) },
                            onTap: { onTap(item) }
                        )
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                    }
                }
                .padding(.top, 24)
                .padding(.horizontal)
                .padding(.bottom, floatingButtonSize + floatingButtonPadding + 50)
            }
        }
    }
}

// FloatingButtonView 组件
struct FloatingButtonView: View {
    let buttonGradient: LinearGradient
    let floatingButtonSize: CGFloat
    let floatingButtonPadding: CGFloat
    let isAnimatingButton: Bool
    let onButtonTapped: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: onButtonTapped) {
                    ZStack {
                        buttonGradient
                            .frame(width: floatingButtonSize, height: floatingButtonSize)
                            .clipShape(Circle())
                            .shadow(color: Color(red: 1.0, green: 0.898, blue: 0.705, opacity: 0.18), radius: 10, x: 0, y: 6)
                        Circle()
                            .stroke(Color.white.opacity(0.15), lineWidth: 8)
                            .frame(width: floatingButtonSize + 16, height: floatingButtonSize + 16)
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(Color(red: 0.8, green: 0.5, blue: 0.2))
                    }
                    .scaleEffect(isAnimatingButton ? 1.25 : 1.0)
                    .rotationEffect(.degrees(isAnimatingButton ? 20 : 0))
                    .opacity(isAnimatingButton ? 0.7 : 1.0)
                    .animation(.spring(response: 0.35, dampingFraction: 0.45), value: isAnimatingButton)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, floatingButtonPadding)
                .padding(.bottom, 32)
                .accessibilityLabel("抽签")
            }
        }
    }
}

// EncourageCardView 组件
struct EncourageCardView: View {
    let encourageText: String
    let cardAnim: Bool
    let cardGlow: Bool
    let cardContentAppear: Bool
    let buttonOpacity: Double
    let onDismiss: () -> Void
    let onSave: (() -> Void)?
    
    init(encourageText: String, cardAnim: Bool, cardGlow: Bool, cardContentAppear: Bool, buttonOpacity: Double, onDismiss: @escaping () -> Void, onSave: (() -> Void)? = nil) {
        self.encourageText = encourageText
        self.cardAnim = cardAnim
        self.cardGlow = cardGlow
        self.cardContentAppear = cardContentAppear
        self.buttonOpacity = buttonOpacity
        self.onDismiss = onDismiss
        self.onSave = onSave
    }
    
    var body: some View {
        VisualEffectBlur(blurStyle: .systemMaterial)
            .ignoresSafeArea()
            .transition(.opacity)
            .animation(.easeInOut(duration: 0.25), value: true)
            .onTapGesture {
                onDismiss()
            }
        VStack {
            Spacer()
            // 卡片本体动效
            ZStack {
                // 光晕扩散
                Circle()
                    .fill(
                        RadialGradient(gradient: Gradient(colors: [Color(red: 1.0, green: 0.95, blue: 0.7, opacity: 0.7), Color.clear]), center: .center, startRadius: 0, endRadius: 320)
                    )
                    .frame(width: 420, height: 420)
                    .scaleEffect(cardGlow ? 1.18 : 0.7)
                    .opacity(cardGlow ? 0.8 : 0)
                    .blur(radius: 24)
                    .animation(.easeOut(duration: 0.7), value: cardGlow)
                // 裱起来的画框卡片
                ZStack {
                    // 外层金色描边
                    RoundedRectangle(cornerRadius: 40, style: .continuous)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 0.98, green: 0.85, blue: 0.45),
                                    Color(red: 0.95, green: 0.8, blue: 0.5)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 6
                        )
                        .shadow(color: Color.yellow.opacity(0.18), radius: 8, x: 0, y: 4)
                        .frame(width: 240, height: 180)
                    // 内层卡片本体
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(red: 1.0, green: 0.976, blue: 0.941),
                                    Color(red: 1.0, green: 0.898, blue: 0.705)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: Color(red: 0.9, green: 0.8, blue: 0.5, opacity: 0.18), radius: 24, x: 0, y: 12)
                        .frame(width: 240, height: 180)
                        .overlay(
                            // 四角装饰
                            ZStack {
                                ForEach(0..<4) { i in
                                    Image(systemName: "leaf.fill")
                                        .resizable()
                                        .frame(width: 18, height: 18)
                                        .foregroundColor(Color(red: 0.98, green: 0.85, blue: 0.45, opacity: 0.7))
                                        .rotationEffect(.degrees(Double(i) * 90))
                                        .offset(x: i == 1 ? 110 : (i == 3 ? -110 : 0), y: i == 0 ? -70 : (i == 2 ? 70 : 0))
                                }
                            }
                        )
                    // 卡片内容
                    VStack(spacing: 8) {
                        Text("\u{201C}")
                            .font(.system(size: 20, weight: .bold, design: .serif))
                            .foregroundColor(Color(red: 0.98, green: 0.85, blue: 0.45, opacity: 0.7))
                            .padding(.top, 2)
                        Text(encourageText)
                            .font(.system(size: 26, weight: .semibold, design: .serif))
                            .italic()
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(red: 0.7, green: 0.4, blue: 0.2))
                            .lineSpacing(6)
                            .padding(.horizontal, 8)
                            .opacity(cardContentAppear ? 1 : 0)
                            .animation(.easeIn(duration: 0.45).delay(0.22), value: cardContentAppear)
                        Text("\u{201D}")
                            .font(.system(size: 20, weight: .bold, design: .serif))
                            .foregroundColor(Color(red: 0.98, green: 0.85, blue: 0.45, opacity: 0.7))
                            .padding(.bottom, 2)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .padding(.vertical, 14)
                    .padding(.horizontal, 10)
                    .frame(width: 240, height: 180)
                }
                .frame(width: 240, height: 180)
                .scaleEffect(cardAnim ? 1 : 0.7)
                .rotationEffect(.degrees(cardAnim ? 0 : -16))
                .opacity(cardAnim ? 1 : 0)
                .animation(.interpolatingSpring(stiffness: 180, damping: 16), value: cardAnim)
            }
            // 按钮只做opacity淡出
            HStack(spacing: 28) {
                Button(action: {}) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("分享")
                    }
                    .font(.title3)
                    .foregroundColor(Color(red: 0.8, green: 0.5, blue: 0.2))
                }
                .opacity(buttonOpacity)
                .animation(.easeInOut(duration: 0.25), value: buttonOpacity)
                Button(action: { onSave?() }) {
                    HStack {
                        Image(systemName: "square.and.arrow.down")
                        Text("保存")
                    }
                    .font(.title3)
                    .foregroundColor(Color(red: 0.8, green: 0.5, blue: 0.2))
                }
                .opacity(buttonOpacity)
                .animation(.easeInOut(duration: 0.25), value: buttonOpacity)
            }
            .padding(.top, 12)
            Spacer()
        }
        .onAppear {
            // 动画初始化逻辑需要在父组件中处理
        }
    }
}



struct ContentView: View {
    // 抽签功能已移动到详情页面
    @State private var showAddSheet = false
    @State private var showEditSheet = false
    @State private var editingItem: AnniversaryItem?
    @State private var showDetailSheet = false
    @State private var selectedDetailItem: AnniversaryItem? = nil
    
    // 呼吸动效状态
    @State private var floatingLights: [FloatingLight] = []
    @State private var headerBreathingScale: CGFloat = 1.0
    @State private var contentBreathingPhase: CGFloat = 0
    
    // 全局展开状态管理
    @State private var expandedItemId: UUID? = nil

    @State private var anniversaryItems: [AnniversaryItem] = {
        let items = [
            AnniversaryItem(id: UUID(), event: "生日", date: Date().addingTimeInterval(86400 * 2), color: .orange, icon: "🎂", createdAt: Date().addingTimeInterval(-86400 * 5)),
            AnniversaryItem(id: UUID(), event: "元旦", date: Date().addingTimeInterval(86400 * 10), color: .blue, icon: "🎉", createdAt: Date().addingTimeInterval(-86400 * 2))
        ]
        // 按创建时间排序（最新的在前）
        return items.sorted { $0.createdAt > $1.createdAt }
    }()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Apple风格的呼吸背景
                AppleBreathingBackground()
                
                // 浮动光点
                ForEach(floatingLights) { light in
                    AppleFloatingLight(index: light.index)
                }
                
                VStack(spacing: 0) {
                    // 顶部标题栏 - Apple风格
                    AppleBreathingHeaderView(
                        onAddButtonTapped: {
                            showAddSheet = true
                        }
                    )
                    .padding(.top, geometry.safeAreaInsets.top)
                    .scaleEffect(headerBreathingScale)
                    
                    // 内容区域
                    AppleBreathingContentView(
                        anniversaryItems: $anniversaryItems,
                        expandedItemId: $expandedItemId,
                        onEdit: { item in
                            editingItem = item
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                showEditSheet = true
                            }
                        },
                        onDelete: { item in
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                if let index = anniversaryItems.firstIndex(where: { $0.id == item.id }) {
                                    anniversaryItems.remove(at: index)
                                }
                            }
                        },
                        onPin: { item in
                            // 点击置顶时自动退出展开状态
                            expandedItemId = nil
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                if let index = anniversaryItems.firstIndex(where: { $0.id == item.id }) {
                                    var updatedItem = anniversaryItems[index]
                                    
                                    if updatedItem.isPinned {
                                        updatedItem.isPinned = false
                                        anniversaryItems.remove(at: index)
                                        anniversaryItems.append(updatedItem)
                                        anniversaryItems.sort { item1, item2 in
                                            if item1.isPinned == item2.isPinned {
                                                return item1.createdAt > item2.createdAt
                                            } else {
                                                return item1.isPinned && !item2.isPinned
                                            }
                                        }
                                    } else {
                                        updatedItem.isPinned = true
                                        anniversaryItems.remove(at: index)
                                        anniversaryItems.insert(updatedItem, at: 0)
                                    }
                                }
                            }
                        },
                        onTap: { item in
                            // 点击item时自动退出展开状态
                            expandedItemId = nil
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                self.selectedDetailItem = item
                                self.showDetailSheet = true
                            }
                        }
                    )
                    .edgesIgnoringSafeArea(.bottom)
                }
                .edgesIgnoringSafeArea(.top)
            }
        }
        .onAppear {
            startBreathingAnimations()
            generateFloatingLights()
        }
        .sheet(isPresented: $showAddSheet) {
            AddAnniversaryView(
                onDismiss: { showAddSheet = false },
                onSave: { event, date, color, icon in
                    let newItem = AnniversaryItem(id: UUID(), event: event, date: date, color: color, icon: icon, createdAt: Date())
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        anniversaryItems.append(newItem)
                        // 按创建时间重新排序（最新的在前）
                        anniversaryItems.sort { item1, item2 in
                            if item1.isPinned == item2.isPinned {
                                // 如果置顶状态相同，按创建时间排序
                                return item1.createdAt > item2.createdAt
                            } else {
                                // 置顶的排在前面
                                return item1.isPinned && !item2.isPinned
                            }
                        }
                    }
                    showAddSheet = false
                }
            )
        }
        .sheet(isPresented: Binding(
            get: { showEditSheet && editingItem != nil },
            set: { showEditSheet = $0 }
        )) {
            if let editingItem = editingItem {
                AddAnniversaryView(
                    editingItem: editingItem,
                    onDismiss: { 
                        showEditSheet = false
                        self.editingItem = nil // 使用self来访问状态变量
                    },
                    onSave: { event, date, color, icon in
                        if let index = anniversaryItems.firstIndex(where: { $0.id == editingItem.id }) {
                            var updatedItem = AnniversaryItem(
                                id: editingItem.id,
                                event: event,
                                date: date,
                                color: color,
                                icon: icon,
                                createdAt: editingItem.createdAt // 保持创建时间
                            )
                            // 保持置顶状态
                            updatedItem.isPinned = editingItem.isPinned
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.8)) {
                                anniversaryItems[index] = updatedItem
                            }
                        }
                        showEditSheet = false
                        self.editingItem = nil // 使用self来访问状态变量
                    }
                )
            }
        }
        .overlay(
            Group {
                if showDetailSheet, let selectedDetailItem = selectedDetailItem {
                    AnniversaryDetailView(
                        item: selectedDetailItem,
                        onDismiss: {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                self.showDetailSheet = false
                                self.selectedDetailItem = nil
                            }
                        }
                    )
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        ))
                        .zIndex(1000)
                }
            }
        )
    }
    
    private func startBreathingAnimations() {
        // 标题栏呼吸动效
        withAnimation(
            Animation.easeInOut(duration: 4.0)
                .repeatForever(autoreverses: true)
        ) {
            headerBreathingScale = 1.01
        }
    }
    
    private func generateFloatingLights() {
        floatingLights = (0..<3).map { FloatingLight(index: $0) }
    }
}



// MARK: - Apple风格呼吸背景
struct AppleBreathingBackground: View {
    @State private var breathingPhase: CGFloat = 0
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            RadialGradient(
                gradient: Gradient(colors: [
                    Color(.systemGray6).opacity(0.3 + 0.2 * Double(sin(breathingPhase))),
                    Color(.systemBackground)
                ]),
                center: .center,
                startRadius: 100,
                endRadius: 300
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true), value: breathingPhase)
        }
        .onAppear {
            startBreathing()
        }
    }
    
    private func startBreathing() {
        withAnimation(.easeInOut(duration: 4.0).repeatForever(autoreverses: true)) {
            breathingPhase = 1.0
        }
    }
}

// MARK: - Apple风格浮动光点
struct AppleFloatingLight: View {
    let index: Int
    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 0.1
    @State private var scale: CGFloat = 0.8
    
    var body: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [
                        Color(.systemBlue).opacity(0.1),
                        Color.clear
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 60 + CGFloat(index * 20), height: 60 + CGFloat(index * 20))
            .offset(offset)
            .opacity(opacity)
            .scaleEffect(scale)
            .blur(radius: 20)
            .onAppear {
                startFloating()
            }
    }
    
    private func startFloating() {
        let randomX = CGFloat.random(in: -100...100)
        let randomY = CGFloat.random(in: -200...200)
        let duration = Double.random(in: 8...12)
        let delay = Double(index) * 1.5
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
                offset = CGSize(width: randomX, height: randomY)
                opacity = Double.random(in: 0.05...0.15)
                scale = CGFloat.random(in: 0.6...1.2)
            }
        }
    }
}

// MARK: - Apple风格呼吸卡片修饰器
struct AppleBreathingCardModifier: ViewModifier {
    let item: AnniversaryItem
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingOpacity: Double = 1.0
    @State private var shadowRadius: CGFloat = 6
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(breathingScale)
            .opacity(breathingOpacity)
            .shadow(
                color: item.isPinned ? 
                    Color.blue.opacity(0.15 + 0.05 * Double(sin(breathingScale * .pi))) : 
                    item.color.opacity(0.10 + 0.03 * Double(sin(breathingScale * .pi))),
                radius: shadowRadius,
                x: 0,
                y: 3
            )
            .onAppear {
                startAppleBreathing()
            }
    }
    
    private func startAppleBreathing() {
        withAnimation(
            Animation.easeInOut(duration: 6.0)
                .repeatForever(autoreverses: true)
        ) {
            breathingScale = 1.01
            breathingOpacity = 0.98
            shadowRadius = 8
        }
    }
}

// MARK: - Apple风格呼吸图标修饰器
struct AppleBreathingIconModifier: ViewModifier {
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingRotation: Double = 0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(breathingScale)
            .rotationEffect(.degrees(breathingRotation))
            .onAppear {
                startAppleBreathing()
            }
    }
    
    private func startAppleBreathing() {
        // 微妙的缩放呼吸
        withAnimation(
            Animation.easeInOut(duration: 4.0)
                .repeatForever(autoreverses: true)
        ) {
            breathingScale = 1.05
        }
        
        // 非常轻微的摇摆
        withAnimation(
            Animation.easeInOut(duration: 8.0)
                .repeatForever(autoreverses: true)
        ) {
            breathingRotation = 2
        }
    }
}

// MARK: - Apple风格呼吸按钮修饰器
struct AppleBreathingButtonModifier: ViewModifier {
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingOpacity: Double = 1.0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(breathingScale)
            .opacity(breathingOpacity)
            .onAppear {
                startAppleBreathing()
            }
    }
    
    private func startAppleBreathing() {
        withAnimation(
            Animation.easeInOut(duration: 3.0)
                .repeatForever(autoreverses: true)
        ) {
            breathingScale = 1.03
            breathingOpacity = 0.9
        }
    }
}

// MARK: - Apple风格呼吸进度条修饰器
struct AppleBreathingProgressModifier: ViewModifier {
    let color: Color
    @State private var breathingScale: CGFloat = 1.0
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(breathingScale)
            .onAppear {
                startAppleBreathing()
            }
    }
    
    private func startAppleBreathing() {
        withAnimation(
            Animation.easeInOut(duration: 4.0)
                .repeatForever(autoreverses: true)
        ) {
            breathingScale = 1.02
        }
    }
}

// MARK: - 详情页静态卡片组件
struct DetailPageCardView: View {
    let item: AnniversaryItem
    
    // 计算进度条进度
    private func calculateProgress(for targetDate: Date) -> Double {
        let calendar = Calendar.current
        let now = Date()
        
        // 如果纪念日已经过了，进度条为100%
        if targetDate <= now {
            return 1.0
        }
        
        // 计算创建时间到目标日期的总天数
        let totalDays = calendar.dateComponents([.day], from: item.createdAt, to: targetDate).day ?? 1
        
        // 计算从创建时间到现在已经经过的天数
        let elapsedDays = calendar.dateComponents([.day], from: item.createdAt, to: now).day ?? 0
        
        // 计算进度：(已经经过的日期 - 创建日) / (目标日 - 创建日)
        let progress = Double(elapsedDays) / Double(totalDays)
        
        // 确保进度在0-1范围内
        return max(0.0, min(1.0, progress))
    }
    
    var body: some View {
        // 纪念日卡片 - 静态版本，不包含呼吸动效
        RoundedRectangle(cornerRadius: 22, style: .continuous)
            .fill(
                item.isPinned ? 
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.blue.opacity(0.15),
                        Color.blue.opacity(0.08)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ) : 
                LinearGradient(
                    gradient: Gradient(colors: [
                        item.color.opacity(0.13),
                        item.color.opacity(0.13)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                // 置顶标识 - 左下角
                Group {
                    if item.isPinned {
                        VStack {
                            Spacer()
                            HStack {
                                // 简洁的向上箭头角标
                                ZStack {
                                    // 三角形背景
                                    Triangle()
                                        .fill(Color.blue.opacity(0.9))
                                        .frame(width: 20, height: 16)
                                    // 向上箭头
                                    Image(systemName: "chevron.up")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                        .offset(y: -1)
                                }
                                .padding(.bottom, 8)
                                .padding(.leading, 8)
                                Spacer()
                            }
                        }
                    }
                }
            )
            .shadow(color: item.isPinned ? Color.blue.opacity(0.15) : item.color.opacity(0.10), radius: 6, x: 0, y: 3)
            .frame(height: 112)
            .overlay(
                AnniversaryItemView(
                    type: item.event,
                    targetDate: DateFormatter.localizedString(from: item.date, dateStyle: .medium, timeStyle: .none),
                    daysLeft: Calendar.current.dateComponents([.day], from: Date(), to: item.date).day ?? 0,
                    progress: calculateProgress(for: item.date),
                    isFuture: item.date > Date(),
                    icon: item.icon,
                    color: item.color,
                    isPinned: item.isPinned
                )
            )
    }
}

// 毛玻璃封装
import UIKit
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// 让 cornerRadius 只作用于底部圆角
fileprivate extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

fileprivate struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

// 三角形形状 - 用于置顶角标
fileprivate struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

// AnniversaryCardView 组件
struct AnniversaryCardView: View {
    let item: AnniversaryItem
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onPin: () -> Void // 添加置顶功能
    let onTap: (() -> Void)? // 添加点击展开功能
    @State private var offset: CGFloat = 0
    @State private var isSwiped = false
    
    // 计算进度条进度
    private func calculateProgress(for targetDate: Date) -> Double {
        let calendar = Calendar.current
        let now = Date()
        
        // 如果纪念日已经过了，进度条为100%
        if targetDate <= now {
            return 1.0
        }
        
        // 计算创建时间到目标日期的总天数
        let totalDays = calendar.dateComponents([.day], from: item.createdAt, to: targetDate).day ?? 1
        
        // 计算从创建时间到现在已经经过的天数
        let elapsedDays = calendar.dateComponents([.day], from: item.createdAt, to: now).day ?? 0
        
        // 计算进度：(已经经过的日期 - 创建日) / (目标日 - 创建日)
        let progress = Double(elapsedDays) / Double(totalDays)
        
        // 确保进度在0-1范围内
        return max(0.0, min(1.0, progress))
    }
    
    var body: some View {
        ZStack {
            // 背景操作按钮区域 - 编辑区域
            HStack(spacing: 0) {
                Spacer()
                // 置顶/取消置顶按钮 - 左侧与纪念日卡片贴合
                Button(action: onPin) {
                    ZStack {
                        Rectangle()
                            .fill(item.isPinned ? Color.gray : Color.blue)
                            .frame(width: 60, height: 112)
                        VStack(spacing: 4) {
                            Image(systemName: item.isPinned ? "pin.slash" : "pin")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                            Text(item.isPinned ? "取消" : "置顶")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                .cornerRadius(22, corners: [.topLeft, .bottomLeft]) // 左侧圆角与纪念日卡片贴合
                
                // 编辑按钮
                Button(action: onEdit) {
                    ZStack {
                        Rectangle()
                            .fill(Color.orange)
                            .frame(width: 60, height: 112)
                        VStack(spacing: 4) {
                            Image(systemName: "pencil")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                            Text("编辑")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
                
                // 删除按钮
                Button(action: onDelete) {
                    ZStack {
                        Rectangle()
                            .fill(Color.red)
                            .frame(width: 60, height: 112)
                        VStack(spacing: 4) {
                            Image(systemName: "trash")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                            Text("删除")
                                .font(.caption)
                                .foregroundColor(.white)
                        }
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
            .cornerRadius(22, corners: [.topRight, .bottomRight]) // 整体右侧圆角
            .offset(x: offset < 0 ? 0 : 180) // 编辑区域初始隐藏，左划时出现
            
            // 纪念日卡片 - 宽度不变，只移动位置
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    item.isPinned ? 
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.blue.opacity(0.15),
                            Color.blue.opacity(0.08)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ) : 
                    LinearGradient(
                        gradient: Gradient(colors: [
                            item.color.opacity(0.13),
                            item.color.opacity(0.13)
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    // 置顶标识 - 左下角
                    Group {
                        if item.isPinned {
                            VStack {
                                Spacer()
                                HStack {
                                    // 简洁的向上箭头角标
                                    ZStack {
                                        // 三角形背景
                                        Triangle()
                                            .fill(Color.blue.opacity(0.9))
                                            .frame(width: 20, height: 16)
                                        // 向上箭头
                                        Image(systemName: "chevron.up")
                                            .font(.system(size: 10, weight: .bold))
                                            .foregroundColor(.white)
                                            .offset(y: -1)
                                    }
                                    .padding(.bottom, 8)
                                    .padding(.leading, 8)
                                    Spacer()
                                }
                            }
                        }
                    }
                )
                .shadow(color: item.isPinned ? Color.blue.opacity(0.15) : item.color.opacity(0.10), radius: 6, x: 0, y: 3)
                .frame(height: 112)
                .modifier(AppleBreathingCardModifier(item: item))
                .overlay(
                    AnniversaryItemView(
                        type: item.event,
                        targetDate: DateFormatter.localizedString(from: item.date, dateStyle: .medium, timeStyle: .none),
                        daysLeft: Calendar.current.dateComponents([.day], from: Date(), to: item.date).day ?? 0,
                        progress: calculateProgress(for: item.date),
                        isFuture: item.date > Date(),
                        icon: item.icon,
                        color: item.color,
                        isPinned: item.isPinned
                    )
                )
                .offset(x: offset) // 纪念日卡片跟随左划移动
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.width < 0 {
                                // 只允许向左滑动，纪念日卡片跟手平移
                                offset = max(value.translation.width, -180) // 三个按钮总共180px
                            }
                        }
                        .onEnded { value in
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                if value.translation.width < -90 {
                                    // 滑动超过一半，显示编辑区域
                                    offset = -180
                                    isSwiped = true
                                } else {
                                    // 滑动不足，隐藏编辑区域
                                    offset = 0
                                    isSwiped = false
                                }
                            }
                        }
                )
                .onTapGesture {
                    // 点击时隐藏编辑区域或展开详情
                    if isSwiped {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            offset = 0
                            isSwiped = false
                        }
                    } else {
                        // 展开详情页面
                        onTap?()
                    }
                }
        }
        .clipped() // 确保超出部分被截断
    }
}

// AnniversaryItemView 需支持icon和color参数
struct AnniversaryItemView: View {
    let type: String
    let targetDate: String
    let daysLeft: Int
    let progress: Double
    let isFuture: Bool
    let icon: String
    let color: Color
    let isPinned: Bool
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.7))
                    .frame(width: 44, height: 44)
                Text(icon)
                    .font(.system(size: 24))
                    .modifier(AppleBreathingIconModifier())
            }
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(type)
                        .font(.headline)
                        .foregroundColor(isPinned ? Color.blue : Color(red: 0.8, green: 0.5, blue: 0.2))
                    if isPinned {
                        Text("置顶")
                            .font(.caption2)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.blue.opacity(0.1))
                            )
                    }
                }
                Text(targetDate)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Spacer(minLength: 0)
                ProgressView(value: progress)
                    .accentColor(isFuture ? Color(red: 0.9, green: 0.6, blue: 0.3) : Color(red: 0.4, green: 0.7, blue: 0.4))
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
                    .animation(.easeInOut(duration: 0.8), value: progress)
                    .modifier(AppleBreathingProgressModifier(color: isFuture ? Color(red: 0.9, green: 0.6, blue: 0.3) : Color(red: 0.4, green: 0.7, blue: 0.4)))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack(alignment: .trailing, spacing: 4) {
                if daysLeft == 0 {
                    Text("已经抵达")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 1.0, green: 0.7, blue: 0.2))
                } else if isFuture {
                    Text("还有")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(abs(daysLeft))天")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.9, green: 0.6, blue: 0.3))
                } else {
                    Text("已陪伴")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("\(abs(daysLeft))天")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.4, green: 0.7, blue: 0.4))
                }
                Spacer()
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
    }
}

// MARK: - Apple风格呼吸标题栏
struct AppleBreathingHeaderView: View {
    let onAddButtonTapped: () -> Void
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingOpacity: Double = 1.0
    
    var body: some View {
        HStack {
            Text("DaySpark")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundColor(.primary)
                .shadow(color: Color(.systemGray4).opacity(0.3), radius: 2, x: 0, y: 2)
            Spacer()
            Button(action: onAddButtonTapped) {
                ZStack {
                    Circle()
                        .fill(.regularMaterial)
                        .frame(width: 44, height: 44)
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                    Image(systemName: "plus")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.orange)
                }
            }
            .scaleEffect(breathingScale)
            .opacity(breathingOpacity)
            .onAppear {
                startAppleBreathing()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        )
    }
    
    private func startAppleBreathing() {
        withAnimation(
            Animation.easeInOut(duration: 3.0)
                .repeatForever(autoreverses: true)
        ) {
            breathingScale = 1.05
            breathingOpacity = 0.9
        }
    }
}

// MARK: - Apple风格呼吸内容区域
struct AppleBreathingContentView: View {
    @Binding var anniversaryItems: [AnniversaryItem]
    @Binding var expandedItemId: UUID?
    let onEdit: (AnniversaryItem) -> Void
    let onDelete: (AnniversaryItem) -> Void
    let onPin: (AnniversaryItem) -> Void
    let onTap: (AnniversaryItem) -> Void
    
    @State private var contentBreathingPhase: CGFloat = 0
    @State private var draggedItemId: UUID? = nil
    @State private var dropTargetId: UUID? = nil
    
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .cornerRadius(24, corners: [.topLeft, .topRight])
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: -8)
                .onTapGesture {
                    // 点击背景区域时退出展开状态
                    if expandedItemId != nil {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            expandedItemId = nil
                        }
                    }
                }
            
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 20) {
                    ForEach(anniversaryItems) { item in
                        AppleBreathingAnniversaryCard(
                            item: item,
                            isExpanded: expandedItemId == item.id,
                            isDragging: draggedItemId == item.id,
                            isDropTarget: dropTargetId == item.id,
                            onExpandChange: { isExpanded in
                                if isExpanded {
                                    expandedItemId = item.id
                                } else {
                                    expandedItemId = nil
                                }
                            },
                            onEdit: { onEdit(item) },
                            onDelete: { onDelete(item) },
                            onPin: { onPin(item) },
                            onTap: { onTap(item) }
                        )
                        .transition(.asymmetric(
                            insertion: .scale.combined(with: .opacity),
                            removal: .scale.combined(with: .opacity)
                        ))
                        .onDrag {
                            // 开始拖拽时退出展开状态
                            if expandedItemId != nil {
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                    expandedItemId = nil
                                }
                            }
                            // 设置拖拽状态
                            draggedItemId = item.id
                            return NSItemProvider(object: item.id.uuidString as NSString)
                        }
                        .onLongPressGesture(minimumDuration: 0.5) {
                            // 长按手势，触发拖拽
                        }
                        .onDrop(of: [.text], delegate: SimpleDropDelegate(
                            item: item,
                            items: $anniversaryItems,
                            draggedItemId: $draggedItemId,
                            dropTargetId: $dropTargetId
                        ))
                    }
                }
                .padding(.top, 24)
                .padding(.horizontal, 20)
                .padding(.bottom, 100)
                .contentShape(Rectangle())
                .onTapGesture {
                    // 点击非纪念日item区域时退出展开状态
                    if expandedItemId != nil {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            expandedItemId = nil
                        }
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                // 点击ScrollView空白区域时退出展开状态
                if expandedItemId != nil {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        expandedItemId = nil
                    }
                }
            }
        }
        .onAppear {
            startContentBreathing()
        }
    }
    
    private func startContentBreathing() {
        withAnimation(.easeInOut(duration: 6.0).repeatForever(autoreverses: true)) {
            contentBreathingPhase = 1.0
        }
    }
}

// MARK: - 增强拖拽排序代理
struct SimpleDropDelegate: DropDelegate {
    let item: AnniversaryItem
    @Binding var items: [AnniversaryItem]
    @Binding var draggedItemId: UUID?
    @Binding var dropTargetId: UUID?
    
    func performDrop(info: DropInfo) -> Bool {
        // 重置拖拽状态
        draggedItemId = nil
        dropTargetId = nil
        
        guard let itemProvider = info.itemProviders(for: [.text]).first else { return false }
        
        itemProvider.loadObject(ofClass: NSString.self) { string, _ in
            DispatchQueue.main.async {
                if let idString = string as? String, let draggedId = UUID(uuidString: idString) {
                    self.reorderItems(draggedId: draggedId, droppedId: self.item.id)
                }
            }
        }
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let itemProvider = info.itemProviders(for: [.text]).first else { return }
        
        itemProvider.loadObject(ofClass: NSString.self) { string, _ in
            DispatchQueue.main.async {
                if let idString = string as? String, let draggedId = UUID(uuidString: idString) {
                    self.draggedItemId = draggedId
                    self.dropTargetId = self.item.id
                }
            }
        }
    }
    
    func dropExited(info: DropInfo) {
        dropTargetId = nil
    }
    
    func dropUpdated(info: DropInfo) -> DropProposal? {
        return DropProposal(operation: .move)
    }
    
    private func reorderItems(draggedId: UUID, droppedId: UUID) {
        guard let draggedIndex = items.firstIndex(where: { $0.id == draggedId }),
              let droppedIndex = items.firstIndex(where: { $0.id == droppedId }),
              draggedIndex != droppedIndex else { return }
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            let draggedItem = items.remove(at: draggedIndex)
            items.insert(draggedItem, at: droppedIndex)
        }
    }
}

// MARK: - Apple风格呼吸纪念日卡片
struct AppleBreathingAnniversaryCard: View {
    let item: AnniversaryItem
    let isExpanded: Bool
    let isDragging: Bool
    let isDropTarget: Bool
    let onExpandChange: (Bool) -> Void
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onPin: () -> Void
    let onTap: () -> Void
    
    @State private var offset: CGFloat = 0
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingOpacity: Double = 1.0
    @State private var shadowRadius: CGFloat = 12
    
    // 计算进度条进度
    private func calculateProgress(for targetDate: Date) -> Double {
        let calendar = Calendar.current
        let now = Date()
        
        if targetDate <= now {
            return 1.0
        }
        
        let totalDays = calendar.dateComponents([.day], from: item.createdAt, to: targetDate).day ?? 1
        let elapsedDays = calendar.dateComponents([.day], from: item.createdAt, to: now).day ?? 0
        let progress = Double(elapsedDays) / Double(totalDays)
        
        return max(0.0, min(1.0, progress))
    }
    
    var body: some View {
        ZStack {
            // 背景操作按钮区域 - Apple风格
            HStack(spacing: 0) {
                Spacer()
                
                // 操作按钮容器
                HStack(spacing: 8) {
                    // 置顶/取消置顶按钮
                    AppleBreathingActionButton(
                        icon: item.isPinned ? "pin.slash" : "pin",
                        title: item.isPinned ? "取消" : "置顶",
                        color: item.isPinned ? Color.gray : Color.blue,
                        action: onPin
                    )
                    
                    // 编辑按钮
                    AppleBreathingActionButton(
                        icon: "pencil",
                        title: "编辑",
                        color: Color.orange,
                        action: onEdit
                    )
                    
                    // 删除按钮
                    AppleBreathingActionButton(
                        icon: "trash",
                        title: "删除",
                        color: Color.red,
                        action: onDelete
                    )
                }
                .padding(.trailing, 20)
                .opacity(isExpanded ? 1 : 0)
                .scaleEffect(isExpanded ? 1.0 : 0.8)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isExpanded)
            }
            
            // 主卡片
            AppleBreathingCard {
                VStack(alignment: .leading, spacing: 16) {
                    // 顶部信息
                    HStack {
                        Text(item.icon)
                            .font(.system(size: 32))
                            .modifier(AppleBreathingIconModifier())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.event)
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.primary)
                            Text(DateFormatter.localizedString(from: item.date, dateStyle: .medium, timeStyle: .none))
                                .font(.system(size: 14, weight: .regular))
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        
                        if item.isPinned {
                            Image(systemName: "pin.fill")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.blue)
                        }
                    }
                    
                    // 进度条
                    VStack(alignment: .leading, spacing: 8) {
                        let progress = calculateProgress(for: item.date)
                        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: item.date).day ?? 0
                        let isFuture = item.date > Date()
                        
                        ProgressView(value: progress)
                            .accentColor(isFuture ? Color.orange : Color.green)
                            .scaleEffect(x: 1, y: 1.5, anchor: .center)
                            .modifier(AppleBreathingProgressModifier(color: isFuture ? Color.orange : Color.green))
                        
                        HStack {
                            Text(isFuture ? "还有" : "已陪伴")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.secondary)
                            Spacer()
                            Text("\(abs(daysLeft))天")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(isFuture ? Color.orange : Color.green)
                        }
                    }
                }
                .padding(20)
            }
            .offset(x: offset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.width < 0 {
                            // 限制最大滑动距离，让动效更自然
                            let maxOffset: CGFloat = -200
                            offset = max(value.translation.width, maxOffset)
                            let shouldExpand = value.translation.width < -30
                            if shouldExpand != isExpanded {
                                onExpandChange(shouldExpand)
                            }
                        }
                    }
                    .onEnded { value in
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            if value.translation.width < -80 {
                                // 完全展开
                                offset = -200
                                onExpandChange(true)
                            } else {
                                // 回弹到原位
                                offset = 0
                                onExpandChange(false)
                            }
                        }
                    }
            )
            .onTapGesture {
                if !isExpanded {
                    onTap()
                }
            }
            .onChange(of: isExpanded) { newValue in
                // 同步offset状态
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    offset = newValue ? -200 : 0
                }
            }
            // 拖拽状态视觉反馈
            .scaleEffect(isDragging ? 1.05 : 1.0)
            .shadow(
                color: isDragging ? Color.blue.opacity(0.3) : Color.clear,
                radius: isDragging ? 20 : 0,
                x: 0,
                y: isDragging ? 10 : 0
            )
            .overlay(
                // 拖拽目标指示器
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isDropTarget ? Color.blue : Color.clear,
                        lineWidth: 3
                    )
                    .scaleEffect(isDropTarget ? 1.02 : 1.0)
                    .opacity(isDropTarget ? 0.8 : 0)
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isDragging)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isDropTarget)
            .scaleEffect(breathingScale)
            .opacity(breathingOpacity)
            .shadow(
                color: item.isPinned ? Color.blue.opacity(0.15) : item.color.opacity(0.1),
                radius: shadowRadius,
                x: 0,
                y: 6
            )
            .onAppear {
                startAppleBreathing()
            }
        }
    }
    
    private func startAppleBreathing() {
        withAnimation(
            Animation.easeInOut(duration: 5.0)
                .repeatForever(autoreverses: true)
        ) {
            breathingScale = 1.02
            breathingOpacity = 0.98
            shadowRadius = 16
        }
    }
}

// MARK: - Apple风格呼吸详情页标题栏
struct AppleBreathingDetailHeaderView: View {
    let onDismiss: () -> Void
    let onAddThought: () -> Void
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingOpacity: Double = 1.0
    
    var body: some View {
        HStack {
            Button(action: onDismiss) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                    Text("返回")
                        .font(.system(size: 17, weight: .regular))
                }
                .foregroundColor(.primary)
            }
            .scaleEffect(breathingScale)
            .opacity(breathingOpacity)
            
            Spacer()
            Text("详情")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.primary)
            Spacer()
            
            Button(action: onAddThought) {
                ZStack {
                    Circle()
                        .fill(.regularMaterial)
                        .frame(width: 36, height: 36)
                        .shadow(color: Color.black.opacity(0.1), radius: 6, x: 0, y: 3)
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.orange)
                }
            }
            .scaleEffect(breathingScale)
            .opacity(breathingOpacity)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
        )
        .onAppear {
            startAppleBreathing()
        }
    }
    
    private func startAppleBreathing() {
        withAnimation(
            Animation.easeInOut(duration: 3.0)
                .repeatForever(autoreverses: true)
        ) {
            breathingScale = 1.05
            breathingOpacity = 0.9
        }
    }
}

// MARK: - Apple风格呼吸时间线视图
struct AppleBreathingTimelineView: View {
    let thoughts: [ThoughtItem]
    let onEdit: (ThoughtItem) -> Void
    let onDelete: (ThoughtItem) -> Void
    
    @State private var contentBreathingPhase: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // 时间线标题栏
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("时光记录")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.primary)
                    Text("记录你的想法和感受")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            // 时间线内容区域
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(thoughts) { thought in
                        AppleBreathingThoughtItemView(
                            thought: thought,
                            onEdit: onEdit,
                            onDelete: onDelete
                        )
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.9).combined(with: .opacity),
                            removal: .scale(scale: 0.8).combined(with: .opacity)
                        ))
                    }
                    
                    if thoughts.isEmpty {
                        AppleBreathingEmptyStateView()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
                .padding(.bottom, 100)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.regularMaterial)
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: -8)
        )
        .onAppear {
            startContentBreathing()
        }
    }
    
    private func startContentBreathing() {
        withAnimation(.easeInOut(duration: 6.0).repeatForever(autoreverses: true)) {
            contentBreathingPhase = 1.0
        }
    }
}

// MARK: - Apple风格呼吸想法项视图
struct AppleBreathingThoughtItemView: View {
    let thought: ThoughtItem
    let onEdit: (ThoughtItem) -> Void
    let onDelete: (ThoughtItem) -> Void
    
    @State private var showActionSheet = false
    @State private var showDeleteAlert = false
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingOpacity: Double = 1.0
    @State private var shadowRadius: CGFloat = 8
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // 时间线圆点和连接线
            VStack(spacing: 0) {
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.12))
                        .frame(width: 28, height: 28)
                    Circle()
                        .fill(Color.orange)
                        .frame(width: 12, height: 12)
                    Circle()
                        .fill(Color.white)
                        .frame(width: 4, height: 4)
                }
                Rectangle()
                    .fill(Color.orange.opacity(0.08))
                    .frame(width: 2)
                    .frame(maxHeight: .infinity)
            }
            
            // 内容卡片
            VStack(alignment: .leading, spacing: 14) {
                Text(thought.content)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.primary)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(2)
                
                HStack(spacing: 8) {
                    Image(systemName: "clock")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.secondary)
                    Text(DateFormatter.localizedString(from: thought.createdAt, dateStyle: .medium, timeStyle: .short))
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.secondary)
                    Spacer()
                    
                    Button(action: { showActionSheet = true }) {
                        Image(systemName: "ellipsis.circle")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.secondary)
                            .frame(width: 28, height: 28)
                            .background(
                                Circle()
                                    .fill(Color.secondary.opacity(0.08))
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .scaleEffect(showActionSheet ? 0.9 : 1.0)
                    .animation(.easeInOut(duration: 0.1), value: showActionSheet)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.regularMaterial)
                    .shadow(color: Color.black.opacity(0.06), radius: shadowRadius, x: 0, y: 3)
            )
            .scaleEffect(breathingScale)
            .opacity(breathingOpacity)
            
            Spacer()
        }
        .onAppear {
            startAppleBreathing()
        }
        .confirmationDialog("选择操作", isPresented: $showActionSheet, titleVisibility: .hidden) {
            Button(action: { onEdit(thought) }) {
                HStack {
                    Image(systemName: "pencil")
                        .font(.system(size: 16, weight: .medium))
                    Text("编辑")
                        .font(.system(size: 16, weight: .regular))
                }
            }
            
            Button("删除", role: .destructive) {
                showDeleteAlert = true
            }
            
            Button("取消", role: .cancel) { }
        }
        .alert("确认删除", isPresented: $showDeleteAlert) {
            Button("删除", role: .destructive) {
                onDelete(thought)
            }
            Button("取消", role: .cancel) { }
        } message: {
            Text("确定要删除这条记录吗？此操作无法撤销。")
        }
    }
    
    private func startAppleBreathing() {
        withAnimation(
            Animation.easeInOut(duration: 5.0)
                .repeatForever(autoreverses: true)
        ) {
            breathingScale = 1.02
            breathingOpacity = 0.98
            shadowRadius = 12
        }
    }
}

// MARK: - Apple风格呼吸空状态视图
struct AppleBreathingEmptyStateView: View {
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingOpacity: Double = 1.0
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.06))
                    .frame(width: 72, height: 72)
                Image(systemName: "heart.text.square")
                    .font(.system(size: 28, weight: .light))
                    .foregroundColor(.orange.opacity(0.6))
            }
            .scaleEffect(breathingScale)
            .opacity(breathingOpacity)
            
            VStack(spacing: 8) {
                Text("还没有记录")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primary)
                Text("点击右上角的 + 按钮，记录下你的想法吧")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 60)
        .padding(.horizontal, 40)
        .onAppear {
            startAppleBreathing()
        }
    }
    
    private func startAppleBreathing() {
        withAnimation(
            Animation.easeInOut(duration: 4.0)
                .repeatForever(autoreverses: true)
        ) {
            breathingScale = 1.05
            breathingOpacity = 0.9
        }
    }
}

// MARK: - Apple风格呼吸悬浮按钮
struct AppleBreathingFloatingButton: View {
    let isAnimatingButton: Bool
    let onButtonTapped: () -> Void
    
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingOpacity: Double = 1.0
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                Button(action: onButtonTapped) {
                    ZStack {
                        Circle()
                            .fill(.regularMaterial)
                            .frame(width: 52, height: 52)
                            .shadow(color: Color.black.opacity(0.15), radius: 12, x: 0, y: 6)
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 24, weight: .semibold))
                            .foregroundColor(.orange)
                    }
                    .scaleEffect(isAnimatingButton ? 1.25 : breathingScale)
                    .rotationEffect(.degrees(isAnimatingButton ? 20 : 0))
                    .opacity(isAnimatingButton ? 0.7 : breathingOpacity)
                    .animation(.spring(response: 0.35, dampingFraction: 0.45), value: isAnimatingButton)
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.trailing, 20)
                .padding(.bottom, 30)
                .accessibilityLabel("抽签")
            }
        }
        .onAppear {
            startAppleBreathing()
        }
    }
    
    private func startAppleBreathing() {
        withAnimation(
            Animation.easeInOut(duration: 3.0)
                .repeatForever(autoreverses: true)
        ) {
            breathingScale = 1.08
            breathingOpacity = 0.9
        }
    }
}

// MARK: - Apple风格呼吸鼓励卡片
struct AppleBreathingEncourageCard: View {
    let encourageText: String
    let onDismiss: () -> Void
    let onSave: () -> Void
    
    @State private var cardScale: CGFloat = 0.8
    @State private var cardOpacity: Double = 0
    @State private var contentOpacity: Double = 0
    @State private var buttonScale: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    dismissCard()
                }
            
            VStack(spacing: 24) {
                Text("✨ 今日抽签 ✨")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(encourageText)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                
                HStack(spacing: 16) {
                    Button(action: dismissCard) {
                        Text("关闭")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.regularMaterial)
                            )
                    }
                    
                    Button(action: {
                        onSave()
                        dismissCard()
                    }) {
                        Text("保存")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.orange)
                            )
                    }
                    .scaleEffect(buttonScale)
                }
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(.regularMaterial)
                    .shadow(color: Color.black.opacity(0.2), radius: 20, x: 0, y: 10)
            )
            .scaleEffect(cardScale)
            .opacity(cardOpacity)
        }
        .onAppear {
            showCard()
        }
    }
    
    private func showCard() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            cardScale = 1.0
            cardOpacity = 1.0
        }
        
        withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
            contentOpacity = 1.0
        }
        
        withAnimation(
            Animation.easeInOut(duration: 2.0)
                .repeatForever(autoreverses: true)
        ) {
            buttonScale = 1.05
        }
    }
    
    private func dismissCard() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            cardScale = 0.8
            cardOpacity = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onDismiss()
        }
    }
}

// MARK: - Apple风格呼吸添加想法视图
struct AppleBreathingAddThoughtView: View {
    let onDismiss: () -> Void
    let onSave: (String) -> Void
    @State private var thoughtText: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingOpacity: Double = 1.0
    
    var body: some View {
        ZStack {
            AppleBreathingBackground()
            
            VStack(spacing: 0) {
                // 导航栏
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .medium))
                            Text("取消")
                                .font(.system(size: 17, weight: .regular))
                        }
                        .foregroundColor(.primary)
                    }
                    Spacer()
                    Text("记录想法")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                    Spacer()
                    Button(action: {
                        if !thoughtText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            onSave(thoughtText)
                        }
                    }) {
                        Text("保存")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(thoughtText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .secondary : .orange)
                    }
                    .disabled(thoughtText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                )
                
                // 输入区域
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("写下你的想法")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                        Text("记录下此刻的感受和想法")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    AppleBreathingCard {
                        TextEditor(text: $thoughtText)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.primary)
                            .padding(16)
                            .frame(minHeight: 200)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            startAppleBreathing()
        }
    }
    
    private func startAppleBreathing() {
        withAnimation(
            Animation.easeInOut(duration: 4.0)
                .repeatForever(autoreverses: true)
        ) {
            breathingScale = 1.01
            breathingOpacity = 0.98
        }
    }
}

// MARK: - Apple风格呼吸编辑想法视图
struct AppleBreathingEditThoughtView: View {
    let thought: ThoughtItem
    let onDismiss: () -> Void
    let onSave: (String) -> Void
    @State private var thoughtText: String
    @Environment(\.presentationMode) var presentationMode
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingOpacity: Double = 1.0
    
    init(thought: ThoughtItem, onDismiss: @escaping () -> Void, onSave: @escaping (String) -> Void) {
        self.thought = thought
        self.onDismiss = onDismiss
        self.onSave = onSave
        self._thoughtText = State(initialValue: thought.content)
    }
    
    var body: some View {
        ZStack {
            AppleBreathingBackground()
            
            VStack(spacing: 0) {
                // 导航栏
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .medium))
                            Text("取消")
                                .font(.system(size: 17, weight: .regular))
                        }
                        .foregroundColor(.primary)
                    }
                    Spacer()
                    Text("编辑想法")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                    Spacer()
                    Button(action: {
                        if !thoughtText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            onSave(thoughtText)
                        }
                    }) {
                        Text("保存")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(thoughtText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .secondary : .orange)
                    }
                    .disabled(thoughtText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                )
                
                // 输入区域
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("编辑你的想法")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.primary)
                        Text("修改下此刻的感受和想法")
                            .font(.system(size: 15, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    AppleBreathingCard {
                        TextEditor(text: $thoughtText)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.primary)
                            .padding(16)
                            .frame(minHeight: 200)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            startAppleBreathing()
        }
    }
    
    private func startAppleBreathing() {
        withAnimation(
            Animation.easeInOut(duration: 4.0)
                .repeatForever(autoreverses: true)
        ) {
            breathingScale = 1.01
            breathingOpacity = 0.98
        }
    }
}

// MARK: - Apple风格呼吸详情页卡片
struct AppleBreathingDetailCardView: View {
    let item: AnniversaryItem
    
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingOpacity: Double = 1.0
    @State private var shadowRadius: CGFloat = 12
    
    // 计算进度条进度
    private func calculateProgress(for targetDate: Date) -> Double {
        let calendar = Calendar.current
        let now = Date()
        
        if targetDate <= now {
            return 1.0
        }
        
        let totalDays = calendar.dateComponents([.day], from: item.createdAt, to: targetDate).day ?? 1
        let elapsedDays = calendar.dateComponents([.day], from: item.createdAt, to: now).day ?? 0
        let progress = Double(elapsedDays) / Double(totalDays)
        
        return max(0.0, min(1.0, progress))
    }
    
    var body: some View {
        AppleBreathingCard {
            VStack(alignment: .leading, spacing: 16) {
                // 顶部信息
                HStack {
                    Text(item.icon)
                        .font(.system(size: 32))
                        .modifier(AppleBreathingIconModifier())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.event)
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                        Text(DateFormatter.localizedString(from: item.date, dateStyle: .medium, timeStyle: .none))
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    
                    if item.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.blue)
                    }
                }
                
                // 进度条
                VStack(alignment: .leading, spacing: 8) {
                    let progress = calculateProgress(for: item.date)
                    let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: item.date).day ?? 0
                    let isFuture = item.date > Date()
                    
                    ProgressView(value: progress)
                        .accentColor(isFuture ? Color.orange : Color.green)
                        .scaleEffect(x: 1, y: 1.5, anchor: .center)
                        .modifier(AppleBreathingProgressModifier(color: isFuture ? Color.orange : Color.green))
                    
                    HStack {
                        Text(isFuture ? "还有" : "已陪伴")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(abs(daysLeft))天")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(isFuture ? Color.orange : Color.green)
                    }
                }
            }
            .padding(20)
        }
        .scaleEffect(breathingScale)
        .opacity(breathingOpacity)
        .shadow(
            color: item.isPinned ? Color.blue.opacity(0.15) : item.color.opacity(0.1),
            radius: shadowRadius,
            x: 0,
            y: 6
        )
        .onAppear {
            startAppleBreathing()
        }
    }
    
    private func startAppleBreathing() {
        withAnimation(
            Animation.easeInOut(duration: 5.0)
                .repeatForever(autoreverses: true)
        ) {
            breathingScale = 1.02
            breathingOpacity = 0.98
            shadowRadius = 16
        }
    }
}

// MARK: - Apple风格呼吸操作按钮
struct AppleBreathingActionButton: View {
    let icon: String
    let title: String
    let color: Color
    let action: () -> Void
    
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingOpacity: Double = 1.0
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                ZStack {
                    Circle()
                        .fill(color)
                        .frame(width: 44, height: 44)
                        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
                    
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                }
                
                Text(title)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(breathingScale)
        .opacity(breathingOpacity)
        .onAppear {
            startAppleBreathing()
        }
    }
    
    private func startAppleBreathing() {
        withAnimation(
            Animation.easeInOut(duration: 3.0)
                .repeatForever(autoreverses: true)
        ) {
            breathingScale = 1.05
            breathingOpacity = 0.9
        }
    }
}

#Preview {
    ContentView()
}
// MARK: - Apple风格呼吸详情页面
struct AnniversaryDetailView: View {
    let item: AnniversaryItem
    let onDismiss: () -> Void
    @State private var thoughts: [ThoughtItem] = []
    @State private var showAddThought = false
    @State private var showEditThought = false
    @State private var editingThought: ThoughtItem?
    
    // 抽签相关状态
    @State private var showEncourageCard = false
    @State private var encourageText = ""
    @State private var isAnimatingButton = false
    
    // 呼吸动效状态
    @State private var headerBreathingScale: CGFloat = 1.0
    @State private var contentBreathingPhase: CGFloat = 0
    @State private var floatingLights: [FloatingLight] = []
    
    // 鼓励语
    let encourages = [
        "你很棒！",
        "再坚持一下，明天会更好！",
        "相信自己，你值得被爱。",
        "每一天都值得期待。",
        "你的努力终将被看到。",
        "温柔以待自己。",
        "别怕，阳光总在风雨后。"
    ]
    
    var body: some View {
        ZStack {
            // Apple风格呼吸背景
            AppleBreathingBackground()
            
            // 浮动光点
            ForEach(floatingLights) { light in
                AppleFloatingLight(index: light.index)
            }
            
            VStack(spacing: 0) {
                // 顶部导航栏 - Apple风格
                AppleBreathingDetailHeaderView(
                    onDismiss: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            onDismiss()
                        }
                    },
                    onAddThought: { showAddThought = true }
                )
                .scaleEffect(headerBreathingScale)
                
                // 纪念日卡片区域
                VStack(spacing: 20) {
                    AppleBreathingDetailCardView(item: item)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 16)
                .padding(.bottom, 24)
                
                // 时间线区域 - Apple风格
                AppleBreathingTimelineView(
                    thoughts: thoughts,
                    onEdit: { editingThought in
                        self.editingThought = editingThought
                        showEditThought = true
                    },
                    onDelete: { deletingThought in
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            thoughts.removeAll { $0.id == deletingThought.id }
                        }
                    }
                )
            }
            
            // 悬浮抽签按钮 - Apple风格
            AppleBreathingFloatingButton(
                isAnimatingButton: isAnimatingButton,
                onButtonTapped: {
                    if !isAnimatingButton && !showEncourageCard {
                        isAnimatingButton = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                            encourageText = encourages.randomElement() ?? "你很棒！"
                            showEncourageCard = true
                            isAnimatingButton = false
                        }
                    }
                }
            )
            
            // 鼓励语卡片弹窗 - Apple风格
            if showEncourageCard {
                AppleBreathingEncourageCard(
                    encourageText: encourageText,
                    onDismiss: {
                        showEncourageCard = false
                    },
                    onSave: {
                        let newThought = ThoughtItem(
                            id: UUID(),
                            content: "✨ 今日抽签：\(encourageText)",
                            createdAt: Date()
                        )
                        thoughts.insert(newThought, at: 0)
                        showEncourageCard = false
                    }
                )
            }
        }
        .onAppear {
            startBreathingAnimations()
            generateFloatingLights()
        }
        .sheet(isPresented: $showAddThought) {
            AppleBreathingAddThoughtView(
                onDismiss: { showAddThought = false },
                onSave: { thoughtText in
                    let newThought = ThoughtItem(
                        id: UUID(),
                        content: thoughtText,
                        createdAt: Date()
                    )
                    thoughts.insert(newThought, at: 0)
                    showAddThought = false
                }
            )
        }
        .sheet(isPresented: Binding(
            get: { showEditThought && editingThought != nil },
            set: { showEditThought = $0 }
        )) {
            if let editingThought = editingThought {
                AppleBreathingEditThoughtView(
                    thought: editingThought,
                    onDismiss: {
                        showEditThought = false
                        self.editingThought = nil
                    },
                    onSave: { updatedContent in
                        if let index = thoughts.firstIndex(where: { $0.id == editingThought.id }) {
                            let updatedThought = ThoughtItem(
                                id: editingThought.id,
                                content: updatedContent,
                                createdAt: editingThought.createdAt
                            )
                            thoughts[index] = updatedThought
                        }
                        showEditThought = false
                        self.editingThought = nil
                    }
                )
            }
        }
    }
    
    private func startBreathingAnimations() {
        withAnimation(
            Animation.easeInOut(duration: 4.0)
                .repeatForever(autoreverses: true)
        ) {
            headerBreathingScale = 1.01
        }
    }
    
    private func generateFloatingLights() {
        floatingLights = (0..<3).map { FloatingLight(index: $0) }
    }
}

// 想法数据模型
struct ThoughtItem: Identifiable {
    let id: UUID
    let content: String
    let createdAt: Date
}

