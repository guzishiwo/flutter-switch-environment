- [引言](#org44514ed)
- [实现方案](#orgf7e486d)
  - [基本思路](#orge5deec7)
  - [目录结构](#orgb10e2de)
  - [定义配置类](#org92e8738)
  - [初始化](#orge186bea)
  - [运行](#orge3557be)
  - [打包](#org0be5ffe)
- [参考引用](#org5d228ff)



<a id="org44514ed"></a>

# 引言

APP开发中经常会碰到至少两个不同的环境: 一个测试环境，一个生产环境。 那如何在我们就测试开发后，不破坏现有的代码，切换到不同的环境呢？ fluter官方并没有给出推荐的方案, 在寻找使用不同的方式，认为多个main\_ *enviroment*.dart 是最优雅的办法。


<a id="orgf7e486d"></a>

# 实现方案


<a id="orge5deec7"></a>

## 基本思路

在项目lib目录下创建不同的 `main_enviroment.dart` 文件,来区分不同的环境, 而每个main\_<enviroment>.dart 包含不同的初始化配置, 开始全局注册


<a id="orgb10e2de"></a>

## 目录结构

```shell
lib/main_com.dart  # 共有main_com文件
lib/main_dev.dart  # 测试环境
lib/main_release.dart  # 生产环境
```


<a id="org92e8738"></a>

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


<a id="orge186bea"></a>

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


<a id="orge3557be"></a>

## 运行

1.  命令行 配置 `flutter run main_dev.dart`
2.  Android stuio 配置 在配置文件指定运行main\_ *enviroment*.dart 举个例子测试环境 `lib/main_dev.dart`
3.  Vistual studio 配置 在目录下.vscode/launch.json

    ```json
    {
      "version": "1.0.0",
      "configurations": [
        {
          "
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


<a id="org0be5ffe"></a>

## 打包

指定想要的文件 `flutter build -t lib/main_dev.dart`


<a id="org5d228ff"></a>

# 参考引用

1.  [how-do-i-build-different-versions-of-my-flutter-app-for-qa-dev-prod](https://stackoverflow.com/a/47438620/5617935)
