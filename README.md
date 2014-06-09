CoffeeCompiler
==============

This is a simplified coffeescript-compiler written in javascript
Our course project in *Architecture of Computer and Network (2)*
&copy;JIANG Lin-Nan, HONG Yu, WANG Si-Lun

## Dependency

| ***Python Watchdog*** |
```shell
$ pip install watchdog
```
| ***Jison*** |
```shell
$ npm install jison -g
```

## Usage
根目录下运行：
```shell
jison parser.jison
```
将parser.jison编译生成parser.js
进入./realTime目录观察coffee实时生成js（需保持Terminal打开）
```shell
./watch.sh
```
realtime中的parser.js最后需要添加模块依赖的代码./realtime/dependency

## Seeking Solutions
不支持+= ++
函数只支持0参数或者两个以上参数，一个会有歧义 急需！
不支持a.b()函数调用 急需！

