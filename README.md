where_are_kittens
=================

Geohashing application boilerplate on Perl and AngularJS.

This code can be useful as a start for geohashing applications. From the box it provides API for markers manipulation  and simple AngularJS frontend, that can be styled for
different kinds of specialized applications.

TECHNOLOGIES
------------
* Backend language - Perl
* Database - MongoDb
* Web frontend - AngularJS

PREREQUISITES
-------------
In order to run backend part you need perl installation >= 5.10, and mongodb.
To run and develop frontend you need node and yeoman.


INSTALLATION
------------
Go to the project directory
cd project_folder

Install dependencies via cpanm
cpanm --installdeps .

If you want to use JS frontend,  you have to populate dependencies in  resources/static/js
with help of bower tool.
cd resources/static/js
bower install

When all dependencies are installed application can be run with this command from project directory
perl -I ~/perl5/lib/perl5/ -I lib/ ~/perl5/bin/plackup -R ./lib/ -R scripts/  scripts/app_dev.
It will appear by address http://127.0.0.1:5000/js/app/index.html

LICENSE
--------
Apache License Version 2.0