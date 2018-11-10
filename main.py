# coding: utf-8
from kivy.app import App
from kivy.uix.widget import Widget
from kivy.properties import NumericProperty, ListProperty, ObjectProperty
from kivy.vector import Vector
from kivy.clock import Clock
from kivy.factory import Factory
from kivy.logger import Logger

from road import Road
from car import Car
from tomato import Tomato

class Game(Widget):
    car = ObjectProperty(None)
    road = ObjectProperty(None)
    tomatoes = list()
    periode_tomates_initiale = 50
    periode_accel = 300
    speed_mult = 1.1
    current_tick = 0

    def reset(self):
        self.periode_tomates = self.periode_tomates_initiale
        self.road.speed = self.road_speed_initiale
        self.car.current_piste = 2
        for tom in self.tomatoes:
            self.remove_widget(tom)
        self.tomatoes = list()

    def ajoute_tomate(self):
        t = Tomato(self.road)
        self.tomatoes.append(t)
        self.add_widget(t)

    def tick(self, dt):
        if(self.current_tick == 0):
            self.road_speed_initiale = self.road.speed
            self.reset()

        self.current_tick = self.current_tick + 1
        
        # Ajoute une tomate à chaque "période tomate"
        if(self.current_tick % self.periode_tomates == 0):
            self.ajoute_tomate()
            self.ajoute_tomate()
            
        # Modifie la vitesse de la route à chaque "période accel"
        if(self.current_tick % self.periode_accel == 0):
            self.road.speed = self.road.speed * self.speed_mult
            self.periode_tomates = round(self.periode_tomates / self.speed_mult)

        # Pour chaque tomate...
        for t in self.tomatoes:
            t.tick()

            # Enlève la tomate si elle est tout à gauche
            if(t.x < -self.road.longueur):
                self.tomatoes.remove(t)
                self.remove_widget(t)                

            # Réinitialise en cas de collision
            if t.collide_widget(self.car):
                self.reset()
                break 

        self.car.tick()

    def on_touch_down(self, touch):
        if touch.y > self.height / 2:
            self.car.up()
        else:
            self.car.down()

class FuncrashApp(App):
    road = ObjectProperty(Road())

    def build(self):
        game = Game()
        Clock.schedule_interval(game.tick, 1.0 / 30.0)
        return game

if __name__ == '__main__':
    FuncrashApp().run()