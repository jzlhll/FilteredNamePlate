﻿-- Prevent tainting global _.

if GetLocale() == "zhTW" then
FNP_LOCALE_TEXT.FNP_ENABLE_TXT = "僅顯啟用";
FNP_LOCALE_TEXT.FNP_GS_ENABLE_TXT = "共生圖標啟用";
-- FNP_LOCALE_TEXT.FNP_ENABLE_TANK_TXT = "坦克專用";
-- FNP_LOCALE_TEXT.FNP_ENABLE_TANK_TXT_TOOLTIP = "自己是坦克：目標不是自己的怪物將被當做僅顯單位。";
FNP_LOCALE_TEXT.FNP_ENABLE_KILLINE_TXT = "斬殺啟用";
FNP_LOCALE_TEXT.FNP_STRING_WEBSITE = "http://bbs.nga.cn/read.php?tid=11817959";

FNP_LOCALE_TEXT.FNP_TOOLTIP_TIDY = "如果你使用了TidyPlate, 請勾選此項。";
FNP_LOCALE_TEXT.FNP_TOOLTIP_KUI = "如果你使用了Kui_NamePlate，請勾選此項。";
FNP_LOCALE_TEXT.FNP_ORIG_TITLE = "源生/有愛/大腳/maoR";
FNP_LOCALE_TEXT.FNP_ORIG_TITLE2 = "EK條形/老農/魔盒";
FNP_LOCALE_TEXT.FNP_EKNUM_TITLE = "EK數字/AltzUI";
FNP_LOCALE_TEXT.FNP_TOOLTIP_ORIG = "如果你使用原生, 如大腳,有愛等, 請勾選此項。";
FNP_LOCALE_TEXT.FNP_TOOLTIP_EUI_RAYUI = "如果你使用了EUI或RayUI,ElvUI, 請勾選此項。";
FNP_LOCALE_TEXT.FNP_TOOLTIP_NDUI = "如果你使用了NDUI, 請勾選此項。";
FNP_LOCALE_TEXT.FNP_TOOLTIP_EK = "如果你使用了EkPlates, 請勾選此項。";

FNP_LOCALE_TEXT.FNP_DEFAULT_SCALE_TXT = "默認縮放比例";
FNP_LOCALE_TEXT.FNP_DEFAULT_SCALE_TOOLTIP = "縮放當前UI類型的姓名板大小";
FNP_LOCALE_TEXT.FNP_ONLYSHOW_OTHER_SCALE_TXT = "非僅顯單位縮放比例";
FNP_LOCALE_TEXT.FNP_ONLYSHOW_OTHER_SCALE_TOOLTIP = "當出現了僅顯情況后，非僅顯單位的姓名板大小";
FNP_LOCALE_TEXT.FNP_ONLYSHOW_SCALE_TXT = "僅顯單位縮放比例";
FNP_LOCALE_TEXT.FNP_ONLYSHOW_SCALE_TOOLTIP = "當出現了僅顯情況后，僅顯單位的姓名板大小";

FNP_LOCALE_TEXT.FNP_TAKEEFFECT_BTN = "生效";
FNP_LOCALE_TEXT.FNP_RELOAD_BTN = "重載生效";

FNP_LOCALE_TEXT.FNP_TXT_BIG = "大";
FNP_LOCALE_TEXT.FNP_TXT_SMALL = "小";

FNP_LOCALE_TEXT.FNP_CONST_BUFF_TXT = "固定Buffs";
FNP_LOCALE_TEXT.FNP_DYNAMIC_BUFF_TXT = "動態Buffs";
FNP_LOCALE_TEXT.FNP_ONLYSHOW_LIST_TXT = "僅顯列表";
FNP_LOCALE_TEXT.FNP_FILTER_LIST_TXT = "過濾列表";
FNP_LOCALE_TEXT.FNP_STRING_UI_TYPE = "UI類型(改變需重載/rl /reload)";
FNP_LOCALE_TEXT.FNP_STRING_NOTE = "列表框用英文的';'追加名字";

FNP_LOCALE_TEXT.FNP_STRING_AUTHOR_VER = "作者:Allan 版本:8.0.0.20180923";

FNP_LOCALE_TEXT.FNP_PRINT_ERROR_UITYPE = "\124cFF00CD00[ /fnp ]錯誤！你設置的UI類型可能不匹配。請正確設置并重載界面！\124r";
FNP_LOCALE_TEXT.FNP_PRINT_UITYPE_CHANGED = "\124cFF00CD00你修改了UI類型，請重載/reload或/rl !\124r";
FNP_LOCALE_TEXT.FNP_PRINT_HELP0 = "\124cFF00CD00>>>FilteredNamePlates<<<\124r";
FNP_LOCALE_TEXT.FNP_PRINT_HELP1 = "\124cFF00CD00/fnp options 或 /fnp opt \124r打開菜單";
FNP_LOCALE_TEXT.FNP_PRINT_HELP2 = "\124cFF00CD00/fnp change 或 /fnp ch \124r快速切換開關";
FNP_LOCALE_TEXT.FNP_PRINT_HELP3 = "\124cFF00CD00/fnp refresh \124r快速隱藏當前施法的單位";

FNP_LOCALE_TEXT.FNP_TEXT_INFO0 = "\124cFF00CD00如果設置后沒有生效, 或者仍有一些不正常，嘗試重載界面. 自動開啟esc->界面->名字-顯示所有姓名板.如果你不喜歡,請手動關閉而插件功能將會異常.\124r";
FNP_LOCALE_TEXT.FNP_CHANGED_UITYPE = "修改了UI類型!请重載界面！";

FNP_LOCALE_TEXT.FNP_MENU_GENERAL = "一般";
FNP_LOCALE_TEXT.FNP_MENU_FILTER = "過濾";
FNP_LOCALE_TEXT.FNP_MENU_SIZE = "大小";
FNP_LOCALE_TEXT.FNP_MENU_ICON = "圖標";
FNP_LOCALE_TEXT.FNP_MENU_ABOUT = "關於";
FNP_LOCALE_TEXT.COPY_WEB = "拷貝網址";
end
