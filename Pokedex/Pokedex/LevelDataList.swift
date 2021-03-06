//
//  PowerUpCostList.swift
//  Pokedex
//
//  Created by Javan.Chen on 2016/8/19.
//  Copyright © 2016年 Javan. All rights reserved.
//

import Foundation

let stardustLevel: [Double:[Double]] = [
    200:    [1.0, 1.5, 2.0, 2.5],
    400:    [3.0, 3.5, 4.0, 4.5],
    600:    [5.0, 5.5, 6.0, 6.5],
    800:    [7.0, 7.5, 8.0, 8.5],
    1000:   [9.0, 9.5, 10.0, 10.5],
    1300:   [11.0, 11.5, 12.0, 12.5],
    1600:   [13.0, 13.5, 14.0, 14.5],
    1900:   [15.0, 15.5, 16.0, 16.5],
    2200:   [17.0, 17.5, 18.0, 18.5],
    2500:   [19.0, 19.5, 20.0, 20.5],
    3000:   [21.0, 21.5, 22.0, 22.5],
    3500:   [23.0, 23.5, 24.0, 24.5],
    4000:   [25.0, 25.5, 26.0, 26.5],
    4500:   [27.0, 27.5, 28.0, 28.5],
    5000:   [29.0, 29.5, 30.0, 30.5],
    6000:   [31.0, 31.5, 32.0, 32.5],
    7000:   [33.0, 33.5, 34.0, 34.5],
    8000:   [35.0, 35.5, 36.0, 36.5],
    9000:   [37.0, 37.5, 38.0, 38.5],
    10000:  [39.0, 39.5, 40.0],
]

