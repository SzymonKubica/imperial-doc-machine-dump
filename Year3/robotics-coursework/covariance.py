

from typing import List, Tuple
from statistics import mean


def covariance_matrix(final_locations: List[Tuple[float, float]]) -> List[List[float]]:
    x_readings = list(map((lambda reading: reading[0] ), final_locations))
    y_readings = list(map((lambda reading: reading[1] ), final_locations))

    x_mean = mean(x_readings)
    y_mean = mean(y_readings)


    covariance_xx = mean(list(map((lambda x : (x - x_mean)**2), x_readings)))
    covariance_yy = mean(list(map((lambda y : (y - y_mean)**2), y_readings)))

    covariance_xy = mean(list(map((lambda x_y: (x_y[0] - x_mean) * (x_y[1] - y_mean)), final_locations)))
    covariance_yx = mean(list(map((lambda x_y: (x_y[1] - y_mean) * (x_y[0] - x_mean)) , final_locations)))

    return [[covariance_xx, covariance_xy], [covariance_yx, covariance_yy]]








