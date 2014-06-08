CoffeeCompiler
==============

A coffeescript compiler written in javascript

dependency:

| ***Python Watchdog*** |
| ***Jison*** | ./$ npm install jison 
| ***Node*** |  

./$ parser.js: jison parser.jison 编译生成parser.js
./realTime$ ./watch.sh 后台运行

realtime中的parser.js最后需要添加模块依赖的代码./realtime/dependency

问题：
不支持+= ++
函数只支持0参数或者两个以上参数，一个会有歧义 急需！
不支持a.b()函数调用 急需！

