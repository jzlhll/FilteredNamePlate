﻿-- Prevent tainting global _.
FNP_LOCALE_TEXT = {}
FNP_LOCALE_TEXT.FNP_STRING_WEBSITE = "http://bbs.nga.cn/read.php?tid=11817959";

if GetLocale() == "zhCN" then
FNP_LOCALE_TEXT.FNP_ENABLE_TXT = "启用";

FNP_LOCALE_TEXT.FNP_TOOLTIP_TIDY = "如果你使用了TidyPlate，请勾选该项。";
FNP_LOCALE_TEXT.FNP_TOOLTIP_KUI = "如果你使用了Kui_NamePlate，请勾选该项。";
FNP_LOCALE_TEXT.FNP_ORIG_TITLE = "原生";
FNP_LOCALE_TEXT.FNP_TOOLTIP_ORIG = "如果你使用原生, 如大脚,有爱等, 勾选此项。";
FNP_LOCALE_TEXT.FNP_TOOLTIP_EUI_RAYUI = "如果你使用了EUI或者RayUI, 请勾选此项。";
FNP_LOCALE_TEXT.FNP_TOOLTIP_NDUI = "如果你使用了NDUI, 请勾选此项。";

FNP_LOCALE_TEXT.FNP_DEFAULT_SCALE_TXT = "默认缩放比例";
FNP_LOCALE_TEXT.FNP_DEFAULT_SCALE_TOOLTIP = "缩放当前UI类型的姓名板(血条)大小";
FNP_LOCALE_TEXT.FNP_ONLYSHOW_OTHER_SCALE_TXT = "非仅显单位缩放比例";
FNP_LOCALE_TEXT.FNP_ONLYSHOW_OTHER_SCALE_TOOLTIP = "当出现了仅显情况后, 非仅显单位的姓名板(血条)大小";
FNP_LOCALE_TEXT.FNP_ONLYSHOW_SCALE_TXT = "仅显单位缩放比例";
FNP_LOCALE_TEXT.FNP_ONLYSHOW_SCALE_TOOLTIP = "当出现了仅显情况后, 仅显单位的姓名板(血条)大小";

FNP_LOCALE_TEXT.FNP_TAKEEFFECT_BTN = "生效";
FNP_LOCALE_TEXT.FNP_RELOAD_BTN = "重载生效";

FNP_LOCALE_TEXT.FNP_TXT_BIG = "大";
FNP_LOCALE_TEXT.FNP_TXT_SMALL = "小";

FNP_LOCALE_TEXT.FNP_ONLYSHOW_LIST_TXT = "仅显列表";
FNP_LOCALE_TEXT.FNP_FILTER_LIST_TXT = "过滤列表";
FNP_LOCALE_TEXT.FNP_STRING_UI_TYPE = "UI类型(改变需重载/rl /reload)";
FNP_LOCALE_TEXT.FNP_STRING_NOTE = "列表框用英文的分号';'追加名字";

FNP_LOCALE_TEXT.FNP_STRING_TEXTONLYOTHER = "点击生效按钮以后,如果未生效,";
FNP_LOCALE_TEXT.FNP_STRING_TEXTONLY = "来回切换隐藏和显示血条,即可";
FNP_LOCALE_TEXT.FNP_STRING_AUTHOR_VER = "作者:Allan 版本:7.2.5.20170630 V5";

FNP_LOCALE_TEXT.FNP_PRINT_ERROR_UITYPE = "\124cFFF58CBA[ /fnp ]错误！您设置的UI类型可能不匹配。请正确设置并重载界面！\124r";
FNP_LOCALE_TEXT.FNP_PRINT_UITYPE_CHANGED = "\124cFFF58CBA你修改了插件类型，请重载/reload或者/rl !\124r";
FNP_LOCALE_TEXT.FNP_PRINT_HELP0 = "\124cFFF58CBA[过滤姓名板]\124r";
FNP_LOCALE_TEXT.FNP_PRINT_HELP1 = "\124cFFF58CBA/fnp options 或 /fnp opt \124r打开菜单";
FNP_LOCALE_TEXT.FNP_PRINT_HELP2 = "\124cFFF58CBA/fnp change 或 /fnp ch \124r快速切换开关";
FNP_LOCALE_TEXT.FNP_PRINT_HELP3 = "\124cFFF58CBA/fnp refresh \124r快速隐藏正在施法的怪";
end
