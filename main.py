import asyncio
import os
import sys

from PyQt5.QtGui import QGuiApplication
from PyQt5.QtQml import QQmlApplicationEngine
from PyQt5.QtCore import QUrl, QThread, pyqtSignal

import beatmachine as bm

if not os.getenv("QML_DISABLE_DISTANCEFIELD", None):
    os.environ["QML_DISABLE_DISTANCEFIELD"] = "1"

os.environ["QT_QUICK_CONTROLS_STYLE"] = "universal"

app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine()
engine.load(QUrl("qml/MainWindow.qml"))

window = engine.rootObjects()[0]


class RenderThread(QThread):
    render_finished = pyqtSignal()
    
    def __init__(self, input_path: str = None, output_path: str = None):
        super(QThread, self).__init__()
        self.input_path = input_path
        self.output_path = output_path

    def run(self):
        beats = bm.Beats.from_song(self.input_path.toLocalFile())
        beats.apply(bm.effects.periodic.CutEveryNth()).save(self.output_path)
        self.render_finished.emit()


render_thread = RenderThread()


def start_render(song):
    render_thread.input_path = song
    render_thread.render_finished.connect(finish_render)
    render_thread.start()

def finish_render():
    window.setProperty("rendering", False)

window.startRender.connect(start_render)

if __name__ == "__main__":
    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec_())
