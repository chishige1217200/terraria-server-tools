#!/bin/bash

# このファイル及びdiscordhook.shは/home/terraria/serverに置かれている前提です

#サーババイナリ
#バージョン
VER=1449
#絶対パス
BIN=/home/terraria/server/bin/${VER}/Linux/TerrariaServer.bin.x86_64
#Configファイルの絶対パス
CONFIG=/home/terraria/server/serverconfig.txt
#screenでの識別名を指定
SCREEN_NAME='terraria'
#サーバ終了時の猶予時間を指定
WAIT=30

cd $(dirname $0)
#general
if [ $# -eq 0 ] || [ "$1" = "start" ]; then
    echo "Server is starting..."
    if [ -f ${BIN} ]; then
        ./discordhook.sh start
        screen -UAmdS ${SCREEN_NAME} ${BIN} -config ${CONFIG}
    else
        echo "Server binary not found."
    fi
elif [ "$1" = "stop" ]; then
    echo "Server will stop in '${WAIT} seconds'..."
    ./discordhook.sh stop
    screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff "say '${WAIT}'秒後にサーバーを停止します\015"'
    sleep $WAIT
    screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff "exit\015"'
    echo "Server stopped."
#save
elif [ "$1" = "save" ]; then
    screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff "save\015"'
#security
elif [ "$1" = "kick" ] && [ $# -eq 2 ]; then
    screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff "kick '$2'\015"'
elif [ "$1" = "ban" ] && [ $# -eq 2 ]; then
    screen -p 0 -S ${SCREEN_NAME} -X eval 'stuff "ban '$2'\015"'
#download server.zip(1.4.4.9)
elif [ "$1" = "download" ]; then
    curl -OL https://terraria.org/api/download/pc-dedicated-server/terraria-server-1449.zip
#screen
elif [ "$1" = "attach" ]; then
    screen -r ${SCREEN_NAME}
fi
