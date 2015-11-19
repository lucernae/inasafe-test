SHELL := /bin/bash
PROJECT_ID := inasafetest


build:
	@docker-compose -p ${PROJECT_ID} build

inasafetest: build
	@docker-compose -p ${PROJECT_ID} up -d inasafetest

inasafetravis: build
	@docker-compose -p ${PROJECT_ID} up -d inasafetravis

kill:
	@docker-compose -p ${PROJECT_ID} kill

rm:
	@docker-compose -p ${PROJECT_ID} rm
