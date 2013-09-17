Vagrant Dart Build System
=========================
Vagrant script to create a VM that matches Heroku version.

Install
=======
- Install Virtual Box https://www.virtualbox.org/
- Install Vagrant http://www.vagrantup.com/

- `git clone https://github.com/selkhateeb/heroku-vagrant-dart-build.git`
- `cd heroku-vagrant-dart-build`
- Create and boot the VM `vagrant up`
- Login the VM `vagrant ssh`
- Install/Compile/Build dart `/vagrant/build_dart.sh`
- Once completed `logout` the VM

if all steps are completed successfully, a `dart-sdk.tar` file should be created in 
`heroku-vagrant-dart-build` directory

