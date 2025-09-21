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
                            Text("取消".localized)
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
                    VStack(spacing: 24) {
                        // 事件输入卡片
                        AppleBreathingCard {
                            HStack(spacing: 16) {
                                Image(systemName: "textformat")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.orange)
                                    .frame(width: 24)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("事件名称".localized)
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.secondary)
                                    TextField("请输入事件名称".localized, text: $event)
                                        .font(.system(size: 17, weight: .regular))
                                        .foregroundColor(.primary)
                                }
                                Spacer()
                            }
                            .padding(20)
                        }
                        
                        // 日期选择卡片
                        AppleBreathingCard {
                            HStack(spacing: 16) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 20, weight: .medium))
                                    .foregroundColor(.orange)
                                    .frame(width: 24)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("纪念日期".localized)
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.secondary)
                                    DatePicker("", selection: $date, displayedComponents: .date)
                                        .labelsHidden()
                                        .font(.system(size: 17, weight: .regular))
                                }
                                Spacer()
                            }
                            .padding(20)
                        }
                        
                        // 主题色选择卡片
                        AppleBreathingCard {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 16) {
                                    Image(systemName: "paintpalette")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.orange)
                                        .frame(width: 24)
                                    
                                    Text("主题色彩".localized)
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5), spacing: 12) {
                                    ForEach(colors, id: \.self) { color in
                                        Circle()
                                            .fill(color)
                                            .frame(width: 44, height: 44)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.white, lineWidth: 3)
                                                    .opacity(selectedColor == color ? 1 : 0)
                                            )
                                            .scaleEffect(selectedColor == color ? 1.1 : 1.0)
                                            .shadow(color: selectedColor == color ? color.opacity(0.3) : Color.clear, radius: 6, x: 0, y: 3)
                                            .onTapGesture {
                                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                                    selectedColor = color
                                                }
                                            }
                                    }
                                }
                            }
                            .padding(20)
                        }
                        
                        // 图标选择卡片
                        AppleBreathingCard {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 16) {
                                    Image(systemName: "face.smiling")
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.orange)
                                        .frame(width: 24)
                                    
                                    Text("选择图标".localized)
                                        .font(.system(size: 15, weight: .medium))
                                        .foregroundColor(.secondary)
                                    Spacer()
                                }
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5), spacing: 12) {
                                    ForEach(icons, id: \.self) { icon in
                                        Text(icon)
                                            .font(.system(size: 24))
                                            .frame(width: 44, height: 44)
                                            .background(
                                                Circle()
                                                    .fill(selectedIcon == icon ? Color.orange.opacity(0.15) : Color.clear)
                                            )
                                            .scaleEffect(selectedIcon == icon ? 1.1 : 1.0)
                                            .shadow(color: selectedIcon == icon ? Color.orange.opacity(0.2) : Color.clear, radius: 4, x: 0, y: 2)
                                            .onTapGesture {
                                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                                    selectedIcon = icon
                                                }
                                            }
                                    }
                                }
                            }
                            .padding(20)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)
                    .padding(.bottom, 120)
                }
                
                // 保存按钮 - 悬浮在底部
                VStack(spacing: 8) {
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
                            Image(systemName: "checkmark")
                                .font(.system(size: 18, weight: .semibold))
                            Text("保存纪念日".localized)
                                .font(.system(size: 17, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    event.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray : Color.orange,
                                    event.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.gray.opacity(0.8) : Color.orange.opacity(0.8)
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: event.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color.clear : Color.orange.opacity(0.3), radius: 8, x: 0, y: 4)
                    }
                    .disabled(event.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .scaleEffect(buttonBreathingScale)
                    
                    Text("每一天都值得被记录 ✨".localized)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 20)
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
    @State private var shadowRadius: CGFloat = 8
    
    var body: some View {
        content()
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(.regularMaterial)
                    .shadow(
                        color: Color.black.opacity(0.08),
                        radius: shadowRadius,
                        x: 0,
                        y: 4
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
            Animation.easeInOut(duration: 5.0)
                .repeatForever(autoreverses: true)
        ) {
            breathingScale = 1.01
            breathingOpacity = 0.98
            shadowRadius = 10
        }
    }
}

