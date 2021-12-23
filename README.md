## 这是一个使用 nextflow 实现 deepsign 工具的 demo
nextflow.config 通过该文件配置相关路径
run.sh   通过该文件运行程序

run.sh 运行逻辑
1. 安装 conda
2. 根据 'environment.yaml' 文件，生成一个名为'deepsignalenv' 的环境
3. 执行 main.nf, 进行工作流
