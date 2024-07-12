import 'dart:developer';

import 'package:hele_app/model/calendar/calendar.dart';
import 'package:hele_app/model/character_list/character_list.dart';
import 'package:hele_app/model/derivation/related_works_query.dart';
import 'package:hele_app/model/pagination.dart';
import 'package:hele_app/model/person_career/person_career.dart';
import 'package:hele_app/model/subjects/subjects.dart';

import 'bangumi_api.dart';
import 'net/init.dart';

class BangumiNet {
  // 获取追番表
  static Future<List<Calendar>> bangumiCalendar() async {
    var res = await Request().get(BangumiApi.calendar);
    if (res.statusCode == 200) {
      List<dynamic> jsonData = res.data;
      List<Calendar> calendars = jsonData.map((item) => Calendar.fromJson(item)).toList();
      return calendars;
    } else {
      throw Exception('获取追番表数据失败');
    }
  }

  // 获取影视条目信息
  static Future<Subjects> bangumiSubject(int subjectId) async {
    var res = await Request().get(BangumiApi.subject + subjectId.toString());
    if (res.statusCode == 200) {
      Subjects subjects = Subjects.fromJson(res.data);
      return subjects;
    } else {
      log("报错：$res");
      throw Exception('获取条目信息数据失败');
    }
  }

  // 获取影视条目人物信息列表
  static Future<List<CharacterList>> bangumiSubjectCharacterList(int subjectId) async {
    var res = await Request().get("${BangumiApi.subject}$subjectId/characters");
    if (res.statusCode == 200) {
      List<dynamic> data = res.data;
      List<CharacterList> characters = data.map((item) => CharacterList.fromJson(item)).toList();
      return characters;
    } else {
      log("报错：$res");
      throw Exception('获取条目信息数据失败');
    }
  }

  // 获取影视条目演员信息列表
  static Future<List<PersonCareer>> bangumiSubjectPersons(int subjectId) async {
    var res = await Request().get("${BangumiApi.subject}$subjectId/persons");
    if (res.statusCode == 200) {
      List<dynamic> data = res.data;
      List<PersonCareer> persons = data.map((item) => PersonCareer.fromJson(item)).toList();
      return persons;
    } else {
      log("报错：$res");
      throw Exception('获取条目信息数据失败');
    }
  }

  // 获取影视条目衍生相关作品信息
  static Future<List<RelatedWorksQuery>> bangumiSubjectDerivation(int subjectId) async {
    var res = await Request().get("${BangumiApi.subject}$subjectId/subjects");
    if (res.statusCode == 200) {
      List<dynamic> data = res.data;
      List<RelatedWorksQuery> derivation = data.map((item) => RelatedWorksQuery.fromJson(item)).toList();
      return derivation;
    } else {
      log("报错：$res");
      throw Exception('获取条目信息数据失败');
    }
  }

  // 分类推荐
  // 根据当前时间所处季度，按收藏人数进行排序，取前5个为推荐
  // todo 计算当前时间 给出当前季度开始时间 1 4 7 10
  static Future<Pagination> bangumiRecommendation(int type) async {
    final requestBody = {
      "keyword": "",
      "sort": "heat",
      "filter": {
        "type": [type],
        "air_date": [">=2024-07-01"]
      }
    };

    final queryParameters = {
      'offset': '0',
      'limit': '5',
    };

    var res = await Request().post(BangumiApi.searchSubject, queryParameters: queryParameters, data: requestBody);

    if (res.statusCode == 200) {
      Pagination pagination = Pagination.fromJson(res.data);
      return pagination;
    } else {
      log("报错：$res");
      throw Exception('获取推荐信息数据失败');
    }
  }
}
