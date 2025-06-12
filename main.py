import sys
from PyQt5.QtWidgets import QApplication, QMainWindow, QPushButton, QVBoxLayout, QWidget, QLabel
from PyQt5.QtCore import Qt, pyqtSignal, QObject, QEvent

class ButtonSignals(QObject):
    button_up_pressed = pyqtSignal()
    button_down_pressed = pyqtSignal()
    button_press_pressed = pyqtSignal()

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()

        self.setWindowTitle("Menu Navigation")
        self.setGeometry(100, 100, 480, 320)

        self.central_widget = QWidget()
        self.setCentralWidget(self.central_widget)

        self.layout = QVBoxLayout(self.central_widget)

        self.menu_items = ["Option 1", "Option 2", "Option 3", "Option 4"]
        self.labels = []
        self.selected_index = 0

        for i, text in enumerate(self.menu_items):
            label = QLabel(text, alignment=Qt.AlignCenter)
            label.setStyleSheet("background-color: lightgray;")
            label.setFixedHeight(80)
            self.labels.append(label)
            self.layout.addWidget(label)

        self.update_selected_item()

        self.button_signals = ButtonSignals()
        self.button_signals.button_up_pressed.connect(self.move_up)
        self.button_signals.button_down_pressed.connect(self.move_down)
        self.button_signals.button_press_pressed.connect(self.select_item)

        # Simulate buttons with keyboard keys
        self.keyPressSignal = self.installEventFilter(self)

    def eventFilter(self, source, event):
        if event.type() == QEvent.KeyPress:
            if event.key() == Qt.Key_J:
                self.button_signals.button_up_pressed.emit()
            elif event.key() == Qt.Key_K:
                self.button_signals.button_down_pressed.emit()
            elif event.key() == Qt.Key_L:
                self.button_signals.button_press_pressed.emit()
        return super().eventFilter(source, event)

    def update_selected_item(self):
        for i, label in enumerate(self.labels):
            if i == self.selected_index:
                label.setStyleSheet("background-color: blue; color: white;")
            else:
                label.setStyleSheet("background-color: lightgray;")

    def move_up(self):
        self.selected_index = (self.selected_index - 1) % len(self.menu_items)
        self.update_selected_item()

    def move_down(self):
        self.selected_index = (self.selected_index + 1) % len(self.menu_items)
        self.update_selected_item()

    def select_item(self):
        print(f"Selected: {self.menu_items[self.selected_index]}")

if __name__ == "__main__":
    app = QApplication(sys.argv)
    main_window = QMainWindow()
    main_window.show()
    sys.exit(app.exec_())
