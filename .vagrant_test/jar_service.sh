#!/bin/sh
SERVICE_NAME=MyService
PATH_TO_JAR=helloworld-spring-1.4.jar
PID_PATH_NAME=/tmp/MyService-pid
case $1 in
    install)
    echo "Creating Service "
    cat <<EOF > /etc/systemd/system/"$SERVICE_NAME".service
[Unit]
Description = Java Service
After=syslog.target network.target

[Service]
Type = forking
ExecStart = /usr/local/bin/MyService.sh start
ExecStop = /usr/local/bin/MyService.sh stop
ExecReload = /usr/local/bin/MyService.sh reload

[Install]
WantedBy=multi-user.target
EOF
    ;;
    start)
        echo "Starting $SERVICE_NAME ..."
        if [ ! -f $PID_PATH_NAME ]; then
            nohup java -jar $PATH_TO_JAR /tmp 2>> /dev/null >> /dev/null &
                        echo $! > $PID_PATH_NAME
            echo "$SERVICE_NAME started ..."
        else
            echo "$SERVICE_NAME is already running ..."
        fi
    ;;
    stop)
        if [ -f $PID_PATH_NAME ]; then
            PID=$(cat $PID_PATH_NAME);
            echo "$SERVICE_NAME stoping ..."
            kill $PID;
            echo "$SERVICE_NAME stopped ..."
            rm $PID_PATH_NAME
        else
            echo "$SERVICE_NAME is not running ..."
        fi
    ;;
    restart)
        if [ -f $PID_PATH_NAME ]; then
            PID=$(cat $PID_PATH_NAME);
            echo "$SERVICE_NAME stopping ...";
            kill $PID;
            echo "$SERVICE_NAME stopped ...";
            rm $PID_PATH_NAME
            echo "$SERVICE_NAME starting ..."
            nohup java -jar $PATH_TO_JAR /tmp 2>> /dev/null >> /dev/null &
                        echo $! > $PID_PATH_NAME
            echo "$SERVICE_NAME started ..."
        else
            echo "$SERVICE_NAME is not running ..."
        fi
    ;;
esac