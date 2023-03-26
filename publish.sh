#!/usr/bin/env bash

#用户编译与打包服务端部署zip包
#使用方式：./publish.sh 1.0.0
#1.0.0为zip文件名，如果不指定参数，则按时间生成zip包

#只做拷贝的文件夹
copy_src_arr=("bin" "conf" "libs" "proto")
#需要编译的文件夹
build_src_arr=("service" "lualib" "const" "model" "controller" "business")

#输出路径
root_dir=`pwd`
publish_dir=${root_dir}/publish
pack_name=$(date +%Y%m%d%H%M%S)
#lua编译器
lua_c=luac

if [ ${#} == 1 ] ; then
    pack_name=${1}
fi

#发布目录清理与创建
`rm -rf ${publish_dir}`
`mkdir -p ${publish_dir}`

#拷贝文件
for directory in ${copy_src_arr[@]}
do
   `cp -R ${directory} ${publish_dir}`
   echo "...copy directory：${directory} success!"
done

#编译文件
for directory in ${build_src_arr[@]}
do
    lua_files=`find ${directory} -name "*.lua"`
    for file in ${lua_files}
    do
        filename=`basename ${file}`
        path=`dirname ${file}`
        out_path=${publish_dir}/${path}
        `mkdir -p ${out_path}`
        `${lua_c} -o ${out_path}/${filename} ${file}`
        echo "...build: ${out_path}/${filename} success!"
    done
done

#打包
cd ${publish_dir} && zip -r -q ./${pack_name}.zip ./* && cd ${root_dir} && echo "...packing zip success!"

#清理
cd ${publish_dir} && rm -rf `ls | grep -v ${pack_name}.zip` && echo "Execution completed!"