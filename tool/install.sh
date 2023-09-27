#!/bin/sh

# trap ctrl-c and call ctrl_c()
trap ctrl_c INT

ctrl_c() {
  exit
}

echo "flutter pub get"

packages=("packages/core" "packages/core_ui")
for package in "${packages[@]}"; do :
  (
    cd "$package" || exit ;
    echo "flutter pub get $package"
    flutter pub get
  )
done

cd "apps/valsco_app"
echo "flutter pub get in apps/valsco_app"
flutter pub get