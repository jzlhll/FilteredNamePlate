﻿-- Prevent tainting global _.
FNP_LOCALE_TEXT = {}
if GetLocale() == "zhCN" then
FNP_LOCALE_TEXT.FNP_ENABLE_TXT = "启用";
FNP_LOCALE_TEXT.FNP_ENABLE_TANK_TXT = "MT启用";
FNP_LOCALE_TEXT.FNP_ENABLE_TANK_TXT_TOOLTIP = "自己是MT：目标不是自己的怪物将会被当做仅显目标。";
FNP_LOCALE_TEXT.FNP_ENABLE_KILLINE_TXT = "斩杀启用";
FNP_LOCALE_TEXT.FNP_STRING_WEBSITE = "http://bbs.nga.cn/read.php?tid=11817959";

FNP_LOCALE_TEXT.FNP_TOOLTIP_TIDY = "如果你使用了TidyPlate，请勾选该项。";
FNP_LOCALE_TEXT.FNP_TOOLTIP_KUI = "如果你使用了Kui_NamePlate，请勾选该项。";
FNP_LOCALE_TEXT.FNP_ORIG_TITLE = "原生/有爱/大脚/魔盒";
FNP_LOCALE_TEXT.FNP_ORIG_TITLE2 = "EK条形/老农/MaoR";
FNP_LOCALE_TEXT.FNP_EKNUM_TITLE = "EK数字/AltzUI";
FNP_LOCALE_TEXT.FNP_TOOLTIP_ORIG = "如果你使用原生, 如大脚,有爱等, 勾选此项。";
FNP_LOCALE_TEXT.FNP_TOOLTIP_EUI_RAYUI = "如果你使用了EUI或者RayUI, 请勾选此项。";
FNP_LOCALE_TEXT.FNP_TOOLTIP_NDUI = "如果你使用了NDUI, 请勾选此项。";
FNP_LOCALE_TEXT.FNP_TOOLTIP_EK = "如果你使用了EkPlates, 请勾选此项。";

FNP_LOCALE_TEXT.FNP_DEFAULT_SCALE_TXT = "默认缩放比例";
FNP_LOCALE_TEXT.FNP_DEFAULT_SCALE_TOOLTIP = "缩放当前UI类型的姓名板(血条)大小";
FNP_LOCALE_TEXT.FNP_ONLYSHOW_OTHER_SCALE_TXT = "非仅显单位缩放比例";
FNP_LOCALE_TEXT.FNP_ONLYSHOW_OTHER_SCALE_TOOLTIP = "当出现了仅显情况后, 非仅显单位的姓名板(血条)大小";
FNP_LOCALE_TEXT.FNP_ONLYSHOW_SCALE_TXT = "仅显单位缩放比例";
FNP_LOCALE_TEXT.FNP_ONLYSHOW_SCALE_TOOLTIP = "当出现了仅显情况后, 仅显单位的姓名板(血条)大小";

FNP_LOCALE_TEXT.FNP_KILLLINE = "斩杀线100% 到 ";
FNP_LOCALE_TEXT.FNP_KILLLINE_TOOLTIP = "怪物斩杀线血量从100%到你的期望值";
FNP_LOCALE_TEXT.FNP_KILLLINE2 = "反斩杀线0% 到 ";
FNP_LOCALE_TEXT.FNP_KILLLINE_TOOLTIP2 = "怪物反斩杀线血量从你的期望值到0%";

FNP_LOCALE_TEXT.FNP_TAKEEFFECT_BTN = "生效";
FNP_LOCALE_TEXT.FNP_RELOAD_BTN = "重载生效";

FNP_LOCALE_TEXT.FNP_TXT_BIG = "大";
FNP_LOCALE_TEXT.FNP_TXT_SMALL = "小";

FNP_LOCALE_TEXT.FNP_ONLYSHOW_LIST_TXT = "仅显列表";
FNP_LOCALE_TEXT.FNP_FILTER_LIST_TXT = "过滤列表";
FNP_LOCALE_TEXT.FNP_STRING_UI_TYPE = "UI类型(改变需重载/rl /reload)";
FNP_LOCALE_TEXT.FNP_STRING_NOTE = "列表框用英文的分号';'追加名字";

FNP_LOCALE_TEXT.FNP_STRING_AUTHOR_VER = "作者:Allan 版本:7.2.5.20170725 V6.1";

FNP_LOCALE_TEXT.FNP_PRINT_ERROR_UITYPE = "\124cFF00CD00[ /fnp ]错误！您设置的UI类型可能不匹配。请正确设置并重载界面！\124r";
FNP_LOCALE_TEXT.FNP_PRINT_UITYPE_CHANGED = "\124cFF00CD00你修改了插件类型，请确保你勾选的是正确的，否则血条异常！";
FNP_LOCALE_TEXT.FNP_PRINT_HELP0 = "\124cFF00CD00>>>FilteredNamePlates<<<\124r";
FNP_LOCALE_TEXT.FNP_PRINT_HELP1 = "\124cFF00CD00/fnp options 或 /fnp opt \124r打开菜单";
FNP_LOCALE_TEXT.FNP_PRINT_HELP2 = "\124cFF00CD00/fnp change 或 /fnp ch \124r快速切换开关";
FNP_LOCALE_TEXT.FNP_PRINT_HELP3 = "\124cFF00CD00/fnp refresh \124r快速隐藏正在施法的怪";

FNP_LOCALE_TEXT.FNP_TEXT_HELP = "帮助";
FNP_LOCALE_TEXT.FNP_TEXT_SHARE = "队伍分享";
--FNP_LOCALE_TEXT.FNP_TEXT_SHARE2 = "公会分享";
FNP_LOCALE_TEXT.FNP_TEXT_INFO0 = "\124cFF00CD00如果设置没有生效, 或者改动过多, 仍有一些不正常, 尝试重载界面。V6: 自动开启 esc->界面->名字->显示所有姓名板.如果你不喜欢,请手动关闭而插件功能将会异常.\124r";
FNP_LOCALE_TEXT.FNP_CHANGED_UITYPE = "修改了UI类型!下次有新怪进入视野,将会刷新效果! 如果效果不佳, 则重载界面";

FNP_LOCALE_TEXT.FNP_MENU_GENERAL = "一般";
FNP_LOCALE_TEXT.FNP_MENU_FILTER = "过滤";
FNP_LOCALE_TEXT.FNP_MENU_SIZE = "大小";
FNP_LOCALE_TEXT.FNP_MENU_KILLLINE = "斩杀";
FNP_LOCALE_TEXT.FNP_MENU_ABOUT = "关于";
end
