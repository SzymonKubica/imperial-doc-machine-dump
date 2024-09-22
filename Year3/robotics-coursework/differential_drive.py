from enum import Enum

class Direction(Enum):
    CLOCKWISE = 0
    ANTI_CLOCKWISE = 1

class DifferentialDrive:
    def init(self):
        self.v_l = 0.0
        self.v_r = 0.0

    def go_straight(self, v: float):
        self.v_l = v
        self.v_r = v

    def turn_in_place(self, v: float, direction: Direction):
        self.v_l = v
