build_debug_appbundle:
	fvm flutter build appbundle -t lib/main_dev.dart --flavor dev

build_prod_appbundle:
	fvm flutter build appbundle -t lib/main_prod.dart --flavor prod

build_debug_app:
	fvm flutter build apk -t lib/main_dev.dart --flavor dev

build_dev_release_app:
	fvm flutter build apk -t lib/main_dev.dart --flavor dev --release

build_prod_app:
	fvm flutter build apk -t lib/main_prod.dart --flavor prod

gen:
	sh scripts/gen.sh

setup:
	sh scripts/setup.sh

get:
	sh scripts/get.sh

setup_ios:
	sh scripts/setup_ios.sh