.PHONY: setup

# Mac ユーザーなど、ホストとコンテナのユーザー情報を合わせたくない場合は
# この setup タスクを実行しないでください
setup:
	echo "host_user_name=${USER}" > .env
	echo "host_group_name=${USER}" >> .env
	echo "host_uid=`id -u`" >> .env
	echo "host_gid=`id -g`" >> .env

.PHONY: k6
k6:
	docker run --rm -i --network otel_sample_default -v "${PWD}/k6-script.js:/k6-script.js" grafana/k6 run /k6-script.js
