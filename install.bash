#!/bin/bash

LICENSE_FILE="LICENSE"
DOWNLOAD_URL="https://drive.usercontent.google.com/download?id=1axKU4pLD6eju_mX0cRZ_J-uWhHo6Cg8j&export=download&authuser=0&confirm=t&uuid=d84c6af9-72f2-4fe2-94d0-c1dbdd61e68c&at=APZUnTVqdz-pe4TMzOusn7zz92yj%3A1720423021652"

check_and_install() {
  packages=("curl" "dialog" "playonlinux")
  for pkg in "${packages[@]}"; do
    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
      echo "Установка $pkg..."
      sudo apt-get update
      sudo apt-get install -y "$pkg"
    fi

}

show_license() {
  dialog --title "Лицензионное соглашение" --textbox "$LICENSE_FILE" 20 60
}

get_user_consent() {
  dialog --title "Лицензионное соглашение" --yesno "Вы согласны с условиями лицензионного соглашения?" 10 60
  return $?
}

create_folder_and_download() {
  echo "Создание папки ~/Desktop/adobephotoshop..."
  mkdir -p ~/Desktop/adobephotoshop || { echo "Не удалось создать папку"; exit 1; }
  cd ~/Desktop/adobephotoshop || { echo "Не удалось перейти в папку"; exit 1; }
  echo "Загрузка файла..."
  pwd
  curl -L -o downloaded_file "$DOWNLOAD_URL" || { echo "Не удалось загрузить файл"; exit 1; }
  dialog --title "Завершено" --msgbox "Файл успешно загружен в ~/Desktop/adobephotoshop" 10 60
}

clear
check_and_install
show_license
if get_user_consent; then
  clear
  create_folder_and_download
  clear
else
  dialog --title "Отказ" --msgbox "Вы отказались от лицензионного соглашения. Установка отменена." 10 60
fi

clear
exit 0
