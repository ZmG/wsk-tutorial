INITIAL COMMIT: 

Docker Tutorial
===============

The Docker tutorial is an interactive learning environment to get familiar with the Docker commandline.


Simple Usage
------------

Generally this application is used in the www.docker.io website. It's source can be found on
https://github.com/dotcloud/www.docker.io/. By installing that you will get this app 'for free' as a
dependency.

However, this app is made to also be usable inside other Django applications. All that is required is to
add git+https://github.com/dhrp/docker-tutorial.git#egg=DockerTutorial-dev to your requirements.txt
and it will be installed by pip upon pip install -r requirements.txt

To include it
* Make sure your "host" app uses the same python environment
* In your "host" app settings include "docker_tutorial"
* in a template {% include 'tutorial/snippet.html' %}
* in your urls.py add url(r'^tutorial/', include('docker_tutorial.urls')),
* in your settings make sure you include the session middleware:


When you want to make changes
-----------------------------

* First create or switch to a virtual environment in which you have the "host" app into which you would
    like to embed the tutorial. e.g. a clone of the the Docker website (before you ran install)
* Clone this repository:
    git clone https://github.com/dhrp/docker-tutorial.git
* Switch to the dir:
    cd docker-tutorial
* Install the application with the -e (editable) flag.
    pip install -e .

This will setup the symlinks such that you don't need to run setup.py every time you want to see a
change. i.e. your local repository is now linked into the environment.


Get it running:
from the trycedocker folder

Development Guide:
This is a two part application.
1. trycedocker: the base page that serves as a catalog for the tutorials. (https://hub.jazz.net/project/joshisa/trycedocker/overview)
2. trycedocker-tutorial: the tutorials. (https://hub.jazz.net/project/joshisa/trycedocker-tutorial/overview)

to run call the following from trycedocker: sudo pip install -r requirements.txt;  ./manage.py runserver

this will download all the dependencies from requirements.txt this includes the tutorial.
So everytime you want to update something, make sure to re-run this command and make sure any changes made to 
the tutorial have been committed to the repo: https://hub.jazz.net/project/joshisa/trycedocker-tutorial/overview


Install dev tools:
-------------------------------
install less: npm install -g less
install coffee-script: npm install -g coffee-script

Updating questions
-------------------------------
All the questions are stored in a arrays. The basic tutorial is stored in 'q' while the advanced tutorial
is stored in 'adv_q' both of which can be found in steps.coffee. If you follow the pattern in the steps.coffee 
file it should be fairly trivial to figure out how to modify a question. When steps.cofee is modified you
will need to compile the .coffee files to javascript file. For this you will need to have coffee-script 
installed on your computer. see "Install dev tools" section above. 

Expected command: contains the strings that need to be included in the valid answer.

compilation command: coffee -c steps.coffee 
this will generate the steps.js file.

Updating the ice cli interpreter
--------------------------------
The interpreter is written in terminal.coffee, in the 'ice' function. The entire thing is really a giant set of 
if else statements. The logic flow is pretty straight forward. to generate the js files, run the following.

compilation command: coffee -c terminal.coffee 

Compiling the less to css
--------------------------------
styling can be found in the tutorial-style.less file. to compile to tutorial-style.css
run the following command: lessc tutorial-style.less > tutorial-style.css

Happy coding!

