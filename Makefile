
all: ui db

ui:
	make -C fe

db:
	make -C be

docker: ui db
	docker build -t orgtool .

publish: docker
	docker tag orgtool orgtool/orgtool:sc
	docker push orgtool/orgtool:sc
