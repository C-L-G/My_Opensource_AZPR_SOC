![signed](https://raw.githubusercontent.com/FPGA1988/resource/master/picture/prj_azpr_soc.png)

# 1 工程简介
本项目来自&lt;&lt;CPU自制入门>>的项目实现
## 1.1 [读者支持网页](http://gihyo.jp/book/2012/978-4-7741-5338-4/support)
本书的作者是来自日本的[水头一寿]()等，本来以为以这本书的年纪，相关的资料已经不复存在，没想到到了网站上之后，依旧有很多资料。不过全都是日文，所以特意把相关的资料直接搬到这里来：

### 1.1.1 下载
- 第一章  
说明书                  : [AZPR_datasheet_1.01.pdf]()  
RTL                    : [AZPR_RTL.zip]()  
[模块化层次表]()    
[文件层次表]()  

- 第二章  
FPGA基板的Eagle数据      : [AZPR_FPGA.zip]()  
电源基板的Eagle数据      : [AZPR_POW.zip]()  
AZPR EvBoard元件库       : [lib.zip]()  
[Eagle文件的使用方法]()  
FPGA基板的3D显示         : [AZPR_3D.zip]()

- 第三章
源代码                  : [Sample_Program.zip]()  
汇编程序                : [azprasm.zip]()   
UrJTAG的设定文件        : [UrJTAG_Setting.zip]()  
bit/mcs/svf文件         : [AZRP_EvBoard_Diag.zip]()  
约束文件                : [AZPR_EvBoard.ucf]()  

### 1.1.2 书籍相关

 [**书籍简介**](http://product.dangdang.com/23382868.html)<br>

# 2 工程结构
----------------------------------------------------------------
* **----branches**
* **----tags**
* **----trunk**
* **----trunk/apr**
* **----trunk/digital**
* **----trunk/digital/verif**
* ..
* **----trunk/fpga**
* **----trunk/fpga/simulate**
* **----trunk/fpga/simulate/tb**
* **----trunk/fpga/simulate/tc**
* **----trunk/fpga/simulate/model**
* **----trunk/fullchip**
* ..
----------------------------------------------------------------    
# 3 更新记录
```
yyyy.mm.dd - Author - xxxx  
2016.12.28 - 离场悲剧 - 上传书籍原始RTL到digital/azpr_soc,将readme的换行方式改为"空格+空格+回车的方式".  
2016.12.24 - 离场悲剧 - 初步的modelsim仿真环境搭建完毕，接下来准备test case.  
2016.12.08 - 离场悲剧 - 修改RTL并在ISE下完成初步的综合.  
2016.12.03 - 离场悲剧 - 更改目录结构,添加gitignore文件来对.DS_Store进行忽略.  
2016.12.02 - 离场悲剧 - 添加testbench组件 : mon sb drv and interface.  
2016.12.01 - 离场悲剧 - 添加testbench组件 : env and gen.  
2016.12.01 - 离场悲剧 - 删除大部分RTL的乱码注释,修改_为_n.  
2016.12.01 - 离场悲剧 - 更新部分FPGA仿真环境的tb top以及部分rtl的coding style.  
2016.11.25 - 离场悲剧 - 更新部分rtl的coding style.  
2016.11.22 - 离场悲剧 - 根据网上下载到的RTL更新剩余的代码,准备后续修改结构以及coding style.  
2016.11.22 - 离场悲剧 - 更新gpr.v和spm.h.  
2016.11.22 - 离场悲剧 - 更新cpu.h和isa.h.  
2016.11.22 - 离场悲剧 - 更新总线模块,更新rom模块.  
```
----------------------------------------------------------------
# 4 其他 
如果有任何问题，可以与我联系 ：
你可以给<303526279@qq.com>发邮件。<br>
当然如果你需要任何帮助，那么你可以点击`帮助`按钮进行相关查询。 

***

![signed](https://raw.githubusercontent.com/C-L-G/scripts/master/resource/picture/signed.png) 
