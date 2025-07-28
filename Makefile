.PHONY: help
help:
	@echo ""
	@echo ""

.PHONY: gen
gen:
	dart run slang
	dart run build_runner build --delete-conflicting-outputs
	dart run build_runner build --define=envied_generator:envied=path=.env --delete-conflicting-outputs
# 	protoc --dart_out=grpc:lib/protobuf -I=. protos/v1/* google/protobuf/timestamp.proto

.PHONY: watch
watch:
	dart run build_runner watch

.PHONY: build
build:
	flutter build apk --release --no-tree-shake-icons --obfuscate --split-debug-info=build/app/outputs/symbols
	flutter build appbundle --release --no-tree-shake-icons --obfuscate --split-debug-info=build/app/outputs/symbols
