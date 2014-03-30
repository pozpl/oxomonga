where_are_kittens
=================

Where Are Kittens is a boilerplate for Perl, MongoDB and AngularJS projects with example of geohashing functionality.

This code can be useful as a start for modern web applications with a stack of auxiliary technologies and frameworks to
speed up development.
Out of the the box it provides integration of libraries in core functionality along with a useful programming
model that can be utilized to build robust and extensible products.
As an example the project contained API for geohashing markers manipulation and simple AngularJS frontend, that can be styled for
different kinds of specialized applications.

TECHNOLOGIES
------------
* Backend language - Perl
* Database - MongoDb
* Web frontend - AngularJS, Bootstrap

The backend part is based on [OX](https://github.com/iinteractive/OX)  web framework. The main features of this framework is
usage of Dependency Injection pattern and PSGI support. Due to DI paradigm we can achieve decoupling of components and
good modularity. PSGI make this framework compatible with modern perl web techniques and technologies including wide
variety of application servers such as starman and twiggy.

PREREQUISITES
-------------
In order to run backend part you need perl >= 5.10 installed, and mongodb.
To run and develop frontend you need node and yeoman.


INSTALLATION
------------
Go to the project directory
*cd project_folder*

Install dependencies via cpanm

*cpanm --installdeps .*

If you want to use JS frontend,  you have to populate dependencies in  resources/static/js
with help of bower tool.

*cd resources/static/js*

*bower install*

When all dependencies are installed application can be run with this command from project directory

*perl -I ~/perl5/lib/perl5/ -I lib/ ~/perl5/bin/plackup -R ./lib/ -R scripts/  scripts/app_dev.psgi*

This run command assumes that all your dependencies are installed by non root user via cpanm + liblocal
It will appear on address *[http://127.0.0.1:5000/](http://127.0.0.1:5000/)*

LICENSE
--------
Apache License Version 2.0