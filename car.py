from kivy.uix.widget import Widget
from kivy.properties import NumericProperty, ReferenceListProperty, ObjectProperty
from kivy.logger import Logger
from kivy.core.window import Window

class Car(Widget):
    road = ObjectProperty(rebind=True)
    y = NumericProperty(0)
    current_piste = 2

    def calcule_position(self):
        self.y = self.road.hauteur_piste * self.current_piste

    def up(self, *args):
        if(self.current_piste < 4):
            self.current_piste = self.current_piste + 1

    def down(self, *args):
        if(self.current_piste > 0):
            self.current_piste = self.current_piste - 1

    def tick(self):
        self.calcule_position()
        
    def __init__(self, **kwargs):
        super(Car, self).__init__(**kwargs)
        Window.bind(on_key_down=self.key)

    def key(self, *args):
        if args[2] == 82:
            self.up()
        if args[2] == 81:
            self.down()