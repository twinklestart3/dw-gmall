#!/bin/bash
# $1:遍历延时时间 $2:遍历次数
for host in hadoop222 hadoop223 ; do
    echo ========== $host ==========
    ssh $host "source /etc/profile ; nohup java -jar /opt/dw0722/data-producer/data-producer-1.0-SNAPSHOT-jar-with-dependencies.jar $1 $2 >/dev/null 2>&1 &"
done

# nohup
#用途：不挂断地运行命令。
#
#语法：nohup Command [ Arg … ] [　& ]
#
#描述：nohup 命令运行由 Command 参数和任何相关的 Arg 参数指定的命令，忽略所有挂断（SIGHUP）信号。在注销后使用 nohup 命令运行后台中的程序。要运行后台中的 nohup 命令，添加 & （ 表示“and”的符号）到命令的尾部。
#
#操作系统中有三个常用的流：
#
#0：标准输入流 stdin
#1：标准输出流 stdout
#2 ：标准错误流 stderr
#一般当我们用 > console.txt，实际是 1>console.txt的省略用法；< console.txt ，实际是 0 < console.txt的省略用法。
#
#解释：
#
#带&的命令行，即使terminal（终端）关闭，或者电脑死机程序依然运行（前提是你把程序递交到服务器上)；
#
#2>&1的意思
#　　这个意思是把标准错误（2）重定向到标准输出中（1），而标准输出又导入文件output里面，所以结果是标准错误和标准输出都导入文件output里面了。 至于为什么需要将标准错误重定向到标准输出的原因，那就归结为标准错误没有缓冲区，而stdout有。
#
#最后谈一下/dev/null文件的作用，这是一个无底洞，任何东西都可以定向到这里，但是却无法打开。 所以一般很大的stdou和stderr当你不关心的时候可以利用stdout和stderr定向到这里>./command.sh >/dev/null 2>&1

