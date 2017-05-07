# Angular Quickstart Helper Utility

The Angular team has created a nice [quickstart project](https://github.com/angular/quickstart) project for creating new projects. The project itself has a few extra steps in order to cleanup the project and get rolling. The below function when added to your `~/.zshrc` file will:
* Clone the project into the directory you are currently viewing in your terminal.
* Remove non-essential files for macOS.
* Open the project in [Visual Studio Code](https://code.visualstudio.com/).
* Run `npm install` on the project to pull dependencies.
* Run `npm start` to start the project.

This utility should save you enough time to go get yourself a cup of coffee and have a project setup and ready to go by the time you're back.

## Installation
* Open your terminal and enter the following command:
  * `vim ~/.zshrc`
* Add the following function:
```bash
# Angular Quickstart Setup & Clean
function ngquickstart() {
  git clone https://github.com/angular/quickstart.git $1
  cd $1
  xargs rm -rf < non-essential-files.osx.txt
  rm src/app/*.spec*.ts
  rm non-essential-files.osx.txt
  code .
  npm install
  npm start
}
```
* Quick your terminal.

## Usage
* Open your terminal and make your way to the PARENT directory of where you would like to store your new project.
* Enter the following command:
  * `ngquickstart new-project-directory-name`
* If everything has been setup correctly in a few minutes you should have the project running in the terminal and the code open in [Visual Studio Code](https://code.visualstudio.com/).