let levelData: [Double:[String:Double]] = [
    1.0:    ["CPM": 0.094,          "stardust": 200,    "Candies": 1],
    1.5:    ["CPM": 0.135137432,    "stardust": 200,    "Candies": 1],
    2.0:    ["CPM": 0.16639787,     "stardust": 200,    "Candies": 1],
    2.5:    ["CPM": 0.192650919,    "stardust": 200,    "Candies": 1],
    3.0:    ["CPM": 0.21573247,     "stardust": 400,    "Candies": 1],
    3.5:    ["CPM": 0.236572661,    "stardust": 400,    "Candies": 1],
    4.0:    ["CPM": 0.25572005,     "stardust": 400,    "Candies": 1],
    4.5:    ["CPM": 0.273530381,    "stardust": 400,    "Candies": 1],
    5.0:    ["CPM": 0.29024988,     "stardust": 600,    "Candies": 1],
    5.5:    ["CPM": 0.306057377,    "stardust": 600,    "Candies": 1],
    6.0:    ["CPM": 0.3210876,      "stardust": 600,    "Candies": 1],
    6.5:    ["CPM": 0.335445036,    "stardust": 600,    "Candies": 1],
    7.0:    ["CPM": 0.34921268,     "stardust": 800,    "Candies": 1],
    7.5:    ["CPM": 0.362457751,    "stardust": 800,    "Candies": 1],
    8.0:    ["CPM": 0.37523559,     "stardust": 800,    "Candies": 1],
    8.5:    ["CPM": 0.387592406,    "stardust": 800,    "Candies": 1],
    9.0:    ["CPM": 0.39956728,     "stardust": 1000,   "Candies": 1],
    9.5:    ["CPM": 0.411193551,    "stardust": 1000,   "Candies": 1],
    10.0:   ["CPM": 0.42250001,     "stardust": 1000,   "Candies": 1],
    10.5:   ["CPM": 0.432926419,    "stardust": 1000,   "Candies": 1],
    11.0:   ["CPM": 0.44310755,     "stardust": 1300,   "Candies": 2],
    11.5:   ["CPM": 0.4530599578,   "stardust": 1300,   "Candies": 2],
    12.0:   ["CPM": 0.46279839,     "stardust": 1300,   "Candies": 2],
    12.5:   ["CPM": 0.472336083,    "stardust": 1300,   "Candies": 2],
    13.0:   ["CPM": 0.48168495,     "stardust": 1600,   "Candies": 2],
    13.5:   ["CPM": 0.4908558,      "stardust": 1600,   "Candies": 2],
    14.0:   ["CPM": 0.49985844,     "stardust": 1600,   "Candies": 2],
    14.5:   ["CPM": 0.508701765,    "stardust": 1600,   "Candies": 2],
    15.0:   ["CPM": 0.51739395,     "stardust": 1900,   "Candies": 2],
    15.5:   ["CPM": 0.525942511,    "stardust": 1900,   "Candies": 2],
    16.0:   ["CPM": 0.53435433,     "stardust": 1900,   "Candies": 2],
    16.5:   ["CPM": 0.542635767,    "stardust": 1900,   "Candies": 2],
    17.0:   ["CPM": 0.55079269,     "stardust": 2200,   "Candies": 2],
    17.5:   ["CPM": 0.558830576,    "stardust": 2200,   "Candies": 2],
    18.0:   ["CPM": 0.56675452,     "stardust": 2200,   "Candies": 2],
    18.5:   ["CPM": 0.574569153,    "stardust": 2200,   "Candies": 2],
    19.0:   ["CPM": 0.58227891,     "stardust": 2500,   "Candies": 2],
    19.5:   ["CPM": 0.589887917,    "stardust": 2500,   "Candies": 2],
    20.0:   ["CPM": 0.59740001,     "stardust": 2500,   "Candies": 2],
    20.5:   ["CPM": 0.604818814,    "stardust": 2500,   "Candies": 2],
    21.0:   ["CPM": 0.61215729,     "stardust": 3000,   "Candies": 3],
    21.5:   ["CPM": 0.619399365,    "stardust": 3000,   "Candies": 3],
    22.0:   ["CPM": 0.62656713,     "stardust": 3000,   "Candies": 3],
    22.5:   ["CPM": 0.633644533,    "stardust": 3000,   "Candies": 3],
    23.0:   ["CPM": 0.64065295,     "stardust": 3500,   "Candies": 3],
    23.5:   ["CPM": 0.647576426,    "stardust": 3500,   "Candies": 3],
    24.0:   ["CPM": 0.65443563,     "stardust": 3500,   "Candies": 3],
    24.5:   ["CPM": 0.661214806,    "stardust": 3500,   "Candies": 3],
    25.0:   ["CPM": 0.667934,       "stardust": 4000,   "Candies": 4],
    25.5:   ["CPM": 0.674577537,    "stardust": 4000,   "Candies": 4],
    26.0:   ["CPM": 0.68116492,     "stardust": 4000,   "Candies": 4],
    26.5:   ["CPM": 0.687680648,    "stardust": 4000,   "Candies": 4],
    27.0:   ["CPM": 0.69414365,     "stardust": 4500,   "Candies": 4],
    27.5:   ["CPM": 0.700538673,    "stardust": 4500,   "Candies": 4],
    28.0:   ["CPM": 0.70688421,     "stardust": 4500,   "Candies": 4],
    28.5:   ["CPM": 0.713164996,    "stardust": 4500,   "Candies": 4],
    29.0:   ["CPM": 0.71939909,     "stardust": 5000,   "Candies": 4],
    29.5:   ["CPM": 0.725571552,    "stardust": 5000,   "Candies": 4],
    30.0:   ["CPM": 0.7317,         "stardust": 5000,   "Candies": 4],
    30.5:   ["CPM": 0.734741009,    "stardust": 5000,   "Candies": 4],
    31.0:   ["CPM": 0.73776948,     "stardust": 6000,   "Candies": 6],
    31.5:   ["CPM": 0.740785574,    "stardust": 6000,   "Candies": 6],
    32.0:   ["CPM": 0.74378943,     "stardust": 6000,   "Candies": 6],
    32.5:   ["CPM": 0.746781211,    "stardust": 6000,   "Candies": 6],
    33.0:   ["CPM": 0.74976104,     "stardust": 7000,   "Candies": 8],
    33.5:   ["CPM": 0.752729087,    "stardust": 7000,   "Candies": 8],
    34.0:   ["CPM": 0.75568551,     "stardust": 7000,   "Candies": 8],
    34.5:   ["CPM": 0.758630378,    "stardust": 7000,   "Candies": 8],
    35.0:   ["CPM": 0.76156384,     "stardust": 8000,   "Candies": 10],
    35.5:   ["CPM": 0.764486065,    "stardust": 8000,   "Candies": 10],
    36.0:   ["CPM": 0.76739717,     "stardust": 8000,   "Candies": 10],
    36.5:   ["CPM": 0.770297266,    "stardust": 8000,   "Candies": 10],
    37.0:   ["CPM": 0.7731865,      "stardust": 9000,   "Candies": 12],
    37.5:   ["CPM": 0.776064962,    "stardust": 9000,   "Candies": 12],
    38.0:   ["CPM": 0.77893275,     "stardust": 9000,   "Candies": 12],
    38.5:   ["CPM": 0.781790055,    "stardust": 9000,   "Candies": 12],
    39.0:   ["CPM": 0.78463697,     "stardust": 10000,  "Candies": 15],
    39.5:   ["CPM": 0.787473578,    "stardust": 10000,  "Candies": 15],
    40.0:   ["CPM": 0.79030001,     "stardust": 10000,  "Candies": 15]
]