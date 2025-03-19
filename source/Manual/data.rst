data
=====

.. toctree::
   :maxdepth: 2

7.1. DFT相关Win版软件
----------------------

.. data:: 软件

- `VESTA Portable版下载 </download/softwares-win/VESTA>`_ 或 `VESTA官网下载 <https://jp-minerals.org/vesta/en/download.html>`_
   - 用于分子原子尺度建模及VASP输入/输出文件处理。VESTA 3.5.8, built on Aug 11 2022, 17.2MB，Windows 64-bit。

.. data:: Job
   
- 在计算目录下运行，可以计算已完成的VASP、Lobster、CP2K程序或其他Slurm计算任务的总时长。

.. data:: test

   123456
   
   123456789

.. data:: sacct查看历史作业信息

  Usage: ① :code:`sacct -j 12345`

  输出内容包括：作业号，作业名，队列分区，申请的CPU数量，状态，结束代码

  Usage: ② :code:`sacct -P -u mishuodong -S 2022-06-01 -E now --field=jobid, partition, nodelist, jobname, user, start, end, elapsed, state, cputimeraw, workdir`

  查看历史作业的起止时间、结束状态、作业号、作业名、使用的节点数、节点列表、运行时间等
  
  - 一般用法及参数介绍如下：

   -P  指输出为方便程序处理的格式（使用“|”分隔字段）
   -u mishuodong  指查看mishuodong账户的历史作业
   -S  开始查询时间
   -E  截止查询时间

  - :code:`--format` 或 :code:`--field` 定义了输出的格式：

   - jobid是指作业号，partition是指提交队列，user是指账户名，nodelist是节点列表，start是开始运行时间，end是作业退出时间
   
   - elapsed是运行时间，state是作业结束状态，cputimeraw是消耗的机时（核分钟），workdir是任务目录

- sacct --helpformat可以查看支持的输出格式。
- sacct的其他参数选项可通过sacct --help查看。