import SwiftUI

struct AddAnniversaryView: View {
    var onDismiss: (() -> Void)? = nil
    var onSave: ((_ event: String, _ date: Date, _ color: Color, _ icon: String) -> Void)? = nil
    var editingItem: AnniversaryItem? = nil // 添加编辑项参数
    @Environment(\.presentationMode) var presentationMode
    @State private var event: String
    @State private var date: Date
    @State private var selectedColor: Color
    @State private var selectedIcon: String
    
    // 呼吸动效状态
    @State private var backgroundBreathingPhase: CGFloat = 0
    @State private var cardBreathingScale: CGFloat = 1.0
    @State private var buttonBreathingScale: CGFloat = 1.0
    @State private var floatingLights: [FloatingLight] = []
    
    // 初始化状态变量
    init(editingItem: AnniversaryItem? = nil, onDismiss: (() -> Void)? = nil, onSave: ((_ event: String, _ date: Date, _ color: Color, _ icon: String) -> Void)? = nil) {
        self.editingItem = editingItem
        self.onDismiss = onDismiss
        self.onSave = onSave
        
        // 根据编辑模式初始化状态
        if let editingItem = editingItem {
            _event = State(initialValue: editingItem.event)
            _date = State(initialValue: editingItem.date)
            _selectedColor = State(initialValue: editingItem.color)
            _selectedIcon = State(initialValue: editingItem.icon)
        } else {
            _event = State(initialValue: "")
            _date = State(initialValue: Date())
            _selectedColor = State(initialValue: .orange)
            _selectedIcon = State(initialValue: "🎂")
        }
    }
    
    // 10个主题色
    let colors: [Color] = [
        .orange, .yellow, .pink, .blue, .green, .purple, .red, .teal, .mint, .indigo
    ]
    // 15个图标
    let icons: [String] = ["🎂", "🎉", "🌸", "🎁", "🐱", "🍰", "🎈", "🌞", "🌟", "🍀", "🦄", "🍎", "🍩", "🍔", "🍕"]
    
