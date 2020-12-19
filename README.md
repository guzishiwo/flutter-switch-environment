- [引言](#orgd526720)
- [实现方案](#orgf2e60e0)
  - [基本思路](#org9726579)
  - [目录结构](#orgdd86840)
  - [定义配置类](#orgc9d054b)
  - [初始化](#orgea06b2f)
  - [运行](#orgaf5f802)
  - [打包](#org86b69bb)
  - [点赞、收藏、Star](#org9dc697f)
- [附录](#org8e5d9f3)
  - [代码仓库](#org644e00c)
  - [参考引用](#org56190e1)



<a id="orgd526720"></a>

# 引言

APP开发中经常会碰到至少两个不同的环境: 一个测试环境，一个生产环境。 那如何在我们就测试开发后，不破坏现有的代码，切换到不同的环境呢？ fluter官方并没有给出推荐的方案, 在寻找使用不同的方式，认为多个main\_ *enviroment*.dart 是最优雅的办法。


<a id="orgf2e60e0"></a>

# 实现方案


<a id="org9726579"></a>

## 基本思路

在项目lib目录下创建不同的 `main_enviroment.dart` 文件, 来区分不同的环境, 而每个main\_<enviroment>.dart 包含不同的初始化配置, 开始全局注册


<a id="orgdd86840"></a>

## 目录结构

```shell
lib/main_com.dart  # 共有main_com文件
lib/main_dev.dart  # 测试环境
lib/main_release.dart  # 生产环境
```


<a id="orgc9d054b"></a>

## 定义配置类

定义好配置类, 一般可能是key，api\_url这里我仅仅用最常用的base\_url

```dart
enum BuildFlavor { dev, release }

class BuildEnvironment {
  final BuildFlavor flavor;
  final String apiBaseUrl;

  BuildEnvironment.dev({
    this.apiBaseUrl,
  }) : this.flavor = BuildFlavor.dev;

  BuildEnvironment.release({
    this.apiBaseUrl,
  }) : this.flavor = BuildFlavor.release;
}
```


<a id="orgea06b2f"></a>

## 初始化

初始化不同的环境配置, 把配置作为全局变量, 或依赖注入用[getIt](https://pub.dev/packages/get_it)、[getx](https://pub.dev/packages/get)都行, 我比较喜欢用依赖注入，这样代码可测试，清晰。 demo里用了getx

1.  测试环境 `main_dev.dart`

    ```dart
    // lib/main_dev.dart
    void main() async {
      final buildEnv = BuildEnvironment.dev(
        apiBaseUrl: 'https://domain.dev/api',
      );
      // 放到一个可以全局访问的地方
      Get.put(buildEnv);
      mainCom();
    }
    ```
2.  生产环境 `main_release.dart`

    ```dart
    // lib/main_release.dart
    void main() async {
        final buildEnv = BuildEnvironment.release(
        apiBaseUrl: 'https://domain.release/api',
        );
        // 1. 放到一个可以全局访问的地方
        Get.put(buildEnv);
        mainCom();
    }
    ```
3.  共有代码 `main_com.dart`

    ```dart
    // lib/main_com.dart
    void mainCom() {
      runApp(MyApp());
    }
    ```


<a id="orgaf5f802"></a>

## 运行

1.  命令行 配置 `flutter run lib/main_dev.dart`
2.  Android stuio 配置 在配置文件指定运行main\_ *enviroment*.dart 举个例子测试环境 `lib/main_dev.dart`
3.  Vistual studio 配置 在目录下.vscode/launch.json

    ```json
    {
      "version": "1.0.0",
      "configurations": [
        {
          "program": "lib/main_dev.dart",
          "request": "launch",
          "type": "dart"
        },
        {
          "name": "release",
          "program": "lib/main_release.dart",
          "request": "launch",
          "type": "dart"
        }
      ]
    }
    ```


<a id="org86b69bb"></a>

## 打包

指定想要的文件 `flutter build -t lib/main_dev.dart`


<a id="org9dc697f"></a>

## 点赞、收藏、Star


<a id="org8e5d9f3"></a>

# 附录


<a id="org644e00c"></a>

## 代码仓库

[Github代码仓库](https://github.com/guzishiwo/flutter-switch-environment)


<a id="org56190e1"></a>

## 参考引用

[how-do-i-build-different-versions-of-my-flutter-app-for-qa-dev-prod](https://stackoverflow.com/a/47438620/5617935)
