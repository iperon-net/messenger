.PHONY: help
help:
	@echo ""
	@echo ""

.PHONY: gen
gen:
	dart run build_runner build --delete-conflicting-outputs
	dart run slang

	protoc --dart_out=grpc:lib/protobuf -I=. protos/* google/protobuf/timestamp.proto google/protobuf/empty.proto
	#dart run build_runner clean
	#dart run build_runner build --define=envied_generator:envied=path=.env --delete-conflicting-outputs
	#dart run slang


.PHONY: watch
watch:
	dart run build_runner watch

.PHONY: build
build:
	flutter build apk --release --no-tree-shake-icons --obfuscate --split-debug-info=build/app/outputs/symbols
	flutter build appbundle --release --no-tree-shake-icons --obfuscate --split-debug-info=build/app/outputs/symbols