    var body: some View {
        ZStack {
            // Apple风格的呼吸背景
            AppleBreathingBackground()
            
            // 浮动光点
            ForEach(floatingLights) { light in
                AppleFloatingLight(index: light.index)
            }
            
            VStack(spacing: 0) {
                // 标题栏 - Apple风格
                HStack {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        HStack(spacing: 8) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .medium))
                            Text("返回".localized)
                                .font(.system(size: 17, weight: .regular))
                        }
                        .foregroundColor(.primary)
                    }
                    Spacer()
                    Text(editingItem != nil ? "编辑纪念日".localized : "添加纪念日".localized)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                    Spacer()
                    Button(action: {
                        if !event.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            if let onSave = onSave {
                                onSave(event, date, selectedColor, selectedIcon)
                            }
                            if let onDismiss = onDismiss {
                                onDismiss()
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }) {
                        Text("保存".localized)
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(event.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .secondary : .orange)
                    }
                    .disabled(event.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                )
                
                // 表单区域
                ScrollView {
                    VStack(spacing: 20) {
                        // 事件输入卡片
                        AppleBreathingCard {
                            VStack(spacing: 0) {
                                HStack(spacing: 12) {
                                    Image(systemName: "textformat")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(selectedColor)
                                        .frame(width: 20, height: 20)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("事件名称".localized)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(.secondary)
                                            .textCase(.uppercase)
                                        TextField("请输入事件名称".localized, text: $event)
                                            .font(.system(size: 16, weight: .regular))
                                            .foregroundColor(.primary)
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 16)
                                .padding(.bottom, 12)
                            }
                        }
                        
                        // 日期选择卡片
                        AppleBreathingCard {
                            VStack(spacing: 0) {
                                HStack(spacing: 12) {
                                    Image(systemName: "calendar")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(selectedColor)
                                        .frame(width: 20, height: 20)
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("纪念日期".localized)
                                            .font(.system(size: 13, weight: .medium))
                                            .foregroundColor(.secondary)
                                            .textCase(.uppercase)
                                        DatePicker("", selection: $date, displayedComponents: .date)
                                            .labelsHidden()
                                            .font(.system(size: 16, weight: .regular))
                                    }
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 16)
                                .padding(.bottom, 12)
                            }
                        }
                        
                        // 主题色选择卡片
                        AppleBreathingCard {
                            VStack(spacing: 0) {
                                HStack(spacing: 12) {
                                    Image(systemName: "paintpalette")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(selectedColor)
                                        .frame(width: 20, height: 20)
                                    
                                    Text("主题色彩".localized)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.secondary)
                                        .textCase(.uppercase)
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 16)
                                .padding(.bottom, 12)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
                                    ForEach(colors, id: \.self) { color in
                                        Circle()
                                            .fill(color)
                                            .frame(width: 36, height: 36)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.white, lineWidth: selectedColor == color ? 3 : 0)
                                            )
                                            .overlay(
                                                Circle()
                                                    .stroke(selectedColor == color ? Color.primary.opacity(0.2) : Color.clear, lineWidth: 2)
                                            )
                                            .scaleEffect(selectedColor == color ? 1.05 : 1.0)
                                            .shadow(color: selectedColor == color ? color.opacity(0.25) : Color.clear, radius: 4, x: 0, y: 2)
                                            .onTapGesture {
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                                    selectedColor = color
                                                }
                                            }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 16)
                            }
                        }
                        
                        // 图标选择卡片
                        AppleBreathingCard {
                            VStack(spacing: 0) {
                                HStack(spacing: 12) {
                                    Image(systemName: "face.smiling")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundColor(selectedColor)
                                        .frame(width: 20, height: 20)
                                    
                                    Text("选择图标".localized)
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.secondary)
                                        .textCase(.uppercase)
                                    Spacer()
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 16)
                                .padding(.bottom, 12)
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
                                    ForEach(icons, id: \.self) { icon in
                                        Text(icon)
                                            .font(.system(size: 20))
                                            .frame(width: 36, height: 36)
                                            .background(
                                                Circle()
                                                    .fill(selectedIcon == icon ? selectedColor.opacity(0.12) : Color.clear)
                                            )
                                            .overlay(
                                                Circle()
                                                    .stroke(selectedIcon == icon ? selectedColor.opacity(0.3) : Color.clear, lineWidth: 1.5)
                                            )
                                            .scaleEffect(selectedIcon == icon ? 1.05 : 1.0)
                                            .shadow(color: selectedIcon == icon ? selectedColor.opacity(0.15) : Color.clear, radius: 3, x: 0, y: 1)
                                            .onTapGesture {
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                                    selectedIcon = icon
                                                }
                                            }
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.bottom, 16)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 120)
                }
                
                // 保存按钮 - 悬浮在底部
                VStack(spacing: 12) {
                    Button(action: {
                        if !event.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            if let onSave = onSave {
                                onSave(event, date, selectedColor, selectedIcon)
                            }
                            if let onDismiss = onDismiss {
                                onDismiss()
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 16, weight: .semibold))
                            Text("保存纪念日".localized)
                                .font(.system(size: 16, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(
                                    event.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 
                                    Color.gray : 
                                    selectedColor
                                )
                        )
                        .shadow(
                            color: event.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 
                            Color.clear : 
                            selectedColor.opacity(0.25), 
                            radius: 6, x: 0, y: 3
                        )
                    }
                    .disabled(event.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .scaleEffect(buttonBreathingScale)
                    
                    Text("每一天都值得被记录 ✨".localized)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                        .opacity(0.8)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 34)
                .background(
                    Rectangle()
                        .fill(.ultraThinMaterial)
                        .ignoresSafeArea()
                )
            }
        }
        .onAppear {
            startBreathingAnimations()
            generateFloatingLights()
        }
    }
    
    private func startBreathingAnimations() {
        // 卡片呼吸动效
        withAnimation(
            Animation.easeInOut(duration: 4.0)
                .repeatForever(autoreverses: true)
        ) {
            cardBreathingScale = 1.02
        }
        
        // 按钮呼吸动效
        withAnimation(
            Animation.easeInOut(duration: 3.0)
                .repeatForever(autoreverses: true)
        ) {
            buttonBreathingScale = 1.03
        }
    }
    
    private func generateFloatingLights() {
        floatingLights = (0..<3).map { FloatingLight(index: $0) }
    }
}

// 浮动光点数据模型
struct FloatingLight: Identifiable {
    let id = UUID()
    let index: Int
}

// Apple风格呼吸卡片
struct AppleBreathingCard<Content: View>: View {
    let content: () -> Content
    @State private var breathingScale: CGFloat = 1.0
    @State private var breathingOpacity: Double = 1.0
    @State private var shadowRadius: CGFloat = 6
    
    var body: some View {
        content()
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.regularMaterial)
                    .shadow(
                        color: Color.black.opacity(0.06),
                        radius: shadowRadius,
                        x: 0,
                        y: 2
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(Color.primary.opacity(0.04), lineWidth: 0.5)
                    )
            )
            .scaleEffect(breathingScale)
            .opacity(breathingOpacity)
            .onAppear {
                startAppleBreathing()
            }
    }
    
    private func startAppleBreathing() {
        withAnimation(
            Animation.easeInOut(duration: 4.0)
                .repeatForever(autoreverses: true)
        ) {
            breathingScale = 1.005
            breathingOpacity = 0.99
            shadowRadius = 8
        }
    }
}

