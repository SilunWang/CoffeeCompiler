CoffeeCompiler
==============

            {
         }   }   {
        {   {  }  }
         }   }{  {
        {  }{  }  }                    _____       __  __
       { }{ }{  { }                   / ____|     / _|/ _|
     .- { { }  { }} -.               | |     ___ | |_| |_ ___  ___
    (  { } { } { } }  )              | |    / _ \|  _|  _/ _ \/ _ \
    |`-..________ ..-'|              | |___| (_) | | | ||  __/  __/
    |                 |               \_____\___/|_| |_| \___|\___|
    |                 ;--.
    |                (__  \            _____           _       _
    |                 | )  )          / ____|         (_)     | |
    |                 |/  /          | (___   ___ _ __ _ _ __ | |_
    |                 (  /            \___ \ / __| '__| | '_ \| __|
    |                 |/              ____) | (__| |  | | |_) | |_
    |                 |              |_____/ \___|_|  |_| .__/ \__|
     `-.._________..-'                                  | |
                                                        |_|


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
`./parser.jison`为词法语法文件，若有变更请进入根目录下运行：
```shell
$ jison parser.jison
```
将`./parser.jison`编译生成`./parser.js`
在windows下，您可以访问 http://zaach.github.io/jison/try/ 在线编译并download `parser.js`

## Display

Linux下，您可以进入`./realTime`目录输入下面命令，观察coffee实时生成js（需保持Terminal打开）
```shell
$ ./watch.sh
```
Windows下，您可以进入`./example`目录打开index.html网页，实时编译coffeescript语句

## Seeking Solutions
不支持+= ++
不支持(a+b)

