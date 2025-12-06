.PHONY: setup

# Mac ユーザーなど、ホストとコンテナのユーザー情報を合わせたくない場合は
# この setup タスクを実行しないでください
setup:
	echo "host_user_name=${USER}" > .env
	echo "host_group_name=${USER}" >> .env
	echo "host_uid=`id -u`" >> .env
	echo "host_gid=`id -g`" >> .env
