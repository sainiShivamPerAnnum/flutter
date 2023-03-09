CWD=$(pwd)

brew tap leoafarias/fvm && brew install fvm && dart pub global deactivate fvm && dart pub global activate fvm && fvm install 3.3.8 && fvm use 3.3.8
