import 'package:flutter/material.dart';
import 'package:flutter_translate/global.dart';
import 'package:gzx_dropdown_menu/gzx_dropdown_menu.dart';
import '../localization/string.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> _headerItemStrings = [];
  List<SortCondition> _languageSortConditions = [];
  SortCondition _selectBrandSortCondition;
  GZXDropdownMenuController _dropdownMenuController =
      GZXDropdownMenuController();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  GlobalKey _stackKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _headerItemStrings.add('繁體中文');
    _headerItemStrings.add(getString(R.string.select_bar_nearby));
    _headerItemStrings.add(getString(R.string.select_bar_smart_sort));
    _languageSortConditions.add(SortCondition(name: '繁體中文', isSelected: true));
    _languageSortConditions.add(SortCondition(name: '簡體中文', isSelected: false));
    _languageSortConditions
        .add(SortCondition(name: 'English', isSelected: false));
    _languageSortConditions.add(SortCondition(name: '日本語', isSelected: false));
    _languageSortConditions.add(SortCondition(name: '한국어', isSelected: false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        child: Container(
          color: Color(0xFFFFFFFF),
        ),
        preferredSize: Size.fromHeight(0),
      ),
      backgroundColor: Color(0xFFF5F8F9),
      endDrawer: Container(
        margin: EdgeInsets.only(
          left: MediaQuery.of(context).size.width / 4,
          top: 0,
        ),
        color: Colors.white,
        child: ListView(
          children: <Widget>[TextField()],
        ),
      ),
      body: Stack(
        key: _stackKey,
        children: <Widget>[
          Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  InkWell(
                    child: Stack(
                      children: <Widget>[
                        Image.asset(
                          "assets/icons/icon_search_bar.png",
                          height: 49,
                          fit: BoxFit.fill,
                        ),
                        Center(
                          child: Container(
                            width: 150,
                            height: 49,
                            margin: EdgeInsets.only(
                                left: 50, right: 0, bottom: 0, top: 0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                getString(R.string.search_bar_text),
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Color(0xFF4E4D4D),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // 下拉菜單頭部
              GZXDropDownHeader(
                items: [
                  GZXDropDownHeaderItem(
                    _headerItemStrings[0],
                  ),
                  GZXDropDownHeaderItem(_headerItemStrings[1]),
                  GZXDropDownHeaderItem(_headerItemStrings[2]),
                ],
                // GZXDropDownHeader對應第一父級Stack的key
                stackKey: _stackKey,
                // controller用於控制menu的顯示或隱藏
                controller: _dropdownMenuController,
                // 文字样式
                style: TextStyle(color: Color(0xFF7D7D7D), fontSize: 13),
                // 下拉时文字样式
                dropDownStyle: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF08A898),
                ),
                // 图标大小
                iconSize: 20,
                // 图标颜色
                iconColor: Color(0xFF7D7D7D),
                // 下拉时图标颜色
                iconDropDownColor: Color(0xFF08A898),
              ),
            ],
          ),
          // 下拉菜单
          GZXDropDownMenu(
            // controller用于控制menu的显示或隐藏
            controller: _dropdownMenuController,
            // 下拉菜单显示或隐藏动画时长
            animationMilliseconds: 250,
            // 下拉菜单，高度自定义，你想显示什么就显示什么，完全由你决定，你只需要在选择后调用_dropdownMenuController.hide();即可
            menus: [
              GZXDropdownMenuBuilder(
                dropDownHeight:
                    40 * (_languageSortConditions.length.toDouble() + 0.13),
                dropDownWidget: _buildConditionListWidget(
                  _languageSortConditions,
                  (value) {
                    switch (value.name.toString()) {
                      case "繁體中文":
                        changeLocale(context, 'zh_TW');
                        break;
                      case "簡體中文":
                        changeLocale(context, 'zh_CN');
                        break;
                      case "English":
                        changeLocale(context, 'en_US');
                        break;
                      case "日本語":
                        changeLocale(context, 'ja_JP');
                        break;
                      case "한국어":
                        changeLocale(context, 'ko_KR');
                        break;
                    }
                    // 延遲0.02秒執行
                    Future.delayed(
                      Duration(milliseconds: 20),
                      () {
                        _selectBrandSortCondition = value;
                        _headerItemStrings[0] = _selectBrandSortCondition.name;
                        _headerItemStrings[1] =
                            getString(R.string.select_bar_nearby);
                        _headerItemStrings[2] =
                            getString(R.string.select_bar_smart_sort);
                        _dropdownMenuController.hide();
                        setState(() {});
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildConditionListWidget(
      items, void itemOnTap(SortCondition sortCondition)) {
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      // item 的个数
      separatorBuilder: (BuildContext context, int index) => Divider(
        height: 1.0,
        color: Color(0xFFC4C4C4),
      ),
      // 添加分割线
      itemBuilder: (BuildContext context, int index) {
        SortCondition goodsSortCondition = items[index];
        return GestureDetector(
          onTap: () {
            for (var value in items) {
              value.isSelected = false;
            }
            goodsSortCondition.isSelected = true;
            itemOnTap(goodsSortCondition);
          },
          child: Container(
            color: Color(0xFFFFFFFF),
            height: 40,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    goodsSortCondition.name,
                    style: TextStyle(
                      color: goodsSortCondition.isSelected
                          ? Color(0xFF08A898)
                          : Color(0xFF000000),
                    ),
                  ),
                ),
                goodsSortCondition.isSelected
                    ? Icon(
                        Icons.check,
                        color: Color(0xFF08A898),
                        size: 16,
                      )
                    : SizedBox(),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SortCondition {
  String name;
  bool isSelected;

  SortCondition({this.name, this.isSelected});
}

String getString(String key, {Map<String, dynamic> args}) {
  return translate(key);
}
