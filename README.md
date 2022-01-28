 

# Automateinstall

## About

English Description:

If you use markdown to record tools which recommand from the internet, you can use this shell  to auto install your tools(based on some rules)......



中文简介:

以固定规则(模板)来下载你的.md文件中记录的github项目.该脚本可用于自动化下载您笔记中的工具集,并自动分类.默认根目录名为.md的文件名,然后目录的树结构与.md文件中的二三级标题的树结构保持一致.

备注:

- 暂不支持标题中的'/'符号 
- 脚本后缀带CN的clone地址会使用github的镜像加速

## Rule

the default rules is:

- `##` : Identify the Topic of tool, this will create directory and use this title as directory name
- `###` :Identify the tools which belong to the topic,One topic has multi tools,and bash will read github's link and clone it to the "topic's directory"  as output

you can also make the rule by youself....(to-do)



![image-20220128192808075](https://cdn.jsdelivr.net/gh/1dayluo/PicGo4Blog/data/image-20220128192808075.png)
