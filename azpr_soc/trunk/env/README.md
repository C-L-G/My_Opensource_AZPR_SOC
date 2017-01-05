# 1.说明  
本文件夹用于对整个工程进行环境变量以及自定义命令等的定义，本文件夹包含以下三个文件 :   

- initial.env   

- envset.pl  

- azpr_soc.env  

# 2.脚本分析  

设置分为三步，下面将对这三步对应的脚本分别进行分析  

## 2.1 STEP1 : initial.env  
本脚本是执行环境设置的第一个脚本，它里面包含了下面两个脚本的调用 ：  

```
#! /bin/csh/ -f
perl envset.pl
source azpr_soc.env
```

## 2.2 STEP2 : envset.pl  
本脚本采用perl语言编写，会根据不同的project产生不同的env环境设置文件 : azpr_soc.env  
```

```

## 2.3 STEP3 : azpr_soc.env  
本文件是最终的设置文件，直接source即可  
