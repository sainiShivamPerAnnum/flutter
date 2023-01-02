build_debug:
	fvm flutter build apk -t lib/main_dev.dart --flavor dev

build_prod:
	fvm flutter build appbundle -t lib/main_prod.dart --flavor prod

