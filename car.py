from kivy.uix.widget import Widget
from kivy.animation import Animation
from kivy.properties import NumericProperty, ReferenceListProperty, ObjectProperty
from kivy.logger import Logger
from kivy.core.window import Window
from math import sqrt

class Car(Widget):
    road = ObjectProperty(rebind=True)
    y = NumericProperty(0)
    angle = NumericProperty(0)
    width = NumericProperty(0)
    current_piste = 2

    def bouge(self):
        new_y = self.road.hauteur_piste * self.current_piste
        angle = 0
        if new_y > self.y:
            angle = 15
        if new_y < self.y:
            angle = -15

        duration = 0.05
        inertie = 1.5*sqrt(self.width/self.road.hauteur_piste)
        Animation.cancel_all(self)
        anim = Animation(y=new_y, duration=duration)
        anim &= (Animation(angle=angle, duration=duration*1.1, t='in_out_cubic') +
                 Animation(angle=-inertie*angle/6, duration=1.5*duration*inertie, t='out_circ') +
                 Animation(angle=0, duration=2*duration*inertie, t='out_sine'))
        anim.start(self)

    def up(self):
        if(self.current_piste < 4):
            self.current_piste = self.current_piste + 1
        self.bouge()

    def down(self):
        if(self.current_piste > 0):
            self.current_piste = self.current_piste - 1
        self.bouge()

    def __init__(self, **kwargs):
        super(Car, self).__init__(**kwargs)
        Window.bind(on_key_down=self.key)

    def key(self, *args):
        if args[2] == 82:
            self.up()
        if args[2] == 81:
            self.down()
