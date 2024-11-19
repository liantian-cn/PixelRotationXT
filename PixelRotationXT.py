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


spell_dict = {
    # 防骑&惩戒
    26573: {"title": "奉献", "key_bind": ["3", ]},
    204019: {"title": "祝福之锤", "key_bind": ["e", ]},
    275779: {"title": "审判", "key_bind": ["q", ]},
    31935: {"title": "复仇者之盾", "key_bind": ["2", ]},
    96231: {"title": "责难", "key_bind": ["`", ]},
    213644: {"title": "清毒术", "key_bind": ["r", ]},
    432459: {"title": "神圣军备", "key_bind": ["alt", "1"]},
    375576: {"title": "圣洁鸣钟", "key_bind": ["alt", "3"]},
    24275: {"title": "愤怒之锤", "key_bind": ["5", ]},
    85673: {"title": "荣耀圣令", "key_bind": ["alt", "e"]},
    853: {"title": "制裁之锤", "key_bind": ["4", ]},
    53600: {"title": "正义盾击", "key_bind": ["alt", "2"]},
    391054: {"title": "战复", "key_bind": ["z", ]},
    # 惩戒
    343527: {"title": "处决审判", "key_bind": ["3", ]},
    53385: {"title": "神圣风暴", "key_bind": ["e", ]},
    255937: {"title": "灰烬觉醒", "key_bind": ["2", ]},
    427453: {"title": "圣光之锤", "key_bind": ["2", ]},
    184575: {"title": "公正之剑", "key_bind": ["1", ]},
    383328: {"title": "最终审判", "key_bind": ["alt", "q"]},
    1022: {"title": "保护祝福", "key_bind": ["alt", "z"]},
    642: {"title": "圣盾术", "key_bind": ["alt", "x"]},
    135928: {"title": "圣疗", "key_bind": ["alt", "c"]},
    403876: {"title": "圣佑", "key_bind": ["alt", "1"]},
    184662: {"title": "复仇之盾", "key_bind": ["alt", "211"]},
    20271: {"title": "审判", "key_bind": ["q", ]},
    # 血迪凯
    195292: {"title": "死神的抚摩", "key_bind": ["3", ]},
    195182: {"title": "精髓分裂", "key_bind": ["alt", "q"]},
    439843: {"title": "死神印记", "key_bind": ["alt", "e"]},
    49998: {"title": "灵界打击", "key_bind": ["e", ]},
    47528: {"title": "心灵冰冻", "key_bind": ["`", ]},
    50842: {"title": "血液沸腾", "key_bind": ["alt", "`"]},
    43265: {"title": "枯萎凋零", "key_bind": ["5", ]},
    274156: {"title": "吞噬", "key_bind": ["alt", "1"]},
    136168: {"title": "吸血鬼之血", "key_bind": ["alt", "5"]},
    49028: {"title": "符文刃舞", "key_bind": ["alt", "z"]},
    219809: {"title": "墓石", "key_bind": ["alt", "2"]},
    206930: {"title": "心脏打击", "key_bind": ["q", ]},
    46585: {"title": "亡者复生", "key_bind": ["alt", "r"]},
    194844: {"title": "白骨风暴", "key_bind": ["alt", "3"]},
    # 通用
    431416: {"title": "护腕", "key_bind": ["alt", "x"]},

}
keyboard.add_hotkey('f1', star_loop)
keyboard.add_hotkey('f2', stop_loop)

while True:
    time.sleep(random.uniform(0.15, 0.25))
    if not continue_loop:
        continue
    frame = dx_camera.get_latest_frame()
    img = Image.fromarray(frame)
    pixels = list(img.getdata())
    unique_colors = set(pixels)
    if len(unique_colors) != 1:
        print("不在程序")
    else:
        pixel_color = pixels[0]
        if pixel_color == (255, 255, 255):
            print("闲置")
        else:
            r, g, b = pixel_color
            spell_id = (r * 65536) + (g * 256) + b
            # print(spell_id)
            spell = spell_dict.get(spell_id, None)
            if spell is None:
                print(f"未知{spell_id}")
                continue
            title = spell["title"]
            print(title)
            key_bind = spell["key_bind"]
            pyautogui.hotkey(key_bind)
