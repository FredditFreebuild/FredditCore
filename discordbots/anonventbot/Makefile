include ../../.config/.env-anonventbot
export

.PHONY: lock
lock:
	npm i --package-lock-only

.PHONY: install
install:
	npm ci

.PHONY: start
start:
	screen -S anonventbot -d -m npm start

.PHONY: stop
stop:
	screen -X -S anonventbot quit

.PHONY: full-start
full-start: lock install start
