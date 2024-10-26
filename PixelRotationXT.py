import time
import random
import dxcam
from PIL import Image
import pyautogui
import keyboard

dx_camera = dxcam.create(device_idx=0, output_idx=0, output_color="RGB")

region = (0, 0, 32, 32)

dx_camera.start(region=region, video_mode=True, target_fps=120)

# 标志变量
continue_loop = True


def star_loop():
    print("开始")
    global continue_loop
    continue_loop = True


def stop_loop():
    print("停止")
    global continue_loop
    continue_loop = False


keyboard.add_hotkey('alt+q', star_loop)
keyboard.add_hotkey('alt+e', stop_loop)

while True:
    time.sleep(random.uniform(0.25, 0.4))
    if not continue_loop:

        continue
    frame = dx_camera.get_latest_frame()
    img = Image.fromarray(frame)
    pixel_color = img.getpixel((8, 16))
    pixel_color2 = img.getpixel((24, 16))
    if pixel_color != pixel_color2:
        print("不在程序")
    elif pixel_color == (255, 255, 255):
        print("闲置")
    elif pixel_color == (0, 0, 0):
        print("闲置")
    elif pixel_color == (0, 0, 64):
        print("奉献")
        pyautogui.press("num1")
    elif pixel_color == (0,0, 128):
        print("祝福之锤")
        pyautogui.press("num2")
    elif pixel_color == (0, 0, 191):
        print("正义盾击")
        pyautogui.press("num3")
    elif pixel_color == (0, 0, 255):
        print("审判")
        pyautogui.press("num4")
    elif pixel_color == (0, 64, 0):
        print("复仇者之盾")
        pyautogui.press("num5")
    elif pixel_color == (0, 64, 64):
        print("责难")
        pyautogui.press("num6")
    elif pixel_color == (0, 64, 128):
        print("清毒术")
        pyautogui.press("num7")
    elif pixel_color == (0, 64, 191):
        print("神圣军备")
        pyautogui.press("num8")
    elif pixel_color == (0, 64, 255):
        print("圣洁鸣钟")
        pyautogui.press("num9")
    elif pixel_color == (0, 128, 0):
        print("愤怒之锤")
        pyautogui.press("add")
    elif pixel_color == (0, 128, 64):
        print("荣耀圣令")
        pyautogui.press("subtract")
    # elif pixel_color == (255, 128, 0):
    #     print("心灵冰冻")
    #     pyautogui.press("multiply")
    # print(pixel_color)

