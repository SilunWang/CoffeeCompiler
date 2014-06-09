CoffeeCompiler
==============

[pic]: ./example/img/coffee.png

This is a simplified coffeescript-compiler written in javascript

Our course project in *Architecture of Computer and Network (2)*

&copy;*JIANG Lin-Nan, HONG Yu, WANG Si-Lun*

## Dependency

**Python Watchdog**
```shell
$ pip install watchdog
```
**Jison**
```shell
$ npm install jison -g
```

## Usage
`parser.jison`为词法语法文件，若有变更请进入根目录下运行：
```shell
$ jison parser.jison
```
将`parser.jison`编译生成`parser.js`

进入`./realTime`目录观察coffee实时生成js（需保持Terminal打开）
```shell
./watch.sh
```
realtime中的`parser.js`最后需要添加模块依赖的代码`./realtime/dependency`

## Seeking Solutions
不支持+= ++
不支持(a+b)

