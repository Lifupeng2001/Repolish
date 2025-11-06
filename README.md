# VDJ analysis
##Just recording VDJ analysis learning\
###随意记录，当今的VDJ生态主流软件并没有像转录组那么完整，就是想全面记录自己的学习过程与心得\
华大的下机fastq比对是通过TRUST4 软件进行，其比对结果文件网址说明文档：https://lishuangshuang0616.github.io/DNBelab_C_Series_HT_scRNA-analysis-software/Document/doc/outs/scVDJ.html 由李双双完成
从结果文件到Immcantation生态需要部署环境，挺麻烦的，根据Chang-O官方教程会出很多问题，需要注意的是：（1）Igblast数据库的部署（2）重链轻链的重新注释（3）整合和拆分文件（4）克隆阈值的确定
如果华大的下机fastq比对是由MIXCR软件进行就好了，流程上就能好很多，不知道是出于什么原因，可能需要对标10x，关于上述问题解决已经上传至code，持续更新中...\

VDJ 学习网站：https://www.sc-best-practices.org/air_repertoire/\
VDJ 学习综述：Adaptive immune receptor repertoire analysis[Nature Reviews Methods Primers,2024]、Single-cell immune repertoire analysis[Nat Methods,2024]\

已经系统性学习：（1）scRepertoire(2)scirpy  这两款软件侧重点各有不同，都是基础分析，配合转录组把故事讲清楚就可以发一篇不错的文章。scRepertoire的画图十分好看，分析也比较多，但是现在还做不了体细胞高突变，但是已经慢慢的将Immcantation 加入里面了，scirpy做的内容比较浅、可视化呈现也没那么好，可与Dandelion接入\
下一步学习：（1）CONGA(正在学习)(2)Bennessi (3)Dandelion (4)Immcantion（体细胞高突变与类别重组转换部分） \
